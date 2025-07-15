import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_strings.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_image.dart';

class GpsHomeScreen extends StatelessWidget {
  const GpsHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppConstants.textPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.gpsHome,
          style: TextStyle(
            color: AppConstants.textPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppConstants.textPrimaryColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.home_outlined,
              color: AppConstants.textPrimaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppConstants.cardColor,
              child: _buildAlertCard(),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // color: AppConstants.lightBlueBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    _buildMenuGrid(context),
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildTrackVehiclesCard(context),
                    // Space for bottom illustration
                  ],
                ),
              ),
            ),
            buildBottomBannerImageWidget(),
            _buildBuyNewGpsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(color: AppConstants.warningColor),
      child: Row(
        children: [
          const Icon(Icons.warning, color: AppConstants.errorColor, size: 16),

          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.expiryAlert,
                  style: const TextStyle(
                    color: AppConstants.errorColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  AppStrings.devicesExpiringSoon,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              AppStrings.renewPlan,
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      _MenuItem(
        AppStrings.dashboard,
        Icons.dashboard_outlined,
        AppConstants.primaryColor,
        () {
          context.push(AppRouteName.gpsDashboard);
        },
      ),
      _MenuItem(
        AppStrings.geofence,
        Icons.location_on_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.foi,
        Icons.my_location_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.immobilise,
        Icons.flash_off_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.vehicleShareUpdate,
        Icons.share_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.subscription,
        Icons.credit_card_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.faq,
        Icons.help_outline,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.settings,
        Icons.settings_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.reports,
        Icons.assessment_outlined,
        AppConstants.primaryColor,
        () {},
      ),
      _MenuItem(
        AppStrings.orders,
        Icons.shopping_cart_outlined,
        AppConstants.primaryColor,
        () {},
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuCard(item);
      },
    );
  }

  Widget _buildMenuCard(_MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.lightBlueBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 28, color: item.color),
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackVehiclesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstants.lightBlueBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.location_on,
            color: AppConstants.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          AppStrings.trackMyVehicles,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
            fontSize: 15,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppConstants.textSecondaryColor,
        ),
        onTap: () {
          context.push(AppRouteName.gpsDashboard);
        },
      ),
    );
  }

  // Bottom Banner Gro Image
  Widget buildBottomBannerImageWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        AppImage.png.signUpBanner,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildBuyNewGpsButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          AppStrings.buyNewGps,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _MenuItem(this.title, this.icon, this.color, this.onTap);
}

class _BuildingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    // Draw simple building shapes
    final buildings = [
      Rect.fromLTWH(0, size.height * 0.3, size.width * 0.15, size.height * 0.7),
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.1,
        size.width * 0.18,
        size.height * 0.9,
      ),
      Rect.fromLTWH(
        size.width * 0.45,
        size.height * 0.4,
        size.width * 0.15,
        size.height * 0.6,
      ),
      Rect.fromLTWH(
        size.width * 0.65,
        size.height * 0.2,
        size.width * 0.2,
        size.height * 0.8,
      ),
      Rect.fromLTWH(
        size.width * 0.9,
        size.height * 0.5,
        size.width * 0.1,
        size.height * 0.5,
      ),
    ];

    for (final building in buildings) {
      canvas.drawRect(building, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
