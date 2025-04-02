import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/custom_typography.dart';

class CalendarGridView extends StatelessWidget {
  final double dotDiameter;
  final double gridSpacing;

  const CalendarGridView({
    Key? key,
    this.dotDiameter = 9.0,
    this.gridSpacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Static month: January
    const int currentDay = 16; // 15 days remaining
    const int daysInMonth = 31;
    const String currentMonth = "January";
    const int daysRemaining = 15;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.navbarBackground
                : AppColors.navbarLightBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.clockCircleBackground
                          : AppColors.calendarClockBackgroundLight,
                ),
                child: Icon(
                  Icons.access_time,
                  size: 18,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.navbarBackground
                          : Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentMonth, style: context.calendarMonthText),
                    Text(
                      '$daysRemaining Days Remaining',
                      style: context.calendarDaysText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Grid for dot indicator
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 12, // 12 dots per row
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final dayNumber = index + 1; // 1-indexed day
              final bool isPastDay = dayNumber <= currentDay;

              return Container(
                width: dotDiameter,
                height: dotDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      !isPastDay
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textWhite.withOpacity(0.3)
                              : AppColors.textDark.withOpacity(0.3))
                          : null,
                  gradient: isPastDay ? AppColors.purpleGradient : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
