import 'package:sams_app/features/assignments/data/model/get_all_submissions/student_info_model.dart';

import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/get_submission_details/submitted_item_model.dart';

class SubmissionDetails {
  final String id;
  final StudentInfoModel studentInfo;
  final String submittedAt;
  final List<SubmittedItemModel> submittedItems;
  final bool neededReview;
  final int points;
  final int earnedPoints;

  SubmissionDetails({
    required this.id,
    required this.studentInfo,
    required this.submittedAt,
    required this.submittedItems,
    required this.neededReview,
    required this.points,
    required this.earnedPoints,
  });

  factory SubmissionDetails.fromJson(Map<String, dynamic> json) {
    return SubmissionDetails(
      id: json[ApiKeys.id],
      studentInfo: StudentInfoModel.fromJson(json[ApiKeys.studentInfo]),
      submittedAt: json[ApiKeys.submittedAt],
      submittedItems: (json[ApiKeys.submittedItems] as List)
          .map((e) => SubmittedItemModel.fromJson(e))
          .toList(),
      neededReview: json[ApiKeys.neededReview],
      points: json[ApiKeys.points],
      earnedPoints: json[ApiKeys.earnedPoints],
    );
  }
}