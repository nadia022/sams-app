import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/delete_single_item_dialog.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/file_preview_screen.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/material_item_card.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/video_player_screen.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialContentGrid extends StatelessWidget {
  final List<MaterialItemModel> materials;
  final String materialId;
  const MaterialContentGrid({
    super.key,
    required this.materials,
    required this.materialId,
  });

  @override
  Widget build(BuildContext context) {
    if (materials.isEmpty) {
      return Center(
        child: Column(
          children: [
            Lottie.asset(
              AppLottie.empty,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'No files attached to this material.',
              style: AppStyles.web15Regular,
            ),
          ],
        ),
      );
    }

    final videoItems = materials.where((item) => item.isVideoItem).toList();
    final fileItems = materials.where((item) => !item.isVideoItem).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: [
        if (videoItems.isNotEmpty) ...[
          _buildSectionTitle('Videos'),
          _buildGrid(context, videoItems),
          const SizedBox(height: 24),
        ],
        if (fileItems.isNotEmpty) ...[
          _buildSectionTitle('Files & Documents'),
          _buildGrid(context, fileItems),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title,
        style: AppStyles.web24Semibold.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<MaterialItemModel> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MaterialItemCard(
          fileName: item.originalFileName ?? 'Unknown',
          description: '',
          icon: item.icon,
          iconColor: item.color,
          materialType: item.isVideoItem
              ? CourseMaterialType.video
              : CourseMaterialType.pdf,
          onTap: () => _handleItemTap(context, item),
          onDelete: () => _confirmAndDelete(context, item),
        );
      },
    );
  }

  void _confirmAndDelete(BuildContext context, MaterialItemModel item) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<MaterialCrudCubit>(),
        child: DeleteSingleItemDialog(
          materialId: materialId,
          itemKey: item.key ?? '',
          fileName: item.originalFileName ?? 'Unknown File',
        ),
      ),
    );
  }

  void _handleItemTap(BuildContext context, MaterialItemModel file) async {
    final url = file.displayUrl ?? '';
    if (url.isEmpty) return;

    if (kIsWeb) {
      await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
    } else {
      if (file.isVideoItem) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoUrl: url,
              videoTitle: file.originalFileName ?? 'Video',
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilePreviewScreen(
              url: url,
              fileName: file.originalFileName ?? 'File',
            ),
          ),
        );
      }
    }
  }
}
