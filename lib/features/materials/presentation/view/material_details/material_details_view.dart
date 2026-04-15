import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/mobile/mobile_material_details_view.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/web/web_material_details_view.dart';

class MaterialDetailsView extends StatelessWidget {
  const MaterialDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final String courseId =
        GoRouterState.of(context).pathParameters['courseId'] ?? '';
    return AdaptiveLayout(
      mobileLayout: (context) =>  MobileMaterialDetailsView(courseId: courseId,),
       webLayout: (context) =>  WebMaterialDetailsView(courseId: courseId,),
    );
  }
}
