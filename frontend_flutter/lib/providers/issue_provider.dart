import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../services/api_service.dart';

class IssueProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<IssueModel> _issues = [];
  List<IssueModel> get issues => _issues;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadIssues(String userId) async {
    _isLoading = true;
    notifyListeners();

    _issues = await _apiService.fetchIssues(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitIssue(IssueModel issue) async {
    _isLoading = true;
    notifyListeners();

    final newIssue = await _apiService.submitIssue(issue);
    _issues.add(newIssue);

    _isLoading = false;
    notifyListeners();
  }

  Future<IssueModel?> getIssueById(String issueId) async {
    return await _apiService.fetchIssueById(issueId);
  }
}
