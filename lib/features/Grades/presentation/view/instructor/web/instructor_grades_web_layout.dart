import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_instructor_grades.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/shared/grades_filter_bar.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grade_cell.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/grades_pagination_bar.dart';

/// ═══════════════════════════════════════════════════════════════
/// INSTRUCTOR — WEB LAYOUT
/// Full DataTable2-based grades management view for web/desktop.
/// Features: sorting, visibility toggles, edit mode, pagination.
/// ═══════════════════════════════════════════════════════════════
class InstructorGradesWebLayout extends StatefulWidget {
  const InstructorGradesWebLayout({super.key});

  @override
  State<InstructorGradesWebLayout> createState() =>
      _InstructorGradesWebLayoutState();
}

class _InstructorGradesWebLayoutState extends State<InstructorGradesWebLayout> {
  // ─── Local UI State ───
  final TextEditingController _searchController = TextEditingController();

  bool _isEditMode = false;
  String _visibilityFilter = 'all';
  String _searchQuery = '';

  // Column visibility map (key → isVisible)
  late Map<String, bool> _columnVisibility;

  // Sorting state
  int? _sortColumnIndex;
  bool _sortAscending = true;

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

  // ─── Computed Data ───

  /// Get grade columns (excluding ID and Name).
  List<GradeColumnModel> get _gradeColumns =>
      MockInstructorGrades.columns.where((c) => c.points != null).toList();

  /// Filter columns based on visibility filter.
  List<GradeColumnModel> get _filteredGradeColumns {
    switch (_visibilityFilter) {
      case 'visible':
        return _gradeColumns
            .where((c) => _columnVisibility[c.key] == true)
            .toList();
      case 'hidden':
        return _gradeColumns
            .where((c) => _columnVisibility[c.key] != true)
            .toList();
      default:
        return _gradeColumns;
    }
  }

  /// Filter rows based on search query.
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Title ───
          Text(
            'Students Grades',
            style: AppStyles.mobileTitleMediumSb.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 16.h),

          // ─── Filters Bar ───
          GradesFilterBar(
            searchController: _searchController,
            isEditMode: _isEditMode,
            onEditModeToggle: () => setState(() => _isEditMode = !_isEditMode),
            onSearch: (query) => setState(() => _searchQuery = query),
            visibilityFilter: _visibilityFilter,
            onVisibilityFilterChanged: (filter) =>
                setState(() => _visibilityFilter = filter),
          ),
          SizedBox(height: 16.h),

          // ─── Table ───
          Expanded(
            child: _filteredRows.isEmpty
                ? const GradesEmptyState(
                    title: 'No students found',
                    subtitle: 'Try a different search query',
                  )
                : _buildDataTable(),
          ),

          // ─── Pagination ───
          const Divider(height: 1, color: AppColors.whiteHover),
          GradesPaginationBar(
            pagination: MockInstructorGrades.pagination,
            onPageChanged: (_) {},
            onPageSizeChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    final visibleGradeCols = _filteredGradeColumns;

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600 + (visibleGradeCols.length * 120).toDouble(),
      headingRowHeight: 52.h,
      dataRowHeight: 56.h,
      headingRowColor: WidgetStateProperty.all(AppColors.primary),
      headingTextStyle: AppStyles.mobileBodyXsmallMd.copyWith(
        color: Colors.white,
      ),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      columns: _buildColumns(visibleGradeCols),
      rows: _filteredRows
          .asMap()
          .entries
          .map((e) => _buildRow(e.value, e.key, visibleGradeCols))
          .toList(),
    );
  }

  List<DataColumn2> _buildColumns(List<GradeColumnModel> gradeCols) {
    return [
      // Fixed columns: ID and Name
      DataColumn2(
        label: const Text('ID'),
        size: ColumnSize.S,
        fixedWidth: 120.w,
        onSort: (idx, asc) => setState(() {
          _sortColumnIndex = idx;
          _sortAscending = asc;
        }),
      ),
      DataColumn2(
        label: const Text('Name'),
        size: ColumnSize.L,
        fixedWidth: 200.w,
        onSort: (idx, asc) => setState(() {
          _sortColumnIndex = idx;
          _sortAscending = asc;
        }),
      ),
      // Dynamic grade columns
      ...gradeCols.map((col) {
        return DataColumn2(
          label: _buildGradeColumnHeader(col),
          size: ColumnSize.M,
          onSort: (idx, asc) => setState(() {
            _sortColumnIndex = idx;
            _sortAscending = asc;
          }),
        );
      }),
    ];
  }

  /// Column header with name, points, and visibility toggle.
  Widget _buildGradeColumnHeader(GradeColumnModel col) {
    final isVisible = _columnVisibility[col.key] ?? true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                col.name,
                style: AppStyles.mobileBodyXsmallMd.copyWith(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_isEditMode) ...[
              SizedBox(width: 4.w),
              InkWell(
                onTap: () {
                  setState(() {
                    _columnVisibility[col.key] = !isVisible;
                  });
                },
                child: Icon(
                  isVisible
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  size: 14.sp.clamp(12, 16),
                  color: isVisible
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ],
        ),
        if (col.points != null)
          Text(
            '/ ${col.points}',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10.sp.clamp(9, 12),
            ),
          ),
      ],
    );
  }

  DataRow2 _buildRow(
    GradeRowModel row,
    int index,
    List<GradeColumnModel> gradeCols,
  ) {
    final cellStyle = AppStyles.mobileBodySmallRg.copyWith(
      color: AppColors.primaryDark,
    );

    return DataRow2(
      color: WidgetStateProperty.all(
        index.isEven ? AppColors.white : AppColors.whiteHover,
      ),
      cells: [
        DataCell(Text(row.student.academicId, style: cellStyle)),
        DataCell(
          Text(
            row.student.name,
            style: cellStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ...gradeCols.map((col) {
          final score = row.grades[col.key];
          return DataCell(
            Center(
              child: _isEditMode
                  ? _EditableGradeCell(
                      score: score,
                      maxScore: col.points,
                      onChanged: (_) {},
                    )
                  : GradeCell(
                      score: score,
                      maxScore: col.points,
                    ),
            ),
          );
        }),
      ],
    );
  }
}

/// ─── Editable Grade Cell (Edit Mode) ───
class _EditableGradeCell extends StatefulWidget {
  const _EditableGradeCell({
    required this.score,
    this.maxScore,
    this.onChanged,
  });
  final num? score;
  final num? maxScore;
  final ValueChanged<num?>? onChanged;

  @override
  State<_EditableGradeCell> createState() => _EditableGradeCellState();
}

class _EditableGradeCellState extends State<_EditableGradeCell> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.score != null ? _formatScore(widget.score!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatScore(num value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: AppStyles.mobileBodyXsmallMd.copyWith(
          color: AppColors.primaryDark,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 6.w,
            vertical: 8.h,
          ),
          filled: true,
          fillColor: AppColors.whiteLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: const BorderSide(color: AppColors.primaryLightActive),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: const BorderSide(color: AppColors.primaryLightActive),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintText: '—',
          hintStyle: AppStyles.mobileBodyXsmallRg.copyWith(
            color: AppColors.whiteDarkHover,
          ),
        ),
        onSubmitted: (val) {
          final parsed = num.tryParse(val);
          widget.onChanged?.call(parsed);
        },
      ),
    );
  }
}
