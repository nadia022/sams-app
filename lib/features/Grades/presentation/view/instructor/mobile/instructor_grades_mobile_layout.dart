import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_instructor_grades.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grade_cell.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grades_search_field.dart';

/// ═══════════════════════════════════════════════════════════════
/// INSTRUCTOR — MOBILE LAYOUT
/// Card-based grades view for mobile screens.
/// No table — uses expandable cards per student.
/// ═══════════════════════════════════════════════════════════════
class InstructorGradesMobileLayout extends StatefulWidget {
  const InstructorGradesMobileLayout({super.key});

  @override
  State<InstructorGradesMobileLayout> createState() =>
      _InstructorGradesMobileLayoutState();
}

class _InstructorGradesMobileLayoutState
    extends State<InstructorGradesMobileLayout> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isEditMode = false;

  // Column visibility map
  late Map<String, bool> _columnVisibility;

  @override
  void initState() {
    super.initState();
    _columnVisibility = {
      for (final col in MockInstructorGrades.columns)
        if (col.isVisible != null) col.key: col.isVisible!,
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Grade columns only.
  List<GradeColumnModel> get _gradeColumns =>
      MockInstructorGrades.columns.where((c) => c.points != null).toList();

  /// Visible grade columns.
  List<GradeColumnModel> get _visibleGradeColumns =>
      _gradeColumns.where((c) => _columnVisibility[c.key] == true).toList();

  /// Filtered rows.
  List<GradeRowModel> get _filteredRows {
    if (_searchQuery.isEmpty) return MockInstructorGrades.rows;
    final query = _searchQuery.toLowerCase();
    return MockInstructorGrades.rows.where((row) {
      return row.student.name.toLowerCase().contains(query) ||
          row.student.academicId.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Top Bar ───
        _buildTopBar(),
        SizedBox(height: 12.h),

        // ─── Student Cards ───
        Expanded(
          child: _filteredRows.isEmpty
              ? const GradesEmptyState(
                  title: 'No students found',
                  subtitle: 'Try a different search query',
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: _filteredRows.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    return _StudentGradeCard(
                      row: _filteredRows[index],
                      gradeColumns: _visibleGradeColumns,
                      isEditMode: _isEditMode,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  'Grades',
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),

              // Edit toggle
              _buildEditButton(),
              SizedBox(width: 8.w),

              // Visibility quick toggle
              _buildVisibilityButton(),
            ],
          ),
          SizedBox(height: 12.h),

          // Search
          GradesSearchField(
            controller: _searchController,
            onChanged: (query) => setState(() => _searchQuery = query),
            hintText: 'Search students...',
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _isEditMode = !_isEditMode),
        borderRadius: BorderRadius.circular(8.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: _isEditMode ? AppColors.primary : AppColors.whiteLight,
            border: Border.all(
              color: _isEditMode ? AppColors.primary : AppColors.whiteHover,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isEditMode ? Icons.check_rounded : Icons.edit_outlined,
                size: 14.sp.clamp(12, 16),
                color: _isEditMode ? Colors.white : AppColors.primaryDark,
              ),
              SizedBox(width: 4.w),
              Text(
                _isEditMode ? 'Done' : 'Edit',
                style: AppStyles.mobileBodyXsmallMd.copyWith(
                  color: _isEditMode ? Colors.white : AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilityButton() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 42),
      color: AppColors.whiteLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.primaryLightHover),
      ),
      onSelected: (val) {
        // Toggle visibility for columns
      },
      itemBuilder: (_) => _gradeColumns.map((col) {
        final isVis = _columnVisibility[col.key] ?? true;
        return PopupMenuItem<String>(
          value: col.key,
          onTap: () {
            setState(() {
              _columnVisibility[col.key] = !isVis;
            });
          },
          child: Row(
            children: [
              Icon(
                isVis
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 16,
                color: isVis ? AppColors.primary : AppColors.whiteDarkHover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  col.name,
                  style: AppStyles.mobileBodySmallRg.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          border: Border.all(color: AppColors.whiteHover),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_rounded,
              size: 14.sp.clamp(12, 16),
              color: AppColors.primaryDark,
            ),
            SizedBox(width: 4.w),
            Text(
              'Visible',
              style: AppStyles.mobileBodyXsmallRg.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─── Student Grade Card ───
/// Expandable card showing student info and grade details.
class _StudentGradeCard extends StatefulWidget {
  const _StudentGradeCard({
    required this.row,
    required this.gradeColumns,
    required this.isEditMode,
  });

  final GradeRowModel row;
  final List<GradeColumnModel> gradeColumns;
  final bool isEditMode;

  @override
  State<_StudentGradeCard> createState() => _StudentGradeCardState();
}

class _StudentGradeCardState extends State<_StudentGradeCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _isExpanded
              ? AppColors.primaryLightActive
              : AppColors.whiteHover,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ─── Card Header ───
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.r),
              bottom: _isExpanded ? Radius.zero : Radius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                children: [
                  // Student avatar
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        widget.row.student.name
                            .split(' ')
                            .take(2)
                            .map((e) => e[0])
                            .join()
                            .toUpperCase(),
                        style: AppStyles.mobileBodyXsmallMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Student info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.row.student.name,
                          style: AppStyles.mobileBodySmallMd.copyWith(
                            color: AppColors.primaryDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.row.student.academicId,
                          style: AppStyles.mobileBodyXsmallRg.copyWith(
                            color: AppColors.whiteDarkHover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grades summary badge
                  _buildGradesSummary(),
                  SizedBox(width: 8.w),

                  // Expand icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.whiteDarkHover,
                      size: 22.sp.clamp(20, 24),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Expanded Grades List ───
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedGrades(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesSummary() {
    final graded = widget.gradeColumns
        .where((c) => widget.row.grades[c.key] != null)
        .length;
    final total = widget.gradeColumns.length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: graded == total
            ? StatusColors.greenTransparent
            : graded == 0
                ? StatusColors.greyTransparent
                : StatusColors.blueTransparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        '$graded/$total',
        style: AppStyles.mobileBodyXsmallMd.copyWith(
          color: graded == total
              ? StatusColors.greenDark
              : graded == 0
                  ? StatusColors.grey
                  : StatusColors.blueDark,
        ),
      ),
    );
  }

  Widget _buildExpandedGrades() {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      child: Column(
        children: [
        const  Divider(color: AppColors.whiteHover, height: 1),
          SizedBox(height: 10.h),
          ...widget.gradeColumns.map((col) {
            final score = widget.row.grades[col.key];
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  // Grade name
                  Expanded(
                    flex: 3,
                    child: Text(
                      col.name,
                      style: AppStyles.mobileBodySmallRg.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),

                  // Points label
                  Expanded(
                    flex: 1,
                    child: Text(
                      '/ ${col.points}',
                      style: AppStyles.mobileBodyXsmallRg.copyWith(
                        color: AppColors.whiteDarkHover,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Score
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GradeBadge(
                        score: score,
                        maxScore: col.points ?? 0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
