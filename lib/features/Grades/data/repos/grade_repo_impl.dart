import 'package:dartz/dartz.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_response_model.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/Grades/data/repos/grade_repo.dart';

class GradeRepoImpl implements GradeRepo {
  @override
  Future<Either<String, StudentGradeModel>> getStudentGrades() {
    // TODO: implement getStudentGrades
    throw UnimplementedError();
  }

  @override
  Future<Either<String, GradeResponseModel>> getInstructorGrades() {
    // TODO: implement getInstructorGrades
    throw UnimplementedError();
  }
}