import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:task_pragati/theme/theme_provider.dart';
import '../models/home_viewmodel.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/navigation_button.dart';
import '../widgets/image_slider.dart';
import '../widgets/calendar_grid_view.dart';
import '../theme/app_colors.dart';
import '../theme/custom_typography.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _currentMenuItem = 'DPR'; // Default active menu item
  int _currentNavIndex = 2; // Default to Analytics tab

  // Navigation items stored in a Map
  final Map<String, IconData?> navigationItems = {
    'DPR': null,
    'Cash OutFlow': null,
    'Cash InFlow': null,
    'Material Issues': null,
    'M Reconciliation': null,
    'Material Receipt': null,
    'Go to Dashboard': null,
  };

  // Project data stored in a Map
  final Map<String, String> projectData = {
    "Project BedRock": "assets/images/concrete-construction.png",
    "Project Atlas": "assets/images/concstruction-site.png",
    "Project ShadowFX": "assets/images/doha-construction.png",
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors.getBackgroundColor(context),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 12,
                right: 8,
                top: 69,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildMainContent(context, viewModel),
                  const SizedBox(height: 20),
                  _buildProjectSlider(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.avatarBackgroundLight,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile_picture.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: AppColors.avatarBackgroundDark,
                        child: Icon(
                          Icons.person,
                          color: AppColors.getTextColor(context),
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning', style: context.greetingText),
                  Text('Shubham!', style: context.nameText),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // Theme Toggle Button
              IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textWhite
                          : AppColors.textDark,
                ),
                onPressed: () {
                  // Toggle the theme using provider
                  final themeProvider = Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  );
                  themeProvider.toggleTheme();
                },
              ),
              const SizedBox(width: 8),
              _buildNotificationIcon(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? InkWell(
          onTap: () {},
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: AppColors.notificationIconShadow,
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_outlined,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        )
        : IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textWhite,
          onPressed: () {},
        );
  }

  Widget _buildMainContent(BuildContext context, HomeViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column - Menu Buttons
        Expanded(flex: 4, child: _buildMenuButtons()),
        const SizedBox(width: 25),
        // Right Column - Progress and Calendar
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _buildDailyProgress(context, viewModel),
              const SizedBox(height: 16),
              _buildCalendarView(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = 353;
        final int buttonCount = navigationItems.length;
        final double buttonHeight = 34.0;
        final double totalButtonHeight = buttonHeight * buttonCount;
        final double spacing =
            (availableHeight - totalButtonHeight) / (buttonCount - 1);

        return SizedBox(
          height: availableHeight,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: navigationItems.keys.length,
            separatorBuilder: (context, index) => SizedBox(height: spacing),
            itemBuilder: (context, index) {
              final itemLabel = navigationItems.keys.elementAt(index);
              final itemIcon = navigationItems[itemLabel];
              return NavigationButton(
                label: itemLabel,
                leadingIcon: itemIcon,
                isActive: itemLabel == _currentMenuItem,
                onClick: () {
                  setState(() {
                    _currentMenuItem = itemLabel;
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDailyProgress(BuildContext context, HomeViewModel viewModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // gradient: null,
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.getBackgroundColor(context)
                : AppColors.lightBackground,
        border: Border.all(
          width: 2,
          style: BorderStyle.solid,
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primaryPurpleDark
                  : Colors.transparent,
        ),
        boxShadow:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.lightModeShadow
                : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Progress', style: context.dailyProgressTitle),
            const SizedBox(height: 5),
            Text("From all projects", style: context.dailyProgressSubtitle),
            const SizedBox(height: 10),
            Center(
              child: ProgressIndicatorWidget(
                widgetSize: 110,
                progressDescription: 'Based on Reports',
                staticProgress: 0.9,
                day: 16,
                month: 1,
                totalDaysInMonth: 31,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // gradient: null,
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.getBackgroundColor(context)
                : AppColors.lightBackground,
        border: Border.all(
          width: 2,
          style: BorderStyle.solid,
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primaryPurpleDark
                  : Colors.transparent,
        ),
        boxShadow:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.lightModeShadow
                : null,
      ),
      child: const CalendarGridView(),
    );
  }

  Widget _buildProjectSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ImageSlider(
        imageList: projectData.values.toList(),
        titleList: projectData.keys.toList(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.navbarBackground
                : AppColors.navbarLightBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.navbarShadow
                : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, 'assets/icons/navbar/home.svg', 'Home', 24),
          _buildNavItem(
            1,
            'assets/icons/navbar/cash.svg',
            'Cash Flow',
            24,
            showCurrency: true,
          ),
          _buildNavItem(
            2,
            'assets/icons/navbar/analytics.svg',
            'Analytics',
            24,
          ),
          _buildNavItem(3, 'assets/icons/navbar/progress.svg', 'Progress', 24),
          _buildNavItem(4, 'assets/icons/navbar/material.svg', 'Material', 30),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String iconPath,
    String label,
    int size, {
    bool showCurrency = false,
  }) {
    final isSelected = index == _currentNavIndex;

    return Expanded(
      child: InkWell(
        onTap: () => _onNavTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: size.toDouble(),
                  height: size.toDouble(),
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? AppColors.primaryPurple
                        : Theme.of(context).brightness == Brightness.dark
                        ? AppColors.navIconGrey
                        : AppColors.navIconLightGrey,
                    BlendMode.srcIn,
                  ),
                ),
                if (showCurrency)
                  Positioned(
                    child: Text(
                      '₹',
                      style: TextStyle(
                        color:
                            isSelected
                                ? AppColors.primaryPurple
                                : Theme.of(context).brightness ==
                                    Brightness.dark
                                ? AppColors.navIconGrey
                                : AppColors.navIconLightGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style:
                  isSelected
                      ? context.navbarTextActive.copyWith(
                        color: AppColors.primaryPurple,
                      )
                      : context.navbarText,
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    if (_currentNavIndex != index) {
      setState(() {
        _currentNavIndex = index;
      });

      final navLabels = [
        'Home',
        'Cash Flow',
        'Analytics',
        'Progress',
        'Material',
      ];
    }
  }
}
