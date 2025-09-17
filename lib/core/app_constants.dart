class AppConstants {
  AppConstants._();

  // App
  static const String appName = 'Civic Issue Reporter';

  // Supabase placeholders (replace with real values in supabase_client.dart or environment)
  static const String supabaseUrl = 'https://your-project-ref.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';

  // Assets
  static const String logo = 'assets/images/logo.png';

  // Issue categories (example — modify to match your DB)
  static const List<String> issueCategories = [
    'Road / Pothole',
    'Streetlight',
    'Garbage / Sanitation',
    'Water Supply',
    'Drainage',
    'Other'
  ];

  // Status constants (use these in UI to keep color mapping consistent)
  static const String statusSubmitted = 'Submitted';
  static const String statusInProgress = 'In Progress';
  static const String statusResolved = 'Resolved';

  static const List<String> issueStatuses = [
    statusSubmitted,
    statusInProgress,
    statusResolved,
  ];
}
