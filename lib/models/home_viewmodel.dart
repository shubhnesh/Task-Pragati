import 'package:flutter/material.dart';
import 'project_model.dart';

class HomeViewModel extends ChangeNotifier {
  String userDisplayName = "Shubham";
  double _currentProgress = 0.65; // Default value
  int remainingDays = 15;

  List<Project> projects = [
    Project(
      name: "Project BedRock",
      imageUrl: "assets/images/concrete-construction.png",
      progress: 0.9,
      totalDots: 3,
      completedDots: 3,
    ),
  ];

  // Get the current progress
  double get currentProgress => _currentProgress;

  // Set the current progress
  set currentProgress(double value) {
    _currentProgress = value;
    notifyListeners();
  }

  // Calculate the percentage of month completed
  double get monthlyProgress {
    final currentDate = DateTime.now();
    final totalDaysInMonth =
        DateTime(currentDate.year, currentDate.month + 1, 0).day;
    return currentDate.day / totalDaysInMonth;
  }

  void refreshViewModelData() {
    _currentProgress = monthlyProgress;
    notifyListeners();
  }

  HomeViewModel() {
    refreshViewModelData();
  }

  // Update the remaining days and notify listeners
  void updateRemainingDays(int days) {
    remainingDays = days;
    notifyListeners();
  }
}
