import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

/// Document body accepted by the Firestore rule for an app-created task.
Map<String, Object> generatedTaskData({
  required Task task,
  required String userId,
  required String model,
  required Object createdAt,
}) {
  final data = <String, Object>{
    'type': task.type.name,
    'difficulty': task.difficulty.name,
    'question': task.question,
    'answer': task.answer,
    'source': 'app',
    'createdBy': userId,
    'createdAt': createdAt,
    'model': model.length <= 100 ? model : model.substring(0, 100),
  };
  _addLimited(data, 'expr', task.expr, 300);
  _addLimited(data, 'equation', task.equation, 300);
  _addLimited(data, 'variable', task.variable, 10);
  _addLimited(data, 'solution_expr', task.solutionExpr, 300);
  _addLimited(data, 'unit', task.unit, 50);
  return data;
}

void _addLimited(
  Map<String, Object> data,
  String key,
  String? value,
  int maxLength,
) {
  if (value == null || value.isEmpty) {
    return;
  }
  data[key] = value.length <= maxLength ? value : value.substring(0, maxLength);
}
