//
//  Generated code. Do not modify.
//  source: proto/auth/auth.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use authenticateAnonymouslyRequestDescriptor instead')
const AuthenticateAnonymouslyRequest$json = {
  '1': 'AuthenticateAnonymouslyRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `AuthenticateAnonymouslyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authenticateAnonymouslyRequestDescriptor = $convert.base64Decode(
    'Ch5BdXRoZW50aWNhdGVBbm9ueW1vdXNseVJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZX'
    'ZpY2VJZA==');

@$core.Deprecated('Use authenticateAnonymouslyResponseDescriptor instead')
const AuthenticateAnonymouslyResponse$json = {
  '1': 'AuthenticateAnonymouslyResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `AuthenticateAnonymouslyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authenticateAnonymouslyResponseDescriptor = $convert.base64Decode(
    'Ch9BdXRoZW50aWNhdGVBbm9ueW1vdXNseVJlc3BvbnNlEhQKBXRva2VuGAEgASgJUgV0b2tlbh'
    'IXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQ=');

const $core.Map<$core.String, $core.dynamic> AuthServiceBase$json = {
  '1': 'AuthService',
  '2': [
    {'1': 'AuthenticateAnonymously', '2': '.auth.v1.AuthenticateAnonymouslyRequest', '3': '.auth.v1.AuthenticateAnonymouslyResponse'},
  ],
};

@$core.Deprecated('Use authServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> AuthServiceBase$messageJson = {
  '.auth.v1.AuthenticateAnonymouslyRequest': AuthenticateAnonymouslyRequest$json,
  '.auth.v1.AuthenticateAnonymouslyResponse': AuthenticateAnonymouslyResponse$json,
};

/// Descriptor for `AuthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List authServiceDescriptor = $convert.base64Decode(
    'CgtBdXRoU2VydmljZRJsChdBdXRoZW50aWNhdGVBbm9ueW1vdXNseRInLmF1dGgudjEuQXV0aG'
    'VudGljYXRlQW5vbnltb3VzbHlSZXF1ZXN0GiguYXV0aC52MS5BdXRoZW50aWNhdGVBbm9ueW1v'
    'dXNseVJlc3BvbnNl');

