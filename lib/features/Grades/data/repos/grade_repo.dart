import 'package:dartz/dartz.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_response_model.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';

abstract class GradeRepo {
  Future<Either<String, StudentGradeModel>> getStudentGrades();
  Future<Either<String, GradeResponseModel>> getInstructorGrades();
}
