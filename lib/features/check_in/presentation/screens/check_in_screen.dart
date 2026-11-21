import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/widgets/adaptive_grid.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/core/widgets/option_card.dart';
import 'package:mindlink/core/widgets/primary_button.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';
import 'package:mindlink/features/check_in/presentation/mood_ui.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_form_controller.dart';

/// Daily check-in from the Figma prototype:
/// choose mood -> choose what feels strongest -> choose the help you want.
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onContinue(CheckInDraft draft) async {
    final controller = ref.read(checkInFormControllerProvider.notifier);
    if (!draft.isLastStep) {
      controller.next();
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      final saved = await controller.submit(note: _noteController.text);
      _noteController.clear();
      if (!mounted) return;
      Navigator.of(context).pushNamed(AppRoutes.checkInResult, arguments: saved);
    } catch (error) {
      if (!mounted) return;
      showAppSnackBar(context, friendlyErrorMessage(error), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(checkInFormControllerProvider);
    final controller = ref.read(checkInFormControllerProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: (draft.step + 1) / CheckInDraft.totalSteps),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Question ${draft.step + 1} of ${CheckInDraft.totalSteps}',
            style: textTheme.labelLarge,
          ),
        ],
      ),
    );

    final question = Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.topCenter,
          children: [...previous, if (current != null) current],
        ),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(draft.step),
          child: _buildStep(draft, controller),
        ),
      ),
    );

    final button = Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      child: PrimaryButton(
        label: draft.isLastStep ? 'Save check-in' : 'Continue',
        isLoading: draft.isSaving,
        onPressed: draft.canContinue ? () => _onContinue(draft) : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily check-in'),
        automaticallyImplyLeading: false,
        leading: draft.step > 0
            ? IconButton(
                tooltip: 'Previous question',
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: controller.back,
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Short screens (landscape, keyboard open): scroll everything.
            // Tall screens: keep the button pinned at the bottom.
            final pinButton = constraints.maxHeight >= 420;
            final content = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [header, question, if (!pinButton) button],
                ),
              ),
            );

            if (!pinButton) return SingleChildScrollView(child: content);

            return Column(
              children: [
                Expanded(child: SingleChildScrollView(child: content)),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                    child: button,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep(CheckInDraft draft, CheckInFormController controller) {
    switch (draft.step) {
      case 0:
        return _QuestionStep(
          title: 'How are you feeling right now?',
          subtitle: 'There is no right or wrong answer.',
          options: [
            for (final mood in Mood.values)
              OptionCard(
                label: mood.label,
                icon: mood.icon,
                iconColor: mood.color,
                selected: draft.mood == mood,
                onTap: () => controller.selectMood(mood),
              ),
          ],
        );
      case 1:
        return _QuestionStep(
          title: 'What feels strongest today?',
          subtitle: 'Pick the one that matters most right now.',
          options: [
            for (final source in FeelingSource.values)
              OptionCard(
                label: source.label,
                icon: source.icon,
                selected: draft.source == source,
                onTap: () => controller.selectSource(source),
              ),
          ],
        );
      default:
        return _QuestionStep(
          title: 'What kind of help would you like?',
          subtitle: 'We will suggest something that fits.',
          options: [
            for (final help in HelpType.values)
              OptionCard(
                label: help.label,
                subtitle: help.description,
                icon: help.icon,
                selected: draft.helpType == help,
                onTap: () => controller.selectHelpType(help),
              ),
          ],
          footer: TextField(
            key: const Key('check-in-note'),
            controller: _noteController,
            maxLength: 200,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Private note (optional)',
              hintText: 'Anything you want to remember about today',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
          ),
        );
    }
  }
}

class _QuestionStep extends StatelessWidget {
  const _QuestionStep({
    required this.title,
    required this.subtitle,
    required this.options,
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> options;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(title, style: textTheme.headlineSmall)),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.lg),
        AdaptiveGrid(minItemWidth: 260, children: options),
        if (footer != null) ...[const SizedBox(height: AppSpacing.lg), footer!],
      ],
    );
  }
}
