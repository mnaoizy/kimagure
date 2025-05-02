//
//  Generated code. Do not modify.
//  source: proto/chinese/v1/chinese.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'chinese.pb.dart' as $1;
import 'chinese.pbjson.dart';

export 'chinese.pb.dart';

abstract class ChineseServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GetLessonsResponse> getLessons($pb.ServerContext ctx, $1.GetLessonsRequest request);
  $async.Future<$1.GetChineseListResponse> getChineseList($pb.ServerContext ctx, $1.GetChineseListRequest request);
  $async.Future<$1.UploadRecordingResponse> uploadRecording($pb.ServerContext ctx, $1.UploadRecordingRequest request);
  $async.Future<$1.GetFeedbacksResponse> getFeedbacks($pb.ServerContext ctx, $1.GetFeedbackRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetLessons': return $1.GetLessonsRequest();
      case 'GetChineseList': return $1.GetChineseListRequest();
      case 'UploadRecording': return $1.UploadRecordingRequest();
      case 'GetFeedbacks': return $1.GetFeedbackRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetLessons': return this.getLessons(ctx, request as $1.GetLessonsRequest);
      case 'GetChineseList': return this.getChineseList(ctx, request as $1.GetChineseListRequest);
      case 'UploadRecording': return this.uploadRecording(ctx, request as $1.UploadRecordingRequest);
      case 'GetFeedbacks': return this.getFeedbacks(ctx, request as $1.GetFeedbackRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ChineseServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ChineseServiceBase$messageJson;
}

