import 'package:flutter/material.dart';
import '../constants/adaptive_size.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;

  final Widget? tablet;

  final Widget? desktop;

  const AdaptiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = context.deviceType;

        // layout based on screen size
        if (deviceType == DeviceType.desktop) {
          return desktop ?? tablet ?? mobile;
        } else if (deviceType == DeviceType.tablet) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// layout based on screen orientation
class AdaptiveOrientation extends StatelessWidget {
  /// display in portrait orientation
  final Widget portraitLayout;

  /// check display in landscape orientation
  final Widget? landscapeLayout;

  const AdaptiveOrientation({
    Key? key,
    required this.portraitLayout,
    this.landscapeLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;

    return isLandscape && landscapeLayout != null
        ? landscapeLayout!
        : portraitLayout;
  }
}

class AdaptiveGrid extends StatelessWidget {
  /// The list of widgets to display in the grid
  final List<Widget> gridItems;

  /// Minimum width for each grid item
  final double minGridItemWidth;

  /// Spacing between grid items
  final double gridSpacing;

  /// Padding around the grid
  final EdgeInsets? gridPadding;

  const AdaptiveGrid({
    Key? key,
    required this.gridItems,
    this.minGridItemWidth = 150,
    this.gridSpacing = 16,
    this.gridPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final adaptive = context.responsive;
        final width = constraints.maxWidth;

        // Calculate how many items can fit per row
        final itemWidth = adaptive.width(minGridItemWidth);
        final crossAxisCount = (width / (itemWidth + gridSpacing)).floor();

        // Ensure the column
        final columns = crossAxisCount > 0 ? crossAxisCount : 1;

        return GridView.builder(
          padding: gridPadding,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: adaptive.spacing(gridSpacing),
            mainAxisSpacing: adaptive.spacing(gridSpacing),
            childAspectRatio: 1, // Can be customized if needed
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) => gridItems[index],
        );
      },
    );
  }
}
