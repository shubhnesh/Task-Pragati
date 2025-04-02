import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/custom_typography.dart';
import 'custom_progress_indicator.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double widgetSize; // Size of the circular progress indicator
  final String progressDescription;
  final double staticProgress; // Description label for the progress
  final int day; // Static day to display
  final int month; // Static month to display
  final int totalDaysInMonth; // Total days in the static month

  const ProgressIndicatorWidget({
    Key? key,
    required this.widgetSize,
    required this.progressDescription,
    required this.staticProgress,
    required this.day,
    required this.month,
    required this.totalDaysInMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentMonth = _getMonthName(month);

    // Calculate the progress percentage based on the static day and total days in the month
    // final calculatedProgress = day / totalDaysInMonth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular progress indicator
        SizedBox(
          height: widgetSize,
          width: widgetSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widgetSize, widgetSize),
                painter: CustomProgressIndicator(
                  progress: staticProgress, // Use calculated progress
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textWhite.withOpacity(0.1)
                          : AppColors.textDark.withOpacity(0.1),
                  progressColor: AppColors.primaryPurple,
                  strokeWidth: 15.0,
                  startAngle: 135,
                  sweepAngle: 270,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDayCircle(context, day),
                  const SizedBox(height: 4),
                  Text(currentMonth, style: context.monthNameText),
                ],
              ),
            ],
          ),
        ),

        _buildProgressDescription(context, staticProgress),
      ],
    );
  }

  /// Builds the circular container for the day in the center
  Widget _buildDayCircle(BuildContext context, int day) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accentBlue,
      ),
      child: Center(child: Text('$day', style: context.dateNumberText)),
    );
  }

  Widget _buildProgressDescription(
    BuildContext context,
    double calculatedProgress,
  ) {
    return Transform.translate(
      offset: const Offset(0, -20), // Overlap with the circle
      child: Container(
        width: 190,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryPurpleDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0%',
                  style: context.percentRangeText.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                Text(
                  '${(calculatedProgress * 100).toInt()}%',
                  style: context.percentageText.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                Text(
                  '100%',
                  style: context.percentRangeText.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              progressDescription,
              style: context.basedOnReportsText.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the month name for the given month
  String _getMonthName(int month) {
    // const monthName = 'Jan';
    return 'Jan';
  }
}
