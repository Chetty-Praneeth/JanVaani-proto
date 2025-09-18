import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import 'core/app_colors.dart';
import 'core/app_routes.dart';

// Providers
import 'providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://iuqfhhdbmbxyfylwhosl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1cWZoaGRibWJ4eWZ5bHdob3NsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5NTE3MTMsImV4cCI6MjA3MzUyNzcxM30.qzMgjeQcicuC-8w8tT7c9hCuIOCdEiLl8HYUrdMlpDU',
  );

  runApp(const CivicApp());
}

class CivicApp extends StatelessWidget {
  const CivicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Civic Issue Reporter",
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes, // ✅ Use centralized routes map
        onGenerateRoute: AppRoutes.onGenerateRoute, // ✅ For routes that need arguments
      ),
    );
  }
}
