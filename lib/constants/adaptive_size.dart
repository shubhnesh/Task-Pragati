import 'package:flutter/material.dart';

/// A utility class that provides tools for creating adaptive layouts
class AdaptiveSize {
  final double currentWidth;
  final double currentHeight;
  static const double baseWidth = 375;
  static const double baseHeight = 812;

  AdaptiveSize({required this.currentWidth, required this.currentHeight});

  /// Create a AdaptiveSize instance from BuildContext
  factory AdaptiveSize.of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return AdaptiveSize(
      currentWidth: mediaQuery.size.width,
      currentHeight: mediaQuery.size.height,
    );
  }

  /*Calculate a adaptive width based on design
  with constraints to ensure visibility on small screens */
  double width(double value) {
    final scale = currentWidth / baseWidth;
    final adjustedScale = scale.clamp(0.7, 1.2);
    return value * adjustedScale;
  }

  /*Calculate a Adaptive height value based on design
    with constraints to ensure visibility on small screens */
  double height(double value) {
    final scale = currentHeight / baseHeight;
    final adjustedScale = scale.clamp(0.65, 1.2);
    return value * adjustedScale;
  }

  /// Calculate adaptive font size
  double fontSize(double size) {
    return size;
  }

  /// Calculate adaptive spacing
  double spacing(double value) {
    if (value <= 1) return value;

    final scale = currentWidth / baseWidth;
    final adjustedScale = scale.clamp(0.75, 1.2);

    // Minimum spacing values for better visibility
    final result = value * adjustedScale;
    if (value <= 4) return result.clamp(1.0, double.infinity);
    if (value <= 8) return result.clamp(2.0, double.infinity);
    if (value <= 16) return result.clamp(4.0, double.infinity);
    return result.clamp(6.0, double.infinity);
  }

  /// Calculate adaptive radius
  double radius(double value) {
    final scale = currentWidth / baseWidth;
    final adjustedScale = scale.clamp(0.7, 1.2);
    return value * adjustedScale;
  }

  /// Determine device type based on screen width
  DeviceType get deviceType {
    if (currentWidth < 600) {
      return DeviceType.mobile;
    } else if (currentWidth < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if the device is in landscape mode
  bool get isLandscape => currentWidth > currentHeight;
}

/// different device types based on screen size
enum DeviceType { mobile, tablet, desktop }

extension ResponsiveContext on BuildContext {
  AdaptiveSize get responsive => AdaptiveSize.of(this);

  /// getting device type
  DeviceType get deviceType => AdaptiveSize.of(this).deviceType;

  /// check if device is in landscape orientation or not
  bool get isLandscape => AdaptiveSize.of(this).isLandscape;
}
