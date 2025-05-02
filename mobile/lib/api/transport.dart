// ignore_for_file: prefer_function_declarations_over_variables

import 'package:connectrpc/http2.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:connectrpc/connect.dart';
import 'device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cookieKey = 'saved_cookie';
const _jwtKey = 'saved_jwt';

Future<String?> getSavedCookie() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_cookieKey);
}

Future<void> persistCookie(String cookie) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_cookieKey, cookie);
}

Future<String?> getSavedJwt() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_jwtKey);
}

Future<void> persistJwt(String jwt) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_jwtKey, jwt);
}

final Interceptor deviceIdInterceptor = <I extends Object, O extends Object>(
  next,
) {
  return (req) async {
    final stopwatch = Stopwatch()..start();
    final uri = req.url.toString();

    final deviceId = await getDeviceId();

    // Cookie を都度取得して付与
    final cookie = await getSavedCookie();
    if (cookie != null) {
      req.headers.set("cookie", [cookie]);
    }

    // JWTを取得してAuthorizationヘッダーに付与
    final jwt = await getSavedJwt();
    if (jwt != null && jwt.isNotEmpty) {
      req.headers.set("Authorization", ["Bearer $jwt"]);
    }

    req.headers.set("X-Device-ID", [deviceId]);

    try {
      final res = await next(req);

      // リクエスト完了時に経過時間を記録
      final elapsed = stopwatch.elapsedMilliseconds;
      print('API Request: $uri - ${elapsed}ms');

      // サーバーから Set-Cookie を受け取った場合、それを保存
      final setCookie = res.headers.get("set-cookie");
      if (setCookie != null && setCookie.isNotEmpty) {
        final newCookie = setCookie.first;
        await persistCookie(newCookie);
        print("Set-Cookie received and saved: $newCookie");
      }

      return res;
    } catch (e) {
      // エラー発生時も経過時間を記録
      final elapsed = stopwatch.elapsedMilliseconds;
      print('API Request: $uri - ERROR - ${elapsed}ms - $e');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  };
};

final transport = protocol.Transport(
  // baseUrl: "http://192.168.10.8:8080",
  baseUrl: "https://kimagure.langrics.com",
  codec: const ProtoCodec(),
  httpClient: createHttpClient(),
  interceptors: [deviceIdInterceptor],
);
