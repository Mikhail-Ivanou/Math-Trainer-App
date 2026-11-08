import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/llm/aiai_llm_client.dart';
import 'package:math_trainer_app/core/llm/llm_config.dart';
import 'package:math_trainer_app/features/topics/data/mappers/task_mapper.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/generation.dart';
import 'package:math_trainer_app/features/topics/domain/verification/task_verifier.dart';

@LazySingleton(as: TaskGenerator)
final class TaskGeneratorImpl implements TaskGenerator {
  @factoryMethod
  factory TaskGeneratorImpl() => TaskGeneratorImpl._(loadLlmConfig());

  TaskGeneratorImpl._(LlmConfig config)
    : _config = config,
      _client = AiaiLlmClient(config);

  TaskGeneratorImpl.client(this._config, this._client);

  final LlmConfig _config;
  final AiaiLlmClient _client;

  @override
  bool get isConfigured => _config.isConfigured;

  @override
  Future<GenerationResult> generate(GenerationRequest request) async {
    final reply = await _client.complete(
      system: _systemPrompt(request),
      user: _userPrompt(request),
    );
    final tasks = <Task>[];
    final rejected = <String>[];
    for (final raw in _parseGeneratedTasks(reply.content)) {
      try {
        if (raw is! Map) {
          rejected.add('not an object');
          continue;
        }
        final task = TaskMapper.fromMap('', {
          ...Map<String, dynamic>.from(raw),
          'difficulty': request.level.name,
        });
        final verdict = verifyTask(task);
        final reason = verdict.reason;
        if (reason == null && _fitsFirestore(task)) {
          tasks.add(task);
        } else {
          rejected.add(reason ?? 'task is outside the Firestore limits');
        }
      } on FormatException catch (error) {
        rejected.add(error.message);
      }
    }
    if (rejected.isNotEmpty) {
      log(
        'Rejected ${rejected.length} generated tasks\n${rejected.join('\n')}',
        name: 'TaskGenerator',
      );
    }
    return GenerationResult(
      tasks: tasks,
      rejectedCount: rejected.length,
      model: reply.model,
    );
  }
}

List<Object?> _parseGeneratedTasks(String content) {
  final start = content.indexOf('{');
  final end = content.lastIndexOf('}');
  if (start < 0 || end <= start) {
    throw const GenerationFailure(GenerationProblem.empty);
  }
  try {
    final decoded = jsonDecode(content.substring(start, end + 1));
    if (decoded is Map) {
      final tasks = decoded['tasks'];
      if (tasks is List) {
        return tasks;
      }
    }
  } on FormatException {
    throw const GenerationFailure(GenerationProblem.empty);
  }
  throw const GenerationFailure(GenerationProblem.empty);
}

bool _fitsFirestore(Task task) {
  return task.question.length >= 3 &&
      task.question.length <= 1000 &&
      task.answer.isNotEmpty &&
      task.answer.length <= 100;
}

const _mathLike = {'math', 'algebra', 'geometry'};

Map<TaskType, int> batchCounts(String subject, Difficulty level) {
  return switch ((subject, level)) {
    ('geometry', Difficulty.expert) => {TaskType.word: 6},
    ('geometry', _) => {TaskType.word: 8},
    (final other, Difficulty.expert) when !_mathLike.contains(other) => {
      TaskType.word: 6,
    },
    (final other, _) when !_mathLike.contains(other) => {TaskType.word: 8},
    ('algebra', Difficulty.expert) => {
      TaskType.expression: 1,
      TaskType.equation: 2,
      TaskType.simplify: 2,
      TaskType.word: 1,
    },
    ('algebra', _) => {
      TaskType.expression: 2,
      TaskType.equation: 2,
      TaskType.simplify: 3,
      TaskType.word: 1,
    },
    (_, Difficulty.expert) => {
      TaskType.expression: 2,
      TaskType.equation: 2,
      TaskType.word: 2,
    },
    _ => {TaskType.expression: 3, TaskType.equation: 2, TaskType.word: 3},
  };
}

String _systemPrompt(GenerationRequest request) =>
    '''
Ты — методист и учитель ${_subjectName(request.subject)} ${request.grade} класса (Беларусь). Ты составляешь тренировочные задания для ученика на одно конкретное правило, которое тебе дают.
Правила:
- используй только то, что ученик ${request.grade} класса уже знает к этой теме: правило темы и материал прошлых классов;
- формулировки на русском языке, понятные ученику ${request.grade} класса;
- текст задания (question) должен быть полным: ученик видит только его, поэтому выражение или уравнение пиши прямо в question;
- в question числа с пробелом между классами (12 450), десятичная запятая (2,5), знаки ·, :, −;
- все задания одного уровня — того, что указан в запросе; разные по сюжету и приёму, без повторов;
- ответ к каждому заданию обязателен и должен быть верным — перепроверь вычисления.
Верни только JSON без пояснений и без markdown.''';

String _userPrompt(GenerationRequest request) {
  final counts = batchCounts(request.subject, request.level);
  final total = counts.values.fold(0, (sum, count) => sum + count);
  final lines = [
    for (final entry in counts.entries)
      if (entry.value > 0)
        '- ${entry.value} заданий type "${entry.key.name}" — ${_typeHint(entry.key, request.subject)}',
  ];
  final context = request.context.isEmpty
      ? ''
      : '''
Параграф учебника, из которого это правило (только чтобы понимать, что ученик уже знает):
<<<
${request.context}
>>>
''';
  return '''
Правило «${request.topicTitle}»:
<<<
${request.rule}
>>>
$context
Составь $total новых заданий, каждое из которых тренирует именно это правило.
Уровень всех заданий — ${_levelForModel(request.level)}. В поле difficulty у всех пиши "${request.level.name}".
${lines.join('\n')}

Поля для проверки ответа (их видит только программа):
- answer — число без пробелов: целое «12450», десятичная дробь «2.5», обыкновенная «-7/3» (смешанное число пиши неправильной дробью); для simplify — упрощённое выражение;
- expr, equation, solution_expr — выражения только из чисел, переменных (одна буква), + - * / ^ и скобок, например «(2.5+3/4)*4», «3(x-2)+1=10», «(a+b)^2».

Формат ответа:
{"tasks": [
  {"type": "expression", "difficulty": "${request.level.name}", "question": "Вычислите: 1 234 + 5 678", "expr": "1234+5678", "answer": "6912"},
  {"type": "equation", "difficulty": "...", "question": "Решите уравнение: 3x − 4 = 11", "equation": "3x-4=11", "variable": "x", "answer": "5"},
  {"type": "simplify", "difficulty": "...", "question": "Упростите выражение: 2a + 3a − b", "expr": "2a+3a-b", "answer": "5a-b"},
  {"type": "word", "difficulty": "...", "question": "...", "solution_expr": "выражение, дающее ответ", "answer": "42", "unit": "км"}
]}''';
}

String _typeHint(TaskType type, String subject) {
  return switch (type) {
    TaskType.expression => 'вычислить значение числового выражения',
    TaskType.equation => 'решить уравнение с одной переменной (один корень)',
    TaskType.simplify =>
      'упростить выражение с переменными (раскрыть скобки, привести подобные)',
    TaskType.word =>
      _mathLike.contains(subject)
          ? 'текстовая задача с числовым ответом'
          : 'расчётная задача по теме с числовым ответом; в unit — единица ответа (м/с, Н, г, моль…); в solution_expr — вычисление ответа из чисел условия',
  };
}

String _levelForModel(Difficulty level) {
  return switch (level) {
    Difficulty.easy => 'лёгкий: правило в один шаг, небольшие числа',
    Difficulty.medium =>
      'средний: как основные задания учебника — правило применяется в 2–3 шага, числа побольше, есть скобки и порядок действий',
    Difficulty.hard =>
      'сложный: 3–5 шагов, правило нужно сочетать с ранее изученным, числа неудобные, формулировка непрямая, есть ловушки (типичные ошибки учеников); текстовые задачи — в несколько действий',
    Difficulty.expert =>
      'максимальный: задания повышенной трудности и олимпиадного типа для сильных учеников этого класса. '
          'Главное — не длина, а идея: задание решается быстро, если догадаться, как применить правило, и долго или никак, если считать в лоб. '
          'Приёмы: «вычислите удобным способом» с числами вида 99, 101, 999, 1 001, 2 024; «не вычисляя, найдите»; '
          'вынести общий множитель, сгруппировать, свернуть или разложить по правилу, заметить, что выражение равно нулю или круглому числу; '
          'уравнения, которые сводятся к простому только после применения правила; текстовые задачи, где правило даёт короткое решение вместо долгого счёта. '
          'Не делай задание сложным за счёт длинных вычислений и лишних шагов. '
          'Всё решается знаниями ученика этого класса, без формул из старших классов, ответ однозначный',
  };
}

String _subjectName(String subject) {
  return switch (subject) {
    'math' => 'математики',
    'algebra' => 'алгебры',
    'geometry' => 'геометрии',
    'physics' => 'физики',
    'chemistry' => 'химии',
    'biology' => 'биологии',
    'informatics' => 'информатики',
    'geography' => 'географии',
    'astronomy' => 'астрономии',
    _ => 'предмета',
  };
}
