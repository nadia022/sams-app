import 'package:flutter/material.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_form/quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_form/quiz_form_screen.dart';

/// Mobile entry-point for the Create Quiz flow.
///
/// This widget is a thin delegate — all form logic, validation, and UI
/// live in [QuizFormScreen]. It builds a [QuizFormArgs] in Create mode
/// (no [QuizFormArgs.initialData]) and passes it straight through.
///
/// The `courseId` is read directly from GoRouter's path parameters so
/// this widget stays stateless and zero-knowledge about routing internals.
class CreateQuizMobileLayout extends StatelessWidget {
  /// The current course this quiz is being created for.
  final String courseId;

  const CreateQuizMobileLayout({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return QuizFormScreen(
      args: QuizFormArgs(courseId: courseId),
    );
  }
}
