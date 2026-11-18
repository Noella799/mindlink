import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/widgets/adaptive_grid.dart';
import 'package:mindlink/core/widgets/empty_state.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/features/learn/domain/learn_topic.dart';
import 'package:mindlink/features/learn/presentation/learn_providers.dart';

/// "Mental-health information" from the Learn user flow.
class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(learnTopicsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: topics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.cloud_off_rounded,
          title: 'Could not load topics',
          message: friendlyErrorMessage(error),
        ),
        data: (items) => ResponsiveBody(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Short reads you can finish in a couple of minutes.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              AdaptiveGrid(
                minItemWidth: 280,
                children: [for (final topic in items) _TopicCard(topic: topic)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic});

  final LearnTopic topic;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.learnTopic, arguments: topic),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Hero(
                tag: 'topic-${topic.id}',
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(topic.icon, color: scheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.title, style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(topic.summary, style: textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${topic.readMinutes} min read',
                      style: textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
