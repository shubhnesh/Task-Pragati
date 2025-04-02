import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_pragati/theme/theme_provider.dart';
import 'dart:async';
import 'theme/app_theme.dart';
import 'models/home_viewmodel.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer _timer;
  final homeViewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    // Refresh data periodically for the real-time updates
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      homeViewModel.refreshViewModelData();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => homeViewModel),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Project Progress',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const DashboardScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
