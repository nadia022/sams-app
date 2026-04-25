import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_response_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/user_pagination_model.dart';

/// Mock data provider for instructor grades view.
/// Simulates a full API response with columns, rows, and pagination.
class MockInstructorGrades {
  MockInstructorGrades._();

  static final List<GradeColumnModel> columns = [
    GradeColumnModel(key: 'student.academicId', name: 'ID'),
    GradeColumnModel(key: 'student.name', name: 'Name'),
    GradeColumnModel(
      key: '69bfb6e0236365ff8ee35687',
      name: 'Midterm',
      points: 15,
      isVisible: true,
    ),
    GradeColumnModel(
      key: '69bfb6e0236365ff8ee35688',
      name: 'Quiz 1',
      points: 5,
      isVisible: true,
    ),
    GradeColumnModel(
      key: '69bfb6e0236365ff8ee35689',
      name: 'Quiz 2',
      points: 5,
      isVisible: true,
    ),
    GradeColumnModel(
      key: '69bfb6e0236365ff8ee3568a',
      name: 'Quiz 3',
      points: 5,
      isVisible: true,
    ),
    GradeColumnModel(
      key: '69bfb6e0236365ff8ee3568b',
      name: 'Quiz 4',
      points: 5,
      isVisible: true,
    ),
    GradeColumnModel(
      key: '69bfb6e0236365ff8ee3568c',
      name: 'Quiz 5',
      points: 5,
      isVisible: false,
    ),
    GradeColumnModel(
      key: '69e110ea8e9564b7c505f4ff',
      name: 'Quiz 10',
      points: 10,
      isVisible: true,
    ),
    GradeColumnModel(
      key: '69e5328d55122bc6c698db6d',
      name: 'Assignment 1',
      points: 50,
      isVisible: true,
    ),
    GradeColumnModel(
      key: '69e539de55122bc6c698dd8d',
      name: 'Bonus',
      points: 5,
      isVisible: true,
    ),
  ];

  static final List<GradeRowModel> rows = [
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202202657',
        name: 'Yomna Abdelmegeed Fathallah',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': null,
        '69bfb6e0236365ff8ee35688': null,
        '69bfb6e0236365ff8ee35689': 8,
        '69bfb6e0236365ff8ee3568a': null,
        '69bfb6e0236365ff8ee3568b': null,
        '69bfb6e0236365ff8ee3568c': 9,
        '69e110ea8e9564b7c505f4ff': null,
        '69e5328d55122bc6c698db6d': null,
        '69e539de55122bc6c698dd8d': null,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202202986',
        name: 'John Doe Marcos',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 12,
        '69bfb6e0236365ff8ee35688': 4,
        '69bfb6e0236365ff8ee35689': 5,
        '69bfb6e0236365ff8ee3568a': 3,
        '69bfb6e0236365ff8ee3568b': 5,
        '69bfb6e0236365ff8ee3568c': 5,
        '69e110ea8e9564b7c505f4ff': 8,
        '69e5328d55122bc6c698db6d': 42,
        '69e539de55122bc6c698dd8d': 5,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202201234',
        name: 'Sara Ahmed Mohamed',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 14,
        '69bfb6e0236365ff8ee35688': 5,
        '69bfb6e0236365ff8ee35689': 4,
        '69bfb6e0236365ff8ee3568a': 5,
        '69bfb6e0236365ff8ee3568b': 3,
        '69bfb6e0236365ff8ee3568c': 4,
        '69e110ea8e9564b7c505f4ff': 9,
        '69e5328d55122bc6c698db6d': 48,
        '69e539de55122bc6c698dd8d': 3,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202203456',
        name: 'Mohamed Ali Hassan',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 10,
        '69bfb6e0236365ff8ee35688': 3,
        '69bfb6e0236365ff8ee35689': null,
        '69bfb6e0236365ff8ee3568a': 4,
        '69bfb6e0236365ff8ee3568b': 2,
        '69bfb6e0236365ff8ee3568c': null,
        '69e110ea8e9564b7c505f4ff': 7,
        '69e5328d55122bc6c698db6d': 35,
        '69e539de55122bc6c698dd8d': null,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202204567',
        name: 'Fatma Khaled Ibrahim',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 15,
        '69bfb6e0236365ff8ee35688': 5,
        '69bfb6e0236365ff8ee35689': 5,
        '69bfb6e0236365ff8ee3568a': 5,
        '69bfb6e0236365ff8ee3568b': 5,
        '69bfb6e0236365ff8ee3568c': 5,
        '69e110ea8e9564b7c505f4ff': 10,
        '69e5328d55122bc6c698db6d': 50,
        '69e539de55122bc6c698dd8d': 5,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202205678',
        name: 'Ahmed Tarek Sayed',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': null,
        '69bfb6e0236365ff8ee35688': 2,
        '69bfb6e0236365ff8ee35689': 3,
        '69bfb6e0236365ff8ee3568a': null,
        '69bfb6e0236365ff8ee3568b': 1,
        '69bfb6e0236365ff8ee3568c': 2,
        '69e110ea8e9564b7c505f4ff': null,
        '69e5328d55122bc6c698db6d': 20,
        '69e539de55122bc6c698dd8d': 2,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202206789',
        name: 'Nour Elsayed Mahmoud',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 13,
        '69bfb6e0236365ff8ee35688': 4,
        '69bfb6e0236365ff8ee35689': 5,
        '69bfb6e0236365ff8ee3568a': 4,
        '69bfb6e0236365ff8ee3568b': 5,
        '69bfb6e0236365ff8ee3568c': 3,
        '69e110ea8e9564b7c505f4ff': 8,
        '69e5328d55122bc6c698db6d': 45,
        '69e539de55122bc6c698dd8d': 4,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202207890',
        name: 'Omar Hossam Adel',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 11,
        '69bfb6e0236365ff8ee35688': 3,
        '69bfb6e0236365ff8ee35689': 4,
        '69bfb6e0236365ff8ee3568a': 3,
        '69bfb6e0236365ff8ee3568b': 4,
        '69bfb6e0236365ff8ee3568c': 4,
        '69e110ea8e9564b7c505f4ff': 6,
        '69e5328d55122bc6c698db6d': 38,
        '69e539de55122bc6c698dd8d': 3,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202208901',
        name: 'Mariam Fathy Youssef',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 14,
        '69bfb6e0236365ff8ee35688': 5,
        '69bfb6e0236365ff8ee35689': 5,
        '69bfb6e0236365ff8ee3568a': 4,
        '69bfb6e0236365ff8ee3568b': 5,
        '69bfb6e0236365ff8ee3568c': 5,
        '69e110ea8e9564b7c505f4ff': 9,
        '69e5328d55122bc6c698db6d': 47,
        '69e539de55122bc6c698dd8d': 5,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202209012',
        name: 'Hassan Wael Ezzat',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 9,
        '69bfb6e0236365ff8ee35688': null,
        '69bfb6e0236365ff8ee35689': 2,
        '69bfb6e0236365ff8ee3568a': null,
        '69bfb6e0236365ff8ee3568b': 3,
        '69bfb6e0236365ff8ee3568c': null,
        '69e110ea8e9564b7c505f4ff': 5,
        '69e5328d55122bc6c698db6d': 28,
        '69e539de55122bc6c698dd8d': null,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202200123',
        name: 'Layla Mohamed Ramadan',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 13,
        '69bfb6e0236365ff8ee35688': 4,
        '69bfb6e0236365ff8ee35689': 4,
        '69bfb6e0236365ff8ee3568a': 5,
        '69bfb6e0236365ff8ee3568b': 4,
        '69bfb6e0236365ff8ee3568c': 5,
        '69e110ea8e9564b7c505f4ff': 8,
        '69e5328d55122bc6c698db6d': 44,
        '69e539de55122bc6c698dd8d': 4,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202201456',
        name: 'Khaled Samir Mostafa',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 7,
        '69bfb6e0236365ff8ee35688': 2,
        '69bfb6e0236365ff8ee35689': 3,
        '69bfb6e0236365ff8ee3568a': 2,
        '69bfb6e0236365ff8ee3568b': null,
        '69bfb6e0236365ff8ee3568c': 1,
        '69e110ea8e9564b7c505f4ff': 4,
        '69e5328d55122bc6c698db6d': 22,
        '69e539de55122bc6c698dd8d': 1,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202202789',
        name: 'Rana Hany Abdallah',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 15,
        '69bfb6e0236365ff8ee35688': 5,
        '69bfb6e0236365ff8ee35689': 5,
        '69bfb6e0236365ff8ee3568a': 4,
        '69bfb6e0236365ff8ee3568b': 5,
        '69bfb6e0236365ff8ee3568c': 5,
        '69e110ea8e9564b7c505f4ff': 10,
        '69e5328d55122bc6c698db6d': 49,
        '69e539de55122bc6c698dd8d': 5,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202203890',
        name: 'Tamer Sherif Nabil',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': null,
        '69bfb6e0236365ff8ee35688': null,
        '69bfb6e0236365ff8ee35689': null,
        '69bfb6e0236365ff8ee3568a': null,
        '69bfb6e0236365ff8ee3568b': null,
        '69bfb6e0236365ff8ee3568c': null,
        '69e110ea8e9564b7c505f4ff': null,
        '69e5328d55122bc6c698db6d': null,
        '69e539de55122bc6c698dd8d': null,
      },
    ),
    GradeRowModel(
      student: GradeStudentModel(
        academicId: '202204901',
        name: 'Dina Ashraf Kamal',
      ),
      grades: {
        '69bfb6e0236365ff8ee35687': 12,
        '69bfb6e0236365ff8ee35688': 4,
        '69bfb6e0236365ff8ee35689': 3,
        '69bfb6e0236365ff8ee3568a': 5,
        '69bfb6e0236365ff8ee3568b': 4,
        '69bfb6e0236365ff8ee3568c': 3,
        '69e110ea8e9564b7c505f4ff': 7,
        '69e5328d55122bc6c698db6d': 40,
        '69e539de55122bc6c698dd8d': 3,
      },
    ),
  ];

  static final UserPaginationModel pagination = UserPaginationModel(
    totalElements: 15,
    currentPage: 1,
    size: 15,
    totalPages: 1,
    hasNextPage: false,
    hasPrevPage: false,
  );

  static final GradeResponseModel response = GradeResponseModel(
    status: 'success',
    columns: columns,
    rows: rows,
    pagination: pagination,
  );
}
