import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  // Create storage instance
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Keys for all stored values
  static const String keyAccessToken = "ACCESS_TOKEN";
  static const String keyRefreshToken = "REFRESH_TOKEN";
  static const String keyUserId = "USER_ID";
  static const String keyEmail = "EMAIL";
  static const String keyUsername = "USERNAME";
  static const String role = "ROLE";
  static const String fcmToken = "fcmToken";

  // Save a value
  static Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read a value
  static Future<String?> readValue(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a value
  static Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all values
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
