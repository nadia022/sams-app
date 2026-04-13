import 'package:dartz/dartz.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/submit_quiz/quiz_answer_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/submit_quiz/submit_quiz_request_body.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final ApiConsumer api;

  QuizRepositoryImpl({required this.api});

  // --- Discovery Flow ---
  @override
  Future<Either<String, List<QuizModel>>> getQuizzesForCourse(
    String courseId,
  ) async {
    try {
      // 1. Fetch data from the endpoint
      final response = await api.get(EndPoints.getCourseQuizzes(courseId));

      // 2. Parse the response
      List<QuizModel> quizzes = (response[ApiKeys.data] as List)
          .map((quizJson) => QuizModel.fromJson(quizJson))
          .toList();

      return Right(quizzes);
    } on ApiException catch (e) {
      // Handle known API exceptions mapped by the interceptor
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      // Handle unexpected runtime exceptions
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, QuizModel>> getQuizDetails(String quizId) async {
    try {
      // 1. Fetch data from the endpoint
      final response = await api.get(EndPoints.getQuizDetails(quizId));

      // 2. Parse the response
      final quiz = QuizModel.fromJson(response[ApiKeys.data]);

      return Right(quiz);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // * get all questions for a quiz (/api/v1/quizzes/:quizId/questions)
  @override
  Future<Either<String, List<QuestionModel>>> getQuizQuestions(
    String quizId,
  ) async {
    try {
      // hit getAllQuestions request
      Map<String, dynamic> response = await api.get(
        EndPoints.getQuizQuestions(quizId),
      );

      //parsing and initialize questionsList
      final questionsList = response[ApiKeys.data] as List<dynamic>;
      final questions = questionsList
          .map((e) => QuestionModel.fromJson(e))
          .toList();

      return Right(questions); // success case, return questions
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  // --- Instructor Flow: Quiz CRUD ---

  @override
  Future<Either<String, String>> createQuiz(
    String courseId,
    Map<String, dynamic> data,
  ) async {
    // TODO: implement createQuiz
    throw UnimplementedError();
  }

  @override
  Future<Either<String, String>> updateQuiz(
    String quizId,
    Map<String, dynamic> data,
  ) async {
    // TODO: implement updateQuiz
    throw UnimplementedError();
  }

  @override
  Future<Either<String, Unit>> deleteQuiz(String quizId) async {
    try {
      await api.delete(EndPoints.deleteQuiz(quizId));
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> toggleQuizPublished(String quizId) async {
    // TODO: implement toggleQuizPublished
    throw UnimplementedError();
  }

  // --- Instructor Flow: Questions CRUD ---

  @override
  Future<Either<String, Unit>> addQuestion(
    String quizId,
    Map<String, dynamic> data,
  ) async {
    try {
      await api.post(EndPoints.createQuestion(quizId), data: data);
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> updateQuestion(
    String questionId,
    Map<String, dynamic> data,
  ) async {
    try {
      await api.patch(EndPoints.updateQuestion(questionId), data: data);
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteQuestion(String questionId) async {
    try {
      await api.delete(EndPoints.deleteQuestion(questionId));
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // ! --- Student Flow: Taking Quizzes ---

  // * submit quiz (/api/v1/quizzes/:quizId/submit)
  @override
  Future<Either<String, String>> submitQuiz(
    String quizId,
    List<QuizAnswerModel> answers,
  ) async {
    try {
      // hit submitQuiz request
      Map<String, dynamic> response = await api.post(
        EndPoints.submitQuiz(quizId),
        data: SubmitQuizRequestBody(answers: answers).toJson(),
      );

      return Right(response[ApiKeys.message]); // success case, return message
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  // ! --- Instructor Flow: Grading ---

  // * get all submissions (/api/v1/instructor/quizzes/:quizId/submissions)
  @override
  Future<Either<String, List<SubmissionModel>>> getAllSubmissions(
    String quizId,
  ) async {
    try {
      // hit getAllSubmissions request
      Map<String, dynamic> response = await api.get(
        EndPoints.getQuizSubmissions(quizId),
      );

      // parsing and initialize submissionsList
      final submissionsList = response[ApiKeys.data] as List<dynamic>;
      final submissions = submissionsList
          .map((e) => SubmissionModel.fromJson(e))
          .toList();

      return Right(submissions); // success case, return list of submissions
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  // * get student submission (/api/v1/instructor/submissions/:submissionId)
  @override
  Future<Either<String, List<StudentSubmissionModel>>> getStudentSubmission(
    String submissionId,
  ) async {
    try {
      // hit getStudentSubmission request
      Map<String, dynamic> response = await api.get(
        EndPoints.getSubmissionDetails(submissionId),
      );

      // parsing and initialize studentSubmissionList
      final studentSubmissionList = response[ApiKeys.data] as List<dynamic>;
      final studentSubmissions = studentSubmissionList
          .map((e) => StudentSubmissionModel.fromJson(e))
          .toList();

      return Right(
        studentSubmissions,
      ); // success case, return list of student submissions
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  // * grade written question (/api/v1/submissions/:submissionId/questions/:questionId)
  @override
  Future<Either<String, String>> gradeWrittenQuestion(
    String submissionId,
    String questionId,
    num grade,
  ) async {
    try {
      // hit gradeWrittenQuestion request
      Map<String, dynamic> response = await api.patch(
        EndPoints.gradeQuestion(submissionId, questionId),
        data: {
          ApiKeys.earnedPoints: grade,
        },
      );

      return Right(
        response[ApiKeys.message],
      ); // success case, return success message
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }
}
