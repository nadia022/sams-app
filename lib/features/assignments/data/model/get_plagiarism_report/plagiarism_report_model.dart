import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/get_plagiarism_report/similarity_detail.dart';

class PlagiarismReportModel {
  final int? assignmentPlagiarismThreshold;
  final String? studentName;
  final List<SimilarityDetail>? similarities;

  PlagiarismReportModel({
    this.assignmentPlagiarismThreshold,
    this.studentName,
    this.similarities,
  });

  factory PlagiarismReportModel.fromJson(Map<String, dynamic> json) {
    return PlagiarismReportModel(
      assignmentPlagiarismThreshold: json[ApiKeys.assignmentPlagiarismThreshold],
      studentName: json[ApiKeys.studentName],
      similarities: json[ApiKeys.similarities] != null
          ? List<SimilarityDetail>.from(
              json[ApiKeys.similarities].map((x) => SimilarityDetail.fromJson(x)),
            )
          : null,
    );
  }
}