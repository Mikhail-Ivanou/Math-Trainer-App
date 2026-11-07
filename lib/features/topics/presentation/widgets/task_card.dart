import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/presentation/task_labels.dart';
import 'package:math_trainer_app/features/topics/state/topic_practice_cubit.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({required this.task, required this.solved, super.key});

  final Task task;
  final bool solved;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  var _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final answer = [
      widget.task.answer,
      if (widget.task.unit != null) widget.task.unit,
    ].join(' ');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.solved ? colors.background : colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.textSecondary.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    taskCaption(l10n, widget.task),
                    style: TextStyle(color: colors.textSecondary, fontSize: 14),
                  ),
                ),
                Checkbox(
                  value: widget.solved,
                  activeColor: colors.accent,
                  onChanged: (checked) {
                    context.read<TopicPracticeCubit>().setSolved(
                      widget.task.id,
                      checked ?? false,
                    );
                  },
                ),
              ],
            ),
            Text(
              widget.task.question,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 18,
                height: 1.35,
              ),
            ),
            if (_showAnswer) ...[
              const SizedBox(height: 8),
              Text(
                answer,
                style: TextStyle(color: colors.textPrimary, fontSize: 16),
              ),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colors.accent,
                ),
                onPressed: () => setState(() => _showAnswer = !_showAnswer),
                child: Text(_showAnswer ? l10n.hideAnswer : l10n.showAnswer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
