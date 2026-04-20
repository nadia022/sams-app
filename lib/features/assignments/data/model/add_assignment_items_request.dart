import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/file_upload_reference.dart';

class AddAssignmentItemsRequest {
  final List<FileUploadReference> assignmentItems;

  AddAssignmentItemsRequest({required this.assignmentItems});

  Map<String, dynamic> toJson() => {
    ApiKeys.assignmentItems: assignmentItems.map((e) => e.toJson()).toList(),
  };
}
