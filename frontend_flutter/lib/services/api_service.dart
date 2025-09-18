// lib/services/api_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class ApiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ---- AUTH methods ----
  Future<UserModel?> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) return null;

    final profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) return null;

    return UserModel.fromJson(profile);
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  User? currentUser() => _supabase.auth.currentUser;

  // ---- NEW METHODS ----

  // Upload image to issue_imgaes bucket
  Future<String> _uploadImage(File image) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';

    final uploadResponse =
        await _supabase.storage.from('issue_imgaes').upload(fileName, image);

    if (uploadResponse.isEmpty) {
      throw Exception('Image upload failed for $fileName');
    }

    return _supabase.storage.from('issue_imgaes').getPublicUrl(fileName);
  }

  // Submit issue
  Future<Map<String, dynamic>> submitIssue({
    required String title,
    required String description,
    required String category,
    required String location, // user-typed location
    required List<File> images,
    String? additionalInfo,
  }) async {
    final user = currentUser();
    if (user == null) {
      throw Exception("No logged-in user. Please login first.");
    }

    String? imageUrl;
    if (images.isNotEmpty) {
      imageUrl = await _uploadImage(images.first); // only first image
    }

    final response = await _supabase.from('issues').insert({
      'title': title,
      'description': description,
      'category': category,
      'location': location,       // store typed location
      'status': 'open',           // default status
      'created_by': user.id,
      'assigned_to': null,        // unassigned
      'image_url': imageUrl,
      'additional_information': additionalInfo,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).select().single();

    return response;
  }
}
