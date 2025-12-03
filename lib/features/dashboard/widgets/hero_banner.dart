import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_text.dart';
import 'package:myapp/core/theme/app_spacing.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.space24, horizontal: AppSpacing.space16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: isMobile
              ? _buildMobileLayout(context)
              : _buildWebLayout(context),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset Management',
          style: AppText.headlineMedium.copyWith(color: AppColors.onPrimary),
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          'Track and manage your office assets with ease.',
          style: AppText.bodyLarge.copyWith(color: AppColors.onPrimary.withOpacity(0.8)),
        ),
        const SizedBox(height: AppSpacing.space16),
        Center(
          child: Image.asset(
            'assets/images/hero_image.png', 
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Asset Management Dashboard',
                style: AppText.displaySmall.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.space16),
              Text(
                'An intuitive interface to track, assign, and manage all your office assets efficiently. Get a complete overview of your inventory at a glance.',
                style: AppText.titleMedium.copyWith(color: AppColors.onPrimary.withOpacity(0.8)),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.space32),
        Image.asset(
          'assets/images/hero_image.png',
          height: 200,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
