import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/features/assignments/data/model/base_response.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/all_submissions_model.dart';
import 'package:sams_app/features/assignments/data/model/get_plagiarism_report/plagiarism_report_model.dart';
import 'package:sams_app/features/assignments/data/model/get_submission_details/submission_details_model.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/grade_submission_request.dart';

abstract class AssignmentSubmissionRepo {
  Future<Either<String, AllSubmissionsModel>> getAllSubmissions({
    required String assignmentId,
    int page = 1,
    int size = 20,
  });

  Future<Either<String, SubmissionDetailsModel>> getSubmissionDetails({
    required String submissionId,
  });

  Future<Either<String, BaseResponse>> gradeSubmission({
    required String submissionId,
    required GradeSubmissionRequest request,
  });

  Future<Either<String, BaseResponse>> approveAllSubmissions({
    required String assignmentId,
  });

  Future<Either<String, String>> submitAssignment({
    required String assignmentId,
    required String courseId,
    required List<XFile> files,
    required String classworkId,
  });

  Future<Either<String, String>> unsubmitAssignment({
    required String submissionId,
  });

  Future<Either<String, PlagiarismReportModel>> getSimilarityReport({
  required String submissionId,
});
}
