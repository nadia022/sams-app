import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// Reusable grade cell widget used in both table and card views.
/// Handles null scores gracefully with "—" placeholder.
class GradeCell extends StatelessWidget {
  const GradeCell({
    super.key,
    required this.score,
    this.maxScore,
    this.showMax = false,
  });

  /// The student's score. Null means "Not graded yet".
  final num? score;

  /// Maximum possible score for reference.
  final num? maxScore;

  /// Whether to show the max score alongside (e.g. "8/10").
  final bool showMax;

  @override
  Widget build(BuildContext context) {
    if (score == null) {
      return Text(
        '—',
        style: AppStyles.mobileBodySmallRg.copyWith(
          color: StatusColors.grey,
        ),
        textAlign: TextAlign.center,
      );
    }

    final scoreText = showMax && maxScore != null
        ? '${_formatScore(score!)}/${_formatScore(maxScore!)}'
        : _formatScore(score!);

    return Text(
      scoreText,
      style: AppStyles.mobileBodySmallMd.copyWith(
        color: _getScoreColor(),
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Format score: show integer if whole number, otherwise 1 decimal.
  String _formatScore(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  /// Color-code scores based on percentage of max.
  Color _getScoreColor() {
    if (score == null || maxScore == null || maxScore == 0) {
      return AppColors.primaryDark;
    }
    final percentage = (score! / maxScore!) * 100;
    if (percentage >= 80) return AppColors.secondary;
    if (percentage >= 50) return AppColors.primaryDark;
    return AppColors.red;
  }
}

/// Compact grade badge used in mobile cards.
/// Shows score with colored background based on performance.
class GradeBadge extends StatelessWidget {
  const GradeBadge({
    super.key,
    required this.score,
    required this.maxScore,
  });

  final num? score;
  final num maxScore;

  @override
  Widget build(BuildContext context) {
    final isGraded = score != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isGraded ? _getBackgroundColor() : StatusColors.greyTransparent,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isGraded
            ? '${_formatScore(score!)}/${_formatScore(maxScore)}'
            : 'Not graded',
        style: AppStyles.mobileBodyXsmallMd.copyWith(
          color: isGraded ? _getTextColor() : StatusColors.grey,
        ),
      ),
    );
  }

  String _formatScore(num value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  Color _getBackgroundColor() {
    if (score == null || maxScore == 0) return StatusColors.greyTransparent;
    final pct = (score! / maxScore) * 100;
    if (pct >= 80) return StatusColors.greenTransparent;
    if (pct >= 50) return StatusColors.blueTransparent;
    return StatusColors.redTransparent;
  }

  Color _getTextColor() {
    if (score == null || maxScore == 0) return StatusColors.grey;
    final pct = (score! / maxScore) * 100;
    if (pct >= 80) return StatusColors.greenDark;
    if (pct >= 50) return StatusColors.blueDark;
    return StatusColors.redDark;
  }
}
