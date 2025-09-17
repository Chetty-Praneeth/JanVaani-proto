import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/app_routes.dart';
import 'core/app_colors.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/issue_provider.dart';
import 'providers/map_provider.dart';

// Pages
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';
import 'pages/report_issue_page.dart';
import 'pages/submitted_page.dart';
import 'pages/complaint_list_page.dart';
import 'pages/map_view_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const CivicApp());
}

class CivicApp extends StatelessWidget {
  const CivicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => IssueProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Civic Issue Reporter",
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ),
        initialRoute: AppRoutes.splash,

        // ✅ only static routes here (no complaintDetail!)
        routes: {
          AppRoutes.splash: (context) => const SplashPage(),
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.signup: (context) => const SignupPage(),
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.reportIssue: (context) => const ReportIssuePage(),
          AppRoutes.submitted: (context) => const SubmittedPage(),
          AppRoutes.complaintList: (context) => const ComplaintListPage(),
          AppRoutes.mapView: (context) => const MapViewPage(),
          AppRoutes.profile: (context) => const ProfilePage(),
        },

        // ✅ dynamic routing handled here
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
