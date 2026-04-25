import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';

/// Mock data provider for student grades view.
/// Simulates the student's own grades response.
class MockStudentGrades {
  MockStudentGrades._();

  static final List<StudentGradeModel> grades = [
    StudentGradeModel(
      classwork: 'Midterm',
      score: null,
      maxScore: 15,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Quiz 1',
      score: null,
      maxScore: 5,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Quiz 2',
      score: 2.5,
      maxScore: 5,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Quiz 3',
      score: null,
      maxScore: 5,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Quiz 4',
      score: null,
      maxScore: 5,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Quiz 5',
      score: 5,
      maxScore: 5,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Quiz 10',
      score: null,
      maxScore: 10,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Assignment 1',
      score: 42,
      maxScore: 50,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Bonus',
      score: null,
      maxScore: 5,
      isVisible: true,
    ),
    StudentGradeModel(
      classwork: 'Lab Work',
      score: 8,
      maxScore: 10,
      isVisible: false,
    ),
  ];
}
