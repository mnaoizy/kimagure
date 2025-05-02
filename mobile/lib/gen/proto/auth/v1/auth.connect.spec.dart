//
//  Generated code. Do not modify.
//  source: proto/auth/v1/auth.proto
//

import "package:connectrpc/connect.dart" as connect;
import "auth.pb.dart" as protoauthv1auth;

abstract final class AuthService {
  /// Fully-qualified name of the AuthService service.
  static const name = 'auth.v1.AuthService';

  static const authenticateAnonymously = connect.Spec(
    '/$name/AuthenticateAnonymously',
    connect.StreamType.unary,
    protoauthv1auth.AuthenticateAnonymouslyRequest.new,
    protoauthv1auth.AuthenticateAnonymouslyResponse.new,
  );
}
