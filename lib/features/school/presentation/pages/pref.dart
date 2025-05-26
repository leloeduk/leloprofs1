import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../auth/domain/entities/user_model.dart'; // Importer dart:convert pour jsonEncode et jsonDecode

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveUser(UserModel user) async {
    // Convertir l'objet UserModel en une chaîne JSON
    final String userJson = jsonEncode(user.toJson());
    await _prefs.setString('user', userJson);
  }

  static UserModel? getUser() {
    final String? userJson = _prefs.getString('user');
    if (userJson == null || userJson.isEmpty) return null;
    // Convertir la chaîne JSON en un Map, puis en un objet UserModel
    final Map<String, dynamic> userMap =
        jsonDecode(userJson) as Map<String, dynamic>;
    return UserModel.fromJson(userMap);
  }

  static String? getUserId() {
    return getUser()?.id;
  }

  static String? getUserRole() {
    return getUser()?.role;
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
