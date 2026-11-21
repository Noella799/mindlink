import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/core/widgets/section_title.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';
import 'package:mindlink/features/home/domain/home_content.dart';
import 'package:mindlink/features/home/presentation/widgets/daily_tip_card.dart';
import 'package:mindlink/features/home/presentation/widgets/quick_actions.dart';
import 'package:mindlink/features/home/presentation/widgets/stats_row.dart';
import 'package:mindlink/features/home/presentation/widgets/today_mood_card.dart';
import 'package:mindlink/features/home/presentation/widgets/verify_email_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final now = ref.watch(clockProvider)();
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MINDLINK'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(greetingFor(now, user?.firstName ?? ''), style: textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Take a minute for yourself today.',
              style: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
            if (user != null && !user.emailVerified) ...[
              const SizedBox(height: AppSpacing.lg),
              VerifyEmailBanner(email: user.email),
            ],
            const SizedBox(height: AppSpacing.lg),
            const TodayMoodCard(),
            const SizedBox(height: AppSpacing.md),
            const StatsRow(),
            const SectionTitle('Quick support'),
            const QuickActions(),
            const SectionTitle('Tip of the day'),
            DailyTipCard(tip: tipFor(now)),
          ],
        ),
      ),
    );
  }
}
