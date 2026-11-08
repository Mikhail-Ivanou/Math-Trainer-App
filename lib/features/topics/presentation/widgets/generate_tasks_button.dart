import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/presentation/generation_failure_message.dart';
import 'package:math_trainer_app/features/topics/presentation/widgets/level_picker_sheet.dart';
import 'package:math_trainer_app/features/topics/state/task_generation_cubit.dart';

class GenerateTasksButton extends StatelessWidget {
  const GenerateTasksButton({required this.topic, super.key});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<TaskGenerationCubit, TaskGenerationState>(
      builder: (context, state) {
        final generating = state is TaskGenerationInProgress;
        return FloatingActionButton.extended(
          onPressed: generating ? null : () => _generate(context, state.level),
          icon: generating
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_awesome),
          label: Text(generating ? l10n.generatingTasks : l10n.generateTasks),
        );
      },
    );
  }

  Future<void> _generate(BuildContext context, Difficulty level) async {
    final colors = context.colors;
    final selected = await showModalBottomSheet<Difficulty>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      builder: (context) => LevelPickerSheet(initial: level),
    );
    if (selected == null || !context.mounted) {
      return;
    }
    await context.read<TaskGenerationCubit>().generate(topic, selected);
  }
}

class GenerationMessages extends StatelessWidget {
  const GenerationMessages({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskGenerationCubit, TaskGenerationState>(
      listenWhen: (previous, current) =>
          current is TaskGenerationSuccess ||
          current is TaskGenerationFailureState,
      listener: (context, state) {
        final l10n = context.l10n;
        final message = switch (state) {
          TaskGenerationSuccess(:final added, :final rejected) =>
            rejected == 0
                ? l10n.tasksAdded(added)
                : l10n.tasksAddedSkipped(added, rejected),
          TaskGenerationFailureState(:final failure) =>
            generationFailureMessage(l10n, failure),
          _ => null,
        };
        if (message == null) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      child: child,
    );
  }
}
