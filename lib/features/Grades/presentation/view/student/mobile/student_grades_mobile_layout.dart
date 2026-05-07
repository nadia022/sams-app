import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_student_grades.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/student/utils/student_grade_ui_extensions.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/mobile/grade_badge.dart';

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              'My Grades',
              style: AppStyles.mobileTitleSmallSb.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),

          // ─── Summary Card ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: _GradesSummaryCard(grades: visibleGrades),
          ),

          // ─── Grades List ───
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleGrades.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _StudentGradeItem(grade: visibleGrades[index]);
            },
          ),
        ],
      ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryHover,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
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
                const SizedBox(height: 4),
                Text(
                  '${grades.gradedCount} / ${grades.length}',
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
            height: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 16),

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
                const SizedBox(height: 4),
                Text(
                  '${grades.formattedTotalScore} / ${grades.formattedTotalMaxScore}',
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
}

/// ─── Single Grade Item Card ───
class _StudentGradeItem extends StatelessWidget {
  const _StudentGradeItem({required this.grade});
  final StudentGradeModel grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryLightActive),
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: grade.categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              grade.categoryIcon,
              size: 18,
              color: grade.categoryColor,
            ),
          ),
          const SizedBox(width: 12),

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
                const SizedBox(height: 2),
                Text(
                  'Max: ${grade.formattedMaxScore}',
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
}
