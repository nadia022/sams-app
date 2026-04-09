import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/widgets/mobile/submissions_list_mobile_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/widgets/web/submissions_list_web_layout.dart';

class SubmissionsListView extends StatelessWidget {
  const SubmissionsListView({super.key, required this.quizTitle});
  final String quizTitle;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (context) =>
          SubmissionsListMobileLayout(quizTitle: quizTitle),
      webLayout: (context) => const SubmissionsListWebLayout(),
    );
  }
}
