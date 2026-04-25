import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_student_grades.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grade_cell.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grades_empty_state.dart';

/// ═══════════════════════════════════════════════════════════════
/// STUDENT — MOBILE LAYOUT
/// Simple card-based list showing the student's own grades.
/// Only renders visible items (isVisible == true).
/// ═══════════════════════════════════════════════════════════════
class StudentGradesMobileLayout extends StatelessWidget {
  const StudentGradesMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter only visible grades
    final visibleGrades = MockStudentGrades.grades
        .where((g) => g.isVisible)
        .toList();

    if (visibleGrades.isEmpty) {
      return const GradesEmptyState(
        title: 'No grades available',
        subtitle: 'Your grades will appear here once published',
        icon: Icons.assignment_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header ───
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
          child: Text(
            'My Grades',
            style: AppStyles.mobileTitleSmallSb.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
        ),

        // ─── Summary Card ───
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: _GradesSummaryCard(grades: visibleGrades),
        ),

        // ─── Grades List ───
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: visibleGrades.length,
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              return _StudentGradeItem(grade: visibleGrades[index]);
            },
          ),
        ),
      ],
    );
  }
}

/// ─── Summary Card ───
/// Shows overall graded count and total points at a glance.
class _GradesSummaryCard extends StatelessWidget {
  const _GradesSummaryCard({required this.grades});
  final List<StudentGradeModel> grades;

  @override
  Widget build(BuildContext context) {
    final graded = grades.where((g) => g.score != null).length;
    final totalMax = grades.fold<num>(0, (sum, g) => sum + g.maxScore);
    final totalScore = grades.fold<num>(
      0,
      (sum, g) => sum + (g.score ?? 0),
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryHover,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Graded count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Graded',
                  style: AppStyles.mobileBodyXsmallRg.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$graded / ${grades.length}',
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 40.h,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          SizedBox(width: 16.w),

          // Right: Total score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Score',
                  style: AppStyles.mobileBodyXsmallRg.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${_formatScore(totalScore)} / ${_formatScore(totalMax)}',
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(num value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

/// ─── Single Grade Item Card ───
class _StudentGradeItem extends StatelessWidget {
  const _StudentGradeItem({required this.grade});
  final StudentGradeModel grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.whiteHover),
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: _getCategoryColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getCategoryIcon(),
              size: 18.sp.clamp(16, 20),
              color: _getCategoryColor(),
            ),
          ),
          SizedBox(width: 12.w),

          // Classwork name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.classwork,
                  style: AppStyles.mobileBodySmallMd.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Max: ${_formatScore(grade.maxScore)}',
                  style: AppStyles.mobileBodyXsmallRg.copyWith(
                    color: AppColors.whiteDarkHover,
                  ),
                ),
              ],
            ),
          ),

          // Score badge
          GradeBadge(
            score: grade.score,
            maxScore: grade.maxScore,
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    final name = grade.classwork.toLowerCase();
    if (name.contains('midterm') || name.contains('final')) {
      return AppColors.red;
    }
    if (name.contains('quiz')) return AppColors.primary;
    if (name.contains('assignment')) return AppColors.secondary;
    if (name.contains('bonus')) return StatusColors.orange;
    return AppColors.primaryDark;
  }

  IconData _getCategoryIcon() {
    final name = grade.classwork.toLowerCase();
    if (name.contains('midterm') || name.contains('final')) {
      return Icons.description_outlined;
    }
    if (name.contains('quiz')) return Icons.quiz_outlined;
    if (name.contains('assignment')) return Icons.assignment_outlined;
    if (name.contains('bonus')) return Icons.star_outline_rounded;
    return Icons.grading_rounded;
  }

  String _formatScore(num value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
