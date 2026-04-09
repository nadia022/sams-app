import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'dart:developer';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'quiz_action_type.dart';

class InstructorActionHandler {
  // Main execution method
  static void execute({
    required BuildContext context,
    required QuizActionType action,
    required QuizModel quiz,
  }) {
    switch (action) {
      case QuizActionType.addQuestions:
        _navigateToAddQuestions(context, quiz);
        break;
      case QuizActionType.manageQuestions:
        _navigateToManageQuestions(context, quiz);
        break;
      case QuizActionType.viewQuestions:
        _navigateToViewQuestions(context, quiz);
        break;
      case QuizActionType.viewSubmissions:
        _navigateToSubmissions(context, quiz);
        break;
    }
  }

  // Navigation Logic
  static void _navigateToAddQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to Add Questions for quiz: ${quiz.id}');
    context.push(
      RoutesName.manageQuestions,
      extra: {'quizId': quiz.id},
    );
  }

  static void _navigateToManageQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to Manage Questions for quiz: ${quiz.id}');
    context.push(
      RoutesName.manageQuestions,
      extra: {'quizId': quiz.id},
    );
  }

  static void _navigateToViewQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to View Questions for quiz: ${quiz.id}');
    context.push(
      RoutesName.manageQuestions,
      extra: {'quizId': quiz.id},
    );
  }

  static void _navigateToSubmissions(BuildContext context, QuizModel quiz) {
    log('Navigating to Submissions for quiz: ${quiz.id}');
    context.push(
      RoutesName.submissionsList,
      extra: {'quizId': quiz.id, 'quizTitle': quiz.title},
    );
  }
}
