import 'package:flutter/material.dart';
import 'package:mobile/gen/proto/auth/v1/auth.connect.client.dart';
import 'package:mobile/gen/proto/auth/v1/auth.pbserver.dart';
import '../gen/proto/chinese/v1/chinese.pb.dart';
import '../api/transport.dart';
import '../api/device_id.dart';

class AuthModel extends ChangeNotifier {
  final AuthServiceClient _authClient = AuthServiceClient(transport);
  String? userId;
  List<Lesson> lessons = [];
  bool isLoading = false;
  String? error;

  Future<void> authenticateAnonymously() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final deviceId = await getDeviceId();
      final response = await _authClient.authenticateAnonymously(
        AuthenticateAnonymouslyRequest(deviceId: deviceId),
      );
      userId = response.userId;
      if (response.token.isNotEmpty) {
        await persistJwt(response.token);
      }
      notifyListeners();
    } catch (e) {
      error = 'ログインに失敗しました';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
