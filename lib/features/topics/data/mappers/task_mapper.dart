import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

abstract final class TaskMapper {
  static Task? tryFromMap(String id, Map<String, dynamic> data) {
    try {
      return fromMap(id, data);
    } on FormatException {
      return null;
    }
  }

  static Task fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      type: _enumByName(TaskType.values, data['type']),
      difficulty: _enumByName(Difficulty.values, data['difficulty']),
      question: _required(data, 'question'),
      answer: _required(data, 'answer'),
      expr: _optional(data, 'expr'),
      equation: _optional(data, 'equation'),
      variable: _optional(data, 'variable'),
      solutionExpr: _optional(data, 'solution_expr'),
      unit: _optional(data, 'unit'),
    );
  }

  static String _required(Map<String, dynamic> data, String key) {
    return _optional(data, key) ?? (throw FormatException('no $key'));
  }

  static String? _optional(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    final text = '$value'.trim();
    if (text.isEmpty) {
      return null;
    }
    return text;
  }
}

T _enumByName<T extends Enum>(List<T> values, Object? name) {
  for (final value in values) {
    if (value.name == name) {
      return value;
    }
  }
  throw FormatException('unknown value "$name"');
}
