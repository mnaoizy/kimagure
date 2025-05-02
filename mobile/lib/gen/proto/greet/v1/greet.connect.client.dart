//
//  Generated code. Do not modify.
//  source: proto/greet/v1/greet.proto
//

import "package:connectrpc/connect.dart" as connect;
import "greet.pb.dart" as protogreetv1greet;
import "greet.connect.spec.dart" as specs;

extension type GreetServiceClient (connect.Transport _transport) {
  Future<protogreetv1greet.GreetResponse> greet(
    protogreetv1greet.GreetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.GreetService.greet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
