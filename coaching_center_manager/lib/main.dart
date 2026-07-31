import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_colors.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'providers/teacher_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/attendance_provider.dart';
import 'providers/fee_provider.dart';

// First Screen
import 'screens/splash_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/teacher_list_screen.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coaching Center Manager',

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          primaryColor: AppColors.primary,

          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: const Color(0xFF86BFE2),
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',

        routes: {
          '/': (context) => const SplashScreen(),
          '/get_started_screen': (context) => const GetStartedScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/dashboard_screen': (context) => const DashboardScreen(),
          '/teacher_list_screen': (context) => const TeacherListScreen(),
        },
      ),
    );
  }
}
