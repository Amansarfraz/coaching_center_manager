import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'providers/teacher_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/attendance_provider.dart';
import 'providers/fee_provider.dart';
import 'providers/dashboard_provider.dart';

// Screens
import 'screens/auth/splash_screen.dart';
import 'screens/auth/get_started_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/teacher/teacher_list_screen.dart';
//import 'screens/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoachingCenterApp());
}

class CoachingCenterApp extends StatelessWidget {
  const CoachingCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => BatchProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => FeeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coaching Center Manager',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/get_started_screen': (context) => const GetStartedScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/teacher_list_screen': (context) => const TeacherListScreen(),
          //'/settings_screen': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
