import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/mobile/manage_questions_mobile_layout.dart';

/// Web layout for the Manage Questions screen.
///
/// Currently delegates to the mobile layout wrapped in a constrained container.
/// A dedicated web-specific layout can be built here later.
class ManageQuestionsWebLayout extends StatelessWidget {
  const ManageQuestionsWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: const ManageQuestionsMobileLayout(),
        ),
      ),
    );
  }
}
