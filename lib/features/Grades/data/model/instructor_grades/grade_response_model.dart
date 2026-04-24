import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'grade_row_model.dart';
import 'user_pagination_model.dart';

class GradeResponseModel {
  final String status;
  final List<GradeColumnModel> columns;
  final List<GradeRowModel> rows;
  final UserPaginationModel pagination;

  GradeResponseModel({
    required this.status,
    required this.columns,
    required this.rows,
    required this.pagination,
  });

  factory GradeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json[ApiKeys.data] as Map<String, dynamic>;

    return GradeResponseModel(
      status: json[ApiKeys.status] as String,
      columns: (data[ApiKeys.columns] as List)
          .map(
            (item) => GradeColumnModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      rows: (data[ApiKeys.rows] as List)
          .map((item) => GradeRowModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: UserPaginationModel.fromJson(json[ApiKeys.pagination]),
    );
  }

  GradeResponseModel copyWith({
    List<GradeColumnModel>? columns,
    List<GradeRowModel>? rows,
    UserPaginationModel? pagination,
  }) {
    return GradeResponseModel(
      status: status,
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
      pagination: pagination ?? this.pagination,
    );
  }
}
