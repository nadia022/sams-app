import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_student_grades.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/student/web/widget/grades_summary_row.dart';
import 'package:sams_app/features/Grades/presentation/view/student/web/widget/student_grades_web_table.dart';

/// ═══════════════════════════════════════════════════════════════
/// STUDENT — WEB LAYOUT
/// Table/grid-based view of the student's own grades for web.
/// Same data as mobile but in a wider, more spacious layout.
/// ═══════════════════════════════════════════════════════════════
class StudentGradesWebLayout extends StatelessWidget {
  const StudentGradesWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleGrades = MockStudentGrades.grades
        .where((g) => g.isVisible)
        .toList();

    if (visibleGrades.isEmpty) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradesEmptyState(
            title: 'No grades available',
            subtitle: 'Your grades will appear here once published',
            icon: Icons.assignment_outlined,
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ───
            Text(
              'My Grades',
              style: AppStyles.mobileTitleMediumSb.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 20),

            // ─── Summary Row ───
            GradesSummaryRow(grades: visibleGrades),
            const SizedBox(height: 24),

            // ─── Grades Table ───
            StudentGradesWebTable(grades: visibleGrades),
          ],
        ),
      ),
    );
  }
}
