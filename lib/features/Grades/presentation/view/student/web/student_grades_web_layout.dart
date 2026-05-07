import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_student_grades.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/web/grade_cell.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/student/utils/student_grade_ui_extensions.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
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
          SizedBox(height: 20.h),

          // ─── Summary Row ───
          _GradesSummaryRow(grades: visibleGrades),
          SizedBox(height: 24.h),

          // ─── Grades Table ───
          Expanded(
            child: _buildGradesTable(visibleGrades),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesTable(List<StudentGradeModel> grades) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.whiteHover),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            children: [
              // Table header
              _buildTableHeader(),
              // Table rows
              ...grades.asMap().entries.map(
                (entry) => _buildTableRow(entry.value, entry.key),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      color: AppColors.primary,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Category',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Score',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Max',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(StudentGradeModel grade, int index) {
    final isGraded = grade.score != null;
    // final percentage = isGraded && grade.maxScore > 0
    //     ? ((grade.score! / grade.maxScore) * 100)
    //     : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: index.isEven ? AppColors.whiteLight : AppColors.white,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.whiteHover,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Category name with icon
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: grade.categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    grade.categoryIcon,
                    size: 16.sp.clamp(14, 18),
                    color: grade.categoryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Text(
                    grade.classwork,
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: AppColors.primaryDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Expanded(
            flex: 2,
            child: Center(
              child: GradeCell(
                score: grade.score,
                maxScore: grade.maxScore,
              ),
            ),
          ),

          // Max Score
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                grade.formattedMaxScore,
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkHover,
                ),
              ),
            ),
          ),

          // Status badge
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: isGraded
                      ? StatusColors.greenTransparent
                      : StatusColors.orangeTransparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  isGraded ? 'Graded' : 'Pending',
                  style: AppStyles.mobileBodyXsmallMd.copyWith(
                    color: isGraded
                        ? StatusColors.greenDark
                        : StatusColors.orangeDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── Summary Row (Web) ───
class _GradesSummaryRow extends StatelessWidget {
  const _GradesSummaryRow({required this.grades});
  final List<StudentGradeModel> grades;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          icon: Icons.grading_rounded,
          label: 'Graded',
          value: '${grades.gradedCount} / ${grades.length}',
          color: AppColors.primary,
        ),
        SizedBox(width: 16.w),
        _SummaryCard(
          icon: Icons.score_rounded,
          label: 'Total Score',
          value:
              '${grades.formattedTotalScore} / ${grades.formattedTotalMaxScore}',
          color: AppColors.secondary,
        ),
        SizedBox(width: 16.w),
        _SummaryCard(
          icon: Icons.percent_rounded,
          label: 'Average',
          value: '${grades.percentage.toStringAsFixed(1)}%',
          color: grades.percentage >= 80
              ? StatusColors.green
              : grades.percentage >= 50
              ? StatusColors.blue
              : StatusColors.red,
        ),
      ],
    );
  }
}

/// Individual summary card
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 20.sp.clamp(18, 22)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.mobileBodyXsmallRg.copyWith(
                      color: AppColors.whiteDarkHover,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
