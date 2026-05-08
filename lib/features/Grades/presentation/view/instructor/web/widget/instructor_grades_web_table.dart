import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/web/grade_cell.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/shared/visibility_confirmation_dialog.dart';

class InstructorGradesWebTable extends StatelessWidget {
  const InstructorGradesWebTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.columnVisibility,
    required this.onVisibilityChanged,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  final List<GradeColumnModel> columns;
  final List<GradeRowModel> rows;
  final Map<String, bool> columnVisibility;
  final Function(String key, bool isVisible) onVisibilityChanged;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int index, bool ascending) onSort;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600 + (columns.length * 120).toDouble(),
      headingRowHeight: 52.h,
      dataRowHeight: 56.h,
      headingRowColor: WidgetStateProperty.all(AppColors.primary),
      headingTextStyle: AppStyles.mobileBodyXsmallMd.copyWith(
        color: Colors.white,
      ),
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      scrollController: ScrollController(), // Provide a scroll controller for the table itself
      columns: _buildColumns(context),
      rows: rows.asMap().entries.map((e) => _buildRow(e.value, e.key)).toList(),
    );
  }

  List<DataColumn2> _buildColumns(BuildContext context) {
    return [
      DataColumn2(
        label: const Text('ID'),
        size: ColumnSize.S,
        fixedWidth: 120.w,
        onSort: onSort,
      ),
      DataColumn2(
        label: const Text('Name'),
        size: ColumnSize.L,
        fixedWidth: 200.w,
        onSort: onSort,
      ),
      ...columns.map((col) {
        return DataColumn2(
          label: _buildGradeColumnHeader(context, col),
          size: ColumnSize.M,
          onSort: onSort,
        );
      }),
    ];
  }

  Widget _buildGradeColumnHeader(BuildContext context, GradeColumnModel col) {
    final isVisible = columnVisibility[col.key] ?? true;
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
            SizedBox(width: 4.w),
            InkWell(
              onTap: () async {
                final confirmed = await VisibilityConfirmationDialog.show(
                  context: context,
                  columnName: col.name,
                  currentlyVisible: isVisible,
                );
                if (confirmed) {
                  onVisibilityChanged(col.key, !isVisible);
                }
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

  DataRow2 _buildRow(GradeRowModel row, int index) {
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
        ...columns.map((col) {
          final score = row.grades[col.key];
          return DataCell(
            Center(
              child: GradeCell(
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
