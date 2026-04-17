import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';

/// Managed UI logic for the Materials Tab View.
/// Handles context menu positioning and coordinates actions between the UI and Navigation.
class MaterialTabHandler {
  /// Calculates and displays the context menu relative to the tapped card.
  /// Works for both Mobile and Web by using the anchorContext to find screen coordinates.
  static void showMaterialActionsMenu({
    required BuildContext context,
    required BuildContext anchorContext,
    required MaterialModel material,
    required String courseId,
  }) async {
    //* Logic: Identify the position of the specific card in the global coordinate space.
    final RenderBox button = anchorContext.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width, 0), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    //* Interaction: Display the popup menu with standardized styling.
    final String? selected = await showMenu<String>(
      context: context,
      position: position,
      color: AppColors.whiteLight,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        _buildMenuItem(
          value: 'edit',
          icon: Icons.edit,
          text: 'Edit',
          color: AppColors.primary,
        ),
        _buildMenuItem(
          value: 'delete',
          icon: Icons.delete_outline,
          text: 'Delete',
          color: Colors.red,
        ),
      ],
    );

    if (selected == null) return;

    //* Execution: Trigger the appropriate navigation or dialog logic.
    if (selected == 'delete'&& context.mounted) {
      MaterialsNavigationHandler.showDeleteDialog(context, material: material);
    } else if (selected == 'edit'&& context.mounted) {
      MaterialsNavigationHandler.navigateToEditMaterial(
        context,
        courseId: courseId,
        material: material,
      );
    }
  }

  /// Helper to maintain consistent row styling for menu items.
  static PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  /// Centralized card tap handling.
  static void handleCardTap(
    BuildContext context,
    MaterialModel material,
    String courseId,
  ) {
    MaterialsNavigationHandler.navigateToDetails(
      context,
      courseId: courseId,
      material: material,
    );
  }
}
