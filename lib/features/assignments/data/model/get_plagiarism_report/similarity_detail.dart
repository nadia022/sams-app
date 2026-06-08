import 'package:sams_app/core/utils/constants/api_keys.dart';

class SimilarityDetail {
  final String? studentName;
  final String? submissionUrl;
  final int? similarityPercentage;

  SimilarityDetail({
    this.studentName,
    this.submissionUrl,
    this.similarityPercentage,
  });

  factory SimilarityDetail.fromJson(Map<String, dynamic> json) {
    return SimilarityDetail(
      studentName: json[ApiKeys.studentName],
      submissionUrl: json[ApiKeys.submissionUrl],
      similarityPercentage: json[ApiKeys.similarityPercentage],
    );
  }

  
}