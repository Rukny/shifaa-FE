import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const storage = FlutterSecureStorage();
  static Future<void> storeValue(String key, String value) async {

    await storage.write(key: key, value: value);
  }

  static Future<String?> retrieveValue(String key) async {
     String? value = await storage.read(key: key);
    log('retrieveValue and the $key is $value ');

    return value;
  }

  static Future<void> deleteValue(String key) async {

    await storage.delete(key: key);
  }

  static Future<void> clearStorage() async {
     await storage.deleteAll();
  }

  static Future<bool> checkIfValueExist(String key) async {
     return storage.containsKey(key: key);
  }
}
