//
//  Generated code. Do not modify.
//  source: proto/auth/auth.proto
//

import "package:connectrpc/connect.dart" as connect;
import "auth.pb.dart" as protoauthauth;

abstract final class AuthService {
  /// Fully-qualified name of the AuthService service.
  static const name = 'auth.v1.AuthService';

  static const authenticateAnonymously = connect.Spec(
    '/$name/AuthenticateAnonymously',
    connect.StreamType.unary,
    protoauthauth.AuthenticateAnonymouslyRequest.new,
    protoauthauth.AuthenticateAnonymouslyResponse.new,
  );
}
