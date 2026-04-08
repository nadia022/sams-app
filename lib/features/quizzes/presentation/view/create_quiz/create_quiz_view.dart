import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/mobile/create_quiz_mobile_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/web/create_quiz_web_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

/// Adaptive shell for the Create Quiz flow.
///
/// Routes mobile → [CreateQuizMobileLayout] (which delegates to [QuizFormScreen])
/// Routes web    → [CreateQuizWebLayout] (stub, to be implemented).
///
/// NOTE: The router creates [QuizFormScreen] directly via the `quizForm` route.
/// This view remains as the adaptive wrapper called by the legacy `createQuiz` route.
class CreateQuizView extends StatelessWidget {
  final String courseId;

  const CreateQuizView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageQuizCubit, ManageQuizState>(
      listener: (context, state) {
        // TODO: Handle ManageQuizFailure (show snackbar) and
        //       ManageQuizSuccess (pop/navigate to quiz details)
      },
      builder: (context, state) {
        return AdaptiveLayout(
          mobileLayout: (context) =>
              CreateQuizMobileLayout(courseId: courseId),
          webLayout: (context) => const CreateQuizWebLayout(),
        );
      },
    );
  }
}
