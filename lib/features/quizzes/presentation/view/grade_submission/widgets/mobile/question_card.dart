import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/mobile/grading_input_score_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/mobile/mcq_options_list.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/mobile/written_answer.dart';

class QuestionCard extends StatelessWidget {
  final SubmissionDetailsModel question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    // Unmarked question
    final bool needsGrading = question.state == QuestionUIState.unmarked;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: needsGrading
              ? StatusColors.orange
              : AppColors.secondaryLightActive,
          width: needsGrading ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (Badge & Grading Input)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTypeBadge(),
              question.isWritten
                  ? GradingScoreField(
                      maxPoints: question.points,
                      earnedPoints: question.earnedPoints,
                      isGraded: question.isGraded,
                      questionId: question.id,
                    )
                  : _buildStaticScoreContainer(),
            ],
          ),

          const SizedBox(height: 32),

          Text(
            question.text,
            style: AppStyles.web16Semibold.copyWith(
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(height: 24),

          // 3. Answer Body
          _buildAnswerBody(),
        ],
      ),
    );
  }

  Widget _buildStaticScoreContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Points',
          style: AppStyles.mobileBodyXsmallMd.copyWith(
            color: AppColors.whiteDarkActive,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.whiteLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: question.earnedPoints == 0
                  ? StatusColors.red.withValues(alpha: 0.5)
                  : StatusColors.green.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Text(
            question.displayScore,
            style: AppStyles.mobileLabelMediumMd.copyWith(
              color: question.earnedPoints == 0
                  ? StatusColors.red
                  : StatusColors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge() {
    IconData icon;
    Color color = AppColors.primary;

    if (question.isWritten) {
      icon = Icons.edit_document;
    } else {
      icon = Icons.checklist_rtl;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            question.uiTypeLabel,
            style: AppStyles.mobileBodyXsmallMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerBody() {
    if (question.isWritten) {
      return WrittenAnswer(answer: question.writtenAnswer);
    } else {
      return McqOptionsList(options: question.options!);
    }
  }
}
