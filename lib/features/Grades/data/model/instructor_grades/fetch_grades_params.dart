import 'package:sams_app/core/utils/constants/api_keys.dart';

class FetchGradesParams {
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final int size;
  final int page;

  FetchGradesParams({
    this.search,
    this.sortBy,
    this.sortOrder = ApiValues.desc,
    this.size = 50,
    this.page = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      if (search != null) ApiKeys.search: search,
      if (sortBy != null) ApiKeys.sortBy: sortBy,
      ApiKeys.sortOrder: sortOrder,
      ApiKeys.size: size,
      ApiKeys.page: page,
    };
  }
}
