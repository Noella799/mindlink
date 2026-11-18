import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/features/learn/domain/learn_topic.dart';
import 'package:mindlink/features/learn/presentation/learn_providers.dart';

class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({super.key, required this.topic});

  final LearnTopic topic;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'topic-${topic.id}',
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(topic.icon, size: 32, color: scheme.onPrimaryContainer),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(topic.title, style: textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${topic.readMinutes} min read',
              style: textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final paragraph in topic.paragraphs) ...[
              Text(paragraph, style: textTheme.bodyLarge?.copyWith(height: 1.5)),
              const SizedBox(height: AppSpacing.md),
            ],
            if (topic.reference != null) ...[
              const Divider(height: AppSpacing.xl),
              Text(
                'Source: ${topic.reference}',
                style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.breathe),
              icon: const Icon(Icons.air_rounded),
              label: const Text('Try a breathing exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
