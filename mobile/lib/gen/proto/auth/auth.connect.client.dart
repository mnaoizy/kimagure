//
//  Generated code. Do not modify.
//  source: proto/auth/auth.proto
//

import "package:connectrpc/connect.dart" as connect;
import "auth.pb.dart" as protoauthauth;
import "auth.connect.spec.dart" as specs;

extension type AuthServiceClient (connect.Transport _transport) {
  Future<protoauthauth.AuthenticateAnonymouslyResponse> authenticateAnonymously(
    protoauthauth.AuthenticateAnonymouslyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.authenticateAnonymously,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
