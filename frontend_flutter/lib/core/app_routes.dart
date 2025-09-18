import 'package:flutter/material.dart';
import '../pages/complaint_list_page.dart';


// NOTE: make sure these files exist in lib/pages/ with matching class names.
import '../pages/splash_page.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';
import '../pages/home_page.dart';
import '../pages/report_issue_page.dart';
import '../pages/submitted_page.dart';
import '../pages/complaint_list_page.dart';
import '../pages/complaint_detail_page.dart';
import '../pages/map_view_page.dart';
import '../pages/profile_page.dart';

// ✅ Import your IssueModel
import '../models/issue_model.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String reportIssue = '/report_issue';
  static const String submitted = '/submitted';
  static const String complaintList = '/complaint_list_page';
  static const String complaintDetail =
      '/complaint_detail_page'; // expects IssueModel
  static const String mapView = '/map_view';
  static const String profile = '/profile';

  // Pages without special args
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    //signup: (_) => const SignupPage(),
    home: (_) => const HomePage(),
    reportIssue: (_) => const ReportIssuePage(),
    submitted: (_) => const SubmittedPage(),
    complaintList: (_) => const ComplaintListPage(),
    mapView: (_) => const MapViewPage(),
    profile: (_) => const ProfilePage(),
  };

  // onGenerateRoute for pages that require arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == complaintDetail) {
      final args = settings.arguments;

      if (args is IssueModel) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ComplaintDetailPage(issue: args), // ✅ Pass IssueModel
        );
      } else {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Invalid complaint data")),
          ),
        );
      }
    }

    // fallback to named map
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    // if nothing matches, show splash
    return MaterialPageRoute(
      builder: (_) => const SplashPage(),
      settings: settings,
    );
  }
}
