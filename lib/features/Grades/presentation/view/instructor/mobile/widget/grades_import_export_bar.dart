import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/shared/action_button.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/shared/export_excel_button.dart';

class GradesImportExportBar extends StatelessWidget {
  const GradesImportExportBar({
    super.key,
    required this.courseId,
    this.onImport,
  });

  final String courseId;
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ExportExcelButton(courseId: courseId),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ActionButton(
            label: 'Import',
            icon: Icon(Icons.file_upload_outlined, size: 18..clamp(16, 20)),
            color: AppColors.secondary,
            onPressed: onImport,
          ),
        ),
      ],
    );
  }
}
