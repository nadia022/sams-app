import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';

/// Displays the screen title and subtitle based on the current [QuizMode].
///
/// - **Draft**: "Add Questions" — "Build your quiz by adding questions below."
/// - **Edit**: "Manage Questions" — "Review or edit your questions."
/// - **View**: "View Questions" — "Browse quiz content (read-only)."
class ModeConfigurationHeader extends StatelessWidget {
  final QuizMode mode;
  final int questionCount;

  const ModeConfigurationHeader({
    super.key,
    required this.mode,
    this.questionCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Back Button + Mode Badge ───
            Row(
              children: [
                _buildBackButton(context),
                const SizedBox(width: 12),
                _buildModeBadge(),
              ],
            ),
            const SizedBox(height: 16),

            // ─── Title ───
            Text(
              _title,
              style: AppStyles.mobileTitleMediumSb.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            // ─── Subtitle ───
            Text(
              _subtitle,
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: Colors.white.withAlpha(180),
              ),
            ),

            if (questionCount > 0) ...[
              const SizedBox(height: 12),
              Text(
                '$questionCount question${questionCount == 1 ? '' : 's'}',
                style: AppStyles.mobileBodyXsmallMd.copyWith(
                  color: AppColors.secondaryLightHover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ──────────── Subwidgets ────────────

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildModeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _badgeColor.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _badgeColor.withAlpha(100), width: 1),
      ),
      child: Text(
        _badgeLabel,
        style: AppStyles.mobileBodyXsmallMd.copyWith(color: _badgeColor),
      ),
    );
  }

  // ──────────── Mode-Driven Getters ────────────

  String get _title {
    switch (mode) {
      case QuizMode.draft:
        return 'Add Questions';
      case QuizMode.edit:
        return 'Manage Questions';
      case QuizMode.view:
        return 'View Questions';
    }
  }

  String get _subtitle {
    switch (mode) {
      case QuizMode.draft:
        return 'Build your quiz by adding questions below.';
      case QuizMode.edit:
        return 'Review or edit your questions before publishing.';
      case QuizMode.view:
        return 'Browse quiz content and correct answers.';
    }
  }

  String get _badgeLabel {
    switch (mode) {
      case QuizMode.draft:
        return 'DRAFT';
      case QuizMode.edit:
        return 'EDITING';
      case QuizMode.view:
        return 'READ-ONLY';
    }
  }

  Color get _badgeColor {
    switch (mode) {
      case QuizMode.draft:
        return StatusColors.orange;
      case QuizMode.edit:
        return AppColors.secondaryLightHover;
      case QuizMode.view:
        return Colors.white;
    }
  }
}
