import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/issue.dart'; // assuming you have an Issue model

class IssueProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // List of issues
  final List<Issue> _issues = [];
  List<Issue> get issues => _issues;

  // Track last submission success
  bool lastSubmissionSuccess = false;

  // Store last error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> submitIssue({
    required String title,
    required String description,
    required String category,
    required double lat,
    required double lng,
    required List<File> images,
    String? additionalInfo,
    String? cameraImagePath,
  }) async {
    _isLoading = true;
    _errorMessage = null; // clear previous error
    notifyListeners();

    try {
      final newIssue = await _apiService.submitIssue(
        title: title,
        description: description,
        category: category,
        lat: lat,
        lng: lng,
        images: images,
        additionalInfo: additionalInfo,
        cameraImagePath: cameraImagePath,
      );
      _issues.add(newIssue);
      lastSubmissionSuccess = true;
    } catch (e) {
      lastSubmissionSuccess = false;
      _errorMessage = e.toString(); // store error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
