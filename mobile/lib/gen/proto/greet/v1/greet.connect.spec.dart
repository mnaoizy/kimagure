//
//  Generated code. Do not modify.
//  source: proto/greet/v1/greet.proto
//

import "package:connectrpc/connect.dart" as connect;
import "greet.pb.dart" as protogreetv1greet;

abstract final class GreetService {
  /// Fully-qualified name of the GreetService service.
  static const name = 'greet.v1.GreetService';

  static const greet = connect.Spec(
    '/$name/Greet',
    connect.StreamType.unary,
    protogreetv1greet.GreetRequest.new,
    protogreetv1greet.GreetResponse.new,
  );
}
