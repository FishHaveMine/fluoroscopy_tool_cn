import 'dart:convert';
import 'dart:ui';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// abstract class used to building your Custom AssetLoader
/// Example:
/// ```
///class FileAssetLoader extends AssetLoader {
///  @override
///  Future<Map<String, dynamic>> load(String path, Locale locale) async {
///    final file = File(path);
///    return json.decode(await file.readAsString());
///  }
///}
/// ```
abstract class AssetLoader {
  const AssetLoader();
  Future<Map<String, dynamic>?> load(String path, Locale locale);
}

///
/// default used is RootBundleAssetLoader which uses flutter's assetloader
///
class RootBundleAssetLoader extends AssetLoader {
  const RootBundleAssetLoader();

  String getLocalePath(String basePath, Locale locale) {
    return '$basePath/${locale.toStringWithSeparator(separator: "-")}.json';
  }

// Helper function to check if the path is a URL
  bool _isUrl(String path) {
    final uri = Uri.tryParse(path);
    return uri != null && uri.hasScheme;
  }

// Helper function to fetch translation data from the cloud
  Future<Map<String, dynamic>> _loadFromCloud(String url, Locale locale) async {
    try {
      final response = await http.get(Uri.parse(
          url + "lang=${locale.toStringWithSeparator(separator: "_")}"));

      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        return json.decode(decodedResponse)["data"];
      } else {
        throw Exception(
            'Failed to load translations from cloud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading translations from cloud: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    var localePath = getLocalePath(path, locale);
    EasyLocalization.logger.debug('Load asset from $path');
    // Check if the localePath is a URL (cloud address)
    if (_isUrl(localePath)) {
      try {
        EasyLocalization.logger.debug('Loading from cloud: $localePath');
        return await _loadFromCloud(path, locale);
      } catch (e) {
        var localePath = getLocalePath('assets/translations', locale);
        EasyLocalization.logger.debug('Loading from assets: $localePath');
        return json.decode(await rootBundle.loadString(localePath));
      }
    } else {
      // Otherwise, load from the assets
      if (path.contains("/data/user/")) {
        final file = File(localePath);
        return json.decode(await file.readAsString());
      }

      EasyLocalization.logger.debug('Loading from assets: $localePath');
      return json.decode(await rootBundle.loadString(localePath));
    }
  }
}
