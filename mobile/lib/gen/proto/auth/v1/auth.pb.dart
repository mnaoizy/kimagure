//
//  Generated code. Do not modify.
//  source: proto/auth/v1/auth.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AuthenticateAnonymouslyRequest extends $pb.GeneratedMessage {
  factory AuthenticateAnonymouslyRequest({
    $core.String? deviceId,
  }) {
    final $result = create();
    if (deviceId != null) {
      $result.deviceId = deviceId;
    }
    return $result;
  }
  AuthenticateAnonymouslyRequest._() : super();
  factory AuthenticateAnonymouslyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthenticateAnonymouslyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthenticateAnonymouslyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'auth.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthenticateAnonymouslyRequest clone() => AuthenticateAnonymouslyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthenticateAnonymouslyRequest copyWith(void Function(AuthenticateAnonymouslyRequest) updates) => super.copyWith((message) => updates(message as AuthenticateAnonymouslyRequest)) as AuthenticateAnonymouslyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthenticateAnonymouslyRequest create() => AuthenticateAnonymouslyRequest._();
  AuthenticateAnonymouslyRequest createEmptyInstance() => create();
  static $pb.PbList<AuthenticateAnonymouslyRequest> createRepeated() => $pb.PbList<AuthenticateAnonymouslyRequest>();
  @$core.pragma('dart2js:noInline')
  static AuthenticateAnonymouslyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthenticateAnonymouslyRequest>(create);
  static AuthenticateAnonymouslyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class AuthenticateAnonymouslyResponse extends $pb.GeneratedMessage {
  factory AuthenticateAnonymouslyResponse({
    $core.String? token,
    $core.String? userId,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (userId != null) {
      $result.userId = userId;
    }
    return $result;
  }
  AuthenticateAnonymouslyResponse._() : super();
  factory AuthenticateAnonymouslyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthenticateAnonymouslyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthenticateAnonymouslyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'auth.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthenticateAnonymouslyResponse clone() => AuthenticateAnonymouslyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthenticateAnonymouslyResponse copyWith(void Function(AuthenticateAnonymouslyResponse) updates) => super.copyWith((message) => updates(message as AuthenticateAnonymouslyResponse)) as AuthenticateAnonymouslyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthenticateAnonymouslyResponse create() => AuthenticateAnonymouslyResponse._();
  AuthenticateAnonymouslyResponse createEmptyInstance() => create();
  static $pb.PbList<AuthenticateAnonymouslyResponse> createRepeated() => $pb.PbList<AuthenticateAnonymouslyResponse>();
  @$core.pragma('dart2js:noInline')
  static AuthenticateAnonymouslyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthenticateAnonymouslyResponse>(create);
  static AuthenticateAnonymouslyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class AuthServiceApi {
  $pb.RpcClient _client;
  AuthServiceApi(this._client);

  $async.Future<AuthenticateAnonymouslyResponse> authenticateAnonymously($pb.ClientContext? ctx, AuthenticateAnonymouslyRequest request) =>
    _client.invoke<AuthenticateAnonymouslyResponse>(ctx, 'AuthService', 'AuthenticateAnonymously', request, AuthenticateAnonymouslyResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
