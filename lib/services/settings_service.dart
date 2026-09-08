import 'package:shared_preferences/shared_preferences.dart';

/// Reads/writes the backend URL and API key to disk so changes
/// made in the settings screen survive an app restart.
class SettingsService {
  static const _urlKey = 'backend_base_url';
  static const _apiKeyKey = 'backend_api_key';

  static const String defaultUrl = 'https://upload.navyukth.tech';
  static const String defaultApiKey =
      'BUJW9WcudfVgNcoLLRVcM4YXE4+vWDv+gWBuNNHFigQ=';

  static Future<String> getBackendUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_urlKey) ?? defaultUrl;
  }

  static Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey) ?? defaultApiKey;
  }

  static Future<void> setBackendUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, url);
  }

  static Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }
}
