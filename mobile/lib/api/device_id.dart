import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

/// デバイス固有IDを取得する（iOS: identifierForVendor, Android: androidId, それ以外は空文字列）
Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id ?? '';
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? '';
  } else {
    // Webやその他プラットフォーム
    return '';
  }
}
