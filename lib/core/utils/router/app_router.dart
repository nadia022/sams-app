import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/utils/router/build_route.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/general_error_page.dart';

// Auth
import 'package:sams_app/features/auth/data/repos/auth_repo.dart';
import 'package:sams_app/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:sams_app/features/auth/presentation/view_models/password_reset_cubit/password_reset_cubit.dart';
import 'package:sams_app/features/auth/presentation/view_models/sign_up_cubit/sign_up_cubit.dart';
import 'package:sams_app/features/auth/presentation/views/login/login_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/forgot_password_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/reset_password_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/verify_otp_view.dart';
import 'package:sams_app/features/auth/presentation/views/sign_up/activate_account_view.dart';
import 'package:sams_app/features/auth/presentation/views/sign_up/sign_up_view.dart';

// Home & Profile
import 'package:sams_app/features/course_details/presentation/view/course_details_view.dart';
import 'package:sams_app/features/home/data/repos/home_repo.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/views/create_course/create_course_view.dart';
import 'package:sams_app/features/home/presentation/views/home/home_view.dart';
import 'package:sams_app/features/profile/data/repos/profile_repo.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/views/profile/profile_view.dart';

// Quiz
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/create_quiz_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/grade_submission_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/manage_questions_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/quiz_details_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/submissions_list_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/take_quiz/take_quiz_view.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/quiz_details_cubit/quiz_details_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/submissions_cubit/submissions_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/take_quiz_cubit/take_quiz_cubit.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final appRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesName.login,
    errorBuilder: (context, state) => const GeneralErrorPage(),
    routes: [
      // ─────────────────────────────────────────────────────────────────────
      // AUTH
      // ─────────────────────────────────────────────────────────────────────

      buildRoute(
        name: RoutesName.login,
        path: RoutesName.login,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginCubit(getIt<AuthRepo>()),
          child: const LoginView(),
        ),
      ),

      // Sign-up flow: SignUpCubit shared across SignUpView → ActivateAccountView
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (_) => SignUpCubit(getIt<AuthRepo>()),
          child: child,
        ),
        routes: [
          GoRoute(
            name: RoutesName.signUp,
            path: RoutesName.signUp,
            builder: (context, state) => const SignUpView(),
          ),
          GoRoute(
            name: RoutesName.activateAccount,
            path: RoutesName.activateAccount,
            builder: (context, state) => const ActivateAccountView(),
          ),
        ],
      ),

      // Password-reset flow: PasswordResetCubit shared across 3 screens
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (_) => PasswordResetCubit(getIt<AuthRepo>()),
          child: child,
        ),
        routes: [
          GoRoute(
            name: RoutesName.forgotPassword,
            path: RoutesName.forgotPassword,
            builder: (context, state) => const ForgotPasswordView(),
          ),
          GoRoute(
            name: RoutesName.verifyOtp,
            path: RoutesName.verifyOtp,
            builder: (context, state) => const VerifyOtpView(),
          ),
          GoRoute(
            name: RoutesName.resetPassword,
            path: RoutesName.resetPassword,
            builder: (context, state) => const ResetPasswordView(),
          ),
        ],
      ),

      // ─────────────────────────────────────────────────────────────────────
      // HOME & PROFILE
      // ─────────────────────────────────────────────────────────────────────

      buildRoute(
        name: RoutesName.courses,
        path: RoutesName.courses,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              HomeCubit(getIt<HomeRepo>(), role: CurrentRole.role)
                ..fetchMyCourses(role: CurrentRole.role),
          child: const HomeView(),
        ),
      ),

      buildRoute(
        name: RoutesName.createCourse,
        path: RoutesName.createCourse,
        builder: (context, state) {
          // HomeCubit is passed as extra from HomeView
          final homeCubit = state.extra as HomeCubit;
          return BlocProvider.value(
            value: homeCubit,
            child: const CreateCourseView(),
          );
        },
      ),

      buildRoute(
        name: RoutesName.profile,
        path: RoutesName.profile,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              ProfileCubit(getIt<ProfileRepo>())..getUserProfile(),
          child: const ProfileView(),
        ),
      ),

      // ─────────────────────────────────────────────────────────────────────
      // COURSE DETAILS  — tabs are widgets, NOT routes
      // extra: CourseHeaderCardModel (required, null-safe guarded below)
      // ─────────────────────────────────────────────────────────────────────

      buildRoute(
        name: RoutesName.courseDetails,
        path: RoutesName.courseDetails,
        builder: (context, state) {
          final model = state.extra as CourseHeaderCardModel?;
          if (model == null) return const GeneralErrorPage();
          return CourseDetailsView(courseModel: model);
        },
      ),

      // ─────────────────────────────────────────────────────────────────────
      // QUIZ STANDALONE ROUTES — all flat, all at root level
      // ─────────────────────────────────────────────────────────────────────

      // extra: { 'quizId': String }
      buildRoute(
        name: RoutesName.quizDetails,
        path: RoutesName.quizDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final quizId = extra?['quizId'] as String? ?? '';
          
          return BlocProvider(
            create: (_) => QuizDetailsCubit(getIt<QuizRepository>()),
            child: QuizDetailsView(quizId: quizId),
          );
        },
      ),

      // extra: { 'courseId': String }
      buildRoute(
        name: RoutesName.createQuiz,
        path: RoutesName.createQuiz,
        builder: (context, state) => BlocProvider(
          create: (_) => ManageQuizCubit(getIt<QuizRepository>()),
          child: const CreateQuizView(),
        ),
      ),

      // extra: { 'quizId': String }
      buildRoute(
        name: RoutesName.manageQuestions,
        path: RoutesName.manageQuestions,
        builder: (context, state) => BlocProvider(
          create: (_) => ManageQuizCubit(getIt<QuizRepository>()),
          child: const ManageQuestionsView(),
        ),
      ),

      // extra: { 'quizId': String, 'quizTitle': String }
      buildRoute(
        name: RoutesName.takeQuiz,
        path: RoutesName.takeQuiz,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final quizId = extra?['quizId'] as String? ?? '';
          final quizTitle = extra?['quizTitle'] as String? ?? 'Quiz';
          return BlocProvider(
            create: (_) =>
                TakeQuizCubit(getIt<QuizRepository>())
                  ..fetchQuestionsAndStart(quizId),
            child: TakeQuizView(quizTitle: quizTitle),
          );
        },
      ),

      // extra: { 'quizId': String }
      buildRoute(
        name: RoutesName.submissionsList,
        path: RoutesName.submissionsList,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final quizId = extra?['quizId'] as String? ?? '';
          return BlocProvider(
            create: (_) =>
                SubmissionsCubit(getIt<QuizRepository>())
                  ..fetchAllSubmissions(quizId: quizId),
            child: const SubmissionsListView(),
          );
        },
      ),

      // extra: { 'submissionId': String }
      buildRoute(
        name: RoutesName.gradeSubmission,
        path: RoutesName.gradeSubmission,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final submissionId = extra?['submissionId'] as String? ?? '';
          return BlocProvider(
            create: (_) => GradingCubit(getIt<QuizRepository>()),
            child: GradeSubmissionView(submissionId: submissionId),
          );
        },
      ),
    ],
  );
}
