import 'package:flutter/material.dart';
import 'package:sams_app/features/splash/presentation/views/widgets/splash_body.dart';

/// AcademiaX premium splash screen — the app's initial route.
///
/// The splash screen is intentionally identical on mobile, tablet, and web
/// to provide a consistent brand experience. It uses [SplashBody] which
/// handles all animations and navigation logic internally.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashBody(),
    );
  }
}
