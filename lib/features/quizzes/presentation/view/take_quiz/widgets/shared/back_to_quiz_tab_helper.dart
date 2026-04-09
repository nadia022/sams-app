import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';

/// Navigates the user back to the course details view (which holds the Quizzes tab).
/// Since course details is now a flat route driven by IndexedStack, we simply pop
/// back to it. If there is nothing to pop (e.g. deep-link entry), fall back to /courses.
void backToQuizTab({required BuildContext context}) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(RoutesName.courses);
  }
}
