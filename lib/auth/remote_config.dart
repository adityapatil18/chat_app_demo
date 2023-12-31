import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseRemoteConfigService {
 FirebaseRemoteConfigService._() : _remoteConfig = FirebaseRemoteConfig.instance; // MODIFIED

  static FirebaseRemoteConfigService? _instance; // NEW
  factory FirebaseRemoteConfigService() => _instance ??= FirebaseRemoteConfigService._(); // NEW

  final FirebaseRemoteConfig _remoteConfig;
String getString(String key) => _remoteConfig.getString(key); // NEW
  bool getBool(String key) =>_remoteConfig.getBool(key); // NEW
  int getInt(String key) =>_remoteConfig.getInt(key); // NEW
  double getDouble(String key) =>_remoteConfig.getDouble(key); // NEW


Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
    const {
      FirebaseRemoteConfigKeys.welcomeMessage: 'Hey there, this message is coming from local defaults.',
    },
  );
  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
      debugPrint('The config has been updated.');
    } else {
      debugPrint('The config is not updated..');
    }
  }

Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate();
}

}

final message = FirebaseRemoteConfigService().getString(FirebaseRemoteConfigKeys.welcomeMessage);


class FirebaseRemoteConfigKeys {
  static const String welcomeMessage = 'welcome_message';
}