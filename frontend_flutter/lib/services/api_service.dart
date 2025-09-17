import '../models/user_model.dart';
import '../models/issue_model.dart';

class ApiService {
  // 🟢 USER AUTH METHODS
  Future<UserModel?> login(String email, String password) async {
    // TODO: Replace with Supabase login
    if (email == "test@example.com" && password == "1234") {
      return UserModel(
        id: "1",
        name: "Test User",
        email: email,
        phone: "9876543210",
      );
    }
    return null;
  }

  Future<UserModel?> signup(String name, String email, String phone, String password) async {
    // TODO: Replace with Supabase signup
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
    );
  }

  // 🟢 ISSUE METHODS
  Future<IssueModel> submitIssue(IssueModel issue) async {
    // TODO: Save to Supabase
    return issue;
  }

  Future<List<IssueModel>> fetchIssues(String userId) async {
    // TODO: Replace with Supabase fetch
    return [
      IssueModel(
        id: "1",
        title: "Pothole on Main Road",
        description: "Huge pothole near bus stop",
        category: "Roads",
        status: "Submitted",
        userId: userId,
        latitude: 17.385044,
        longitude: 78.486671,
        createdAt: DateTime.now(),
      ),
      IssueModel(
        id: "2",
        title: "Streetlight not working",
        description: "Streetlight near park is broken",
        category: "Electricity",
        status: "In Progress",
        userId: userId,
        latitude: 17.3910,
        longitude: 78.4870,
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<IssueModel?> fetchIssueById(String issueId) async {
    // TODO: Replace with Supabase query
    return IssueModel(
      id: issueId,
      title: "Water leakage",
      description: "Leakage near community hall",
      category: "Water",
      status: "Resolved",
      userId: "1",
      latitude: 17.39,
      longitude: 78.49,
      createdAt: DateTime.now(),
    );
  }
}
