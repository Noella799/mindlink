import 'package:flutter/material.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:mindlink/features/auth/presentation/screens/login_screen.dart';
import 'package:mindlink/features/auth/presentation/screens/register_screen.dart';
import 'package:mindlink/features/breathe/presentation/screens/breathe_screen.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/presentation/screens/check_in_history_screen.dart';
import 'package:mindlink/features/check_in/presentation/screens/check_in_result_screen.dart';
import 'package:mindlink/features/learn/domain/learn_topic.dart';
import 'package:mindlink/features/learn/presentation/screens/learn_screen.dart';
import 'package:mindlink/features/learn/presentation/screens/topic_detail_screen.dart';
import 'package:mindlink/features/settings/presentation/screens/settings_screen.dart';

/// Builds a page for every named route.
///
/// The home route ("/") is the AuthGate in app.dart. It decides between
/// the Welcome screen and the main app, so the back stack never mixes
/// signed-in and signed-out screens.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    final Widget page = switch (settings.name) {
      AppRoutes.login => const LoginScreen(),
      AppRoutes.register => const RegisterScreen(),
      AppRoutes.forgotPassword => const ForgotPasswordScreen(),
      AppRoutes.history => const CheckInHistoryScreen(),
      AppRoutes.breathe => const BreatheScreen(),
      AppRoutes.learn => const LearnScreen(),
      AppRoutes.settings => const SettingsScreen(),
      AppRoutes.checkInResult when arguments is CheckIn => CheckInResultScreen(checkIn: arguments),
      AppRoutes.learnTopic when arguments is LearnTopic => TopicDetailScreen(topic: arguments),
      _ => const _NotFoundScreen(),
    };

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: const Center(child: Text('Sorry, this page does not exist.')),
    );
  }
}
