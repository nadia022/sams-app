import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/utils/manage_questions_ui_utils.dart';

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
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.primary,
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
              ManageQuestionsUiUtils.getHeaderTitle(mode),
              style: AppStyles.mobileTitleMediumSb.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            // ─── Subtitle ───
            Text(
              ManageQuestionsUiUtils.getHeaderSubtitle(mode),
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
    final badgeColor = ManageQuestionsUiUtils.getBadgeColor(mode);
    final badgeLabel = ManageQuestionsUiUtils.getBadgeLabel(mode);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withAlpha(100), width: 1),
      ),
      child: Text(
        badgeLabel,
        style: AppStyles.mobileBodyXsmallMd.copyWith(color: badgeColor),
      ),
    );
  }
}
