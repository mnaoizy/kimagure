//
//  Generated code. Do not modify.
//  source: proto/chinese/v1/chinese.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use uploadRecordingRequestDescriptor instead')
const UploadRecordingRequest$json = {
  '1': 'UploadRecordingRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'audio_data', '3': 2, '4': 1, '5': 12, '10': 'audioData'},
  ],
};

/// Descriptor for `UploadRecordingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadRecordingRequestDescriptor = $convert.base64Decode(
    'ChZVcGxvYWRSZWNvcmRpbmdSZXF1ZXN0EhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIdCgphdW'
    'Rpb19kYXRhGAIgASgMUglhdWRpb0RhdGE=');

@$core.Deprecated('Use uploadRecordingResponseDescriptor instead')
const UploadRecordingResponse$json = {
  '1': 'UploadRecordingResponse',
  '2': [
    {'1': 'size', '3': 1, '4': 1, '5': 3, '10': 'size'},
    {'1': 'pitches', '3': 2, '4': 3, '5': 2, '10': 'pitches'},
    {'1': 'feedback', '3': 3, '4': 1, '5': 9, '10': 'feedback'},
  ],
};

/// Descriptor for `UploadRecordingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadRecordingResponseDescriptor = $convert.base64Decode(
    'ChdVcGxvYWRSZWNvcmRpbmdSZXNwb25zZRISCgRzaXplGAEgASgDUgRzaXplEhgKB3BpdGNoZX'
    'MYAiADKAJSB3BpdGNoZXMSGgoIZmVlZGJhY2sYAyABKAlSCGZlZWRiYWNr');

@$core.Deprecated('Use getLessonsRequestDescriptor instead')
const GetLessonsRequest$json = {
  '1': 'GetLessonsRequest',
};

/// Descriptor for `GetLessonsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLessonsRequestDescriptor = $convert.base64Decode(
    'ChFHZXRMZXNzb25zUmVxdWVzdA==');

@$core.Deprecated('Use getLessonsResponseDescriptor instead')
const GetLessonsResponse$json = {
  '1': 'GetLessonsResponse',
  '2': [
    {'1': 'lessons', '3': 1, '4': 3, '5': 11, '6': '.chinese.v1.Lesson', '10': 'lessons'},
  ],
};

/// Descriptor for `GetLessonsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLessonsResponseDescriptor = $convert.base64Decode(
    'ChJHZXRMZXNzb25zUmVzcG9uc2USLAoHbGVzc29ucxgBIAMoCzISLmNoaW5lc2UudjEuTGVzc2'
    '9uUgdsZXNzb25z');

@$core.Deprecated('Use lessonDescriptor instead')
const Lesson$json = {
  '1': 'Lesson',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `Lesson`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lessonDescriptor = $convert.base64Decode(
    'CgZMZXNzb24SDgoCaWQYASABKAlSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIgCgtkZXNjcm'
    'lwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24=');

@$core.Deprecated('Use getChineseListRequestDescriptor instead')
const GetChineseListRequest$json = {
  '1': 'GetChineseListRequest',
  '2': [
    {'1': 'lesson_id', '3': 1, '4': 1, '5': 9, '10': 'lessonId'},
  ],
};

/// Descriptor for `GetChineseListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChineseListRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDaGluZXNlTGlzdFJlcXVlc3QSGwoJbGVzc29uX2lkGAEgASgJUghsZXNzb25JZA==');

@$core.Deprecated('Use getChineseListResponseDescriptor instead')
const GetChineseListResponse$json = {
  '1': 'GetChineseListResponse',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.chinese.v1.ChineseItem', '10': 'items'},
  ],
};

/// Descriptor for `GetChineseListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChineseListResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDaGluZXNlTGlzdFJlc3BvbnNlEi0KBWl0ZW1zGAEgAygLMhcuY2hpbmVzZS52MS5DaG'
    'luZXNlSXRlbVIFaXRlbXM=');

@$core.Deprecated('Use chineseItemDescriptor instead')
const ChineseItem$json = {
  '1': 'ChineseItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'character', '3': 2, '4': 1, '5': 9, '10': 'character'},
    {'1': 'pinyin', '3': 3, '4': 1, '5': 9, '10': 'pinyin'},
    {'1': 'meaning', '3': 4, '4': 1, '5': 9, '10': 'meaning'},
    {'1': 'lesson_id', '3': 5, '4': 1, '5': 9, '10': 'lessonId'},
    {'1': 'audio_url', '3': 6, '4': 1, '5': 9, '10': 'audioUrl'},
    {'1': 'pitch_data', '3': 7, '4': 3, '5': 2, '10': 'pitchData'},
  ],
};

/// Descriptor for `ChineseItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chineseItemDescriptor = $convert.base64Decode(
    'CgtDaGluZXNlSXRlbRIOCgJpZBgBIAEoCVICaWQSHAoJY2hhcmFjdGVyGAIgASgJUgljaGFyYW'
    'N0ZXISFgoGcGlueWluGAMgASgJUgZwaW55aW4SGAoHbWVhbmluZxgEIAEoCVIHbWVhbmluZxIb'
    'CglsZXNzb25faWQYBSABKAlSCGxlc3NvbklkEhsKCWF1ZGlvX3VybBgGIAEoCVIIYXVkaW9Vcm'
    'wSHQoKcGl0Y2hfZGF0YRgHIAMoAlIJcGl0Y2hEYXRh');

@$core.Deprecated('Use getFeedbackRequestDescriptor instead')
const GetFeedbackRequest$json = {
  '1': 'GetFeedbackRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `GetFeedbackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeedbackRequestDescriptor = $convert.base64Decode(
    'ChJHZXRGZWVkYmFja1JlcXVlc3QSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlk');

@$core.Deprecated('Use feedbackDescriptor instead')
const Feedback$json = {
  '1': 'Feedback',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `Feedback`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedbackDescriptor = $convert.base64Decode(
    'CghGZWVkYmFjaxISCgR0ZXh0GAEgASgJUgR0ZXh0Eh0KCmNyZWF0ZWRfYXQYAiABKAlSCWNyZW'
    'F0ZWRBdA==');

@$core.Deprecated('Use getFeedbacksResponseDescriptor instead')
const GetFeedbacksResponse$json = {
  '1': 'GetFeedbacksResponse',
  '2': [
    {'1': 'feedbacks', '3': 1, '4': 3, '5': 11, '6': '.chinese.v1.Feedback', '10': 'feedbacks'},
  ],
};

/// Descriptor for `GetFeedbacksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeedbacksResponseDescriptor = $convert.base64Decode(
    'ChRHZXRGZWVkYmFja3NSZXNwb25zZRIyCglmZWVkYmFja3MYASADKAsyFC5jaGluZXNlLnYxLk'
    'ZlZWRiYWNrUglmZWVkYmFja3M=');

const $core.Map<$core.String, $core.dynamic> ChineseServiceBase$json = {
  '1': 'ChineseService',
  '2': [
    {'1': 'GetLessons', '2': '.chinese.v1.GetLessonsRequest', '3': '.chinese.v1.GetLessonsResponse', '4': {}},
    {'1': 'GetChineseList', '2': '.chinese.v1.GetChineseListRequest', '3': '.chinese.v1.GetChineseListResponse', '4': {}},
    {'1': 'UploadRecording', '2': '.chinese.v1.UploadRecordingRequest', '3': '.chinese.v1.UploadRecordingResponse', '4': {}},
    {'1': 'GetFeedbacks', '2': '.chinese.v1.GetFeedbackRequest', '3': '.chinese.v1.GetFeedbacksResponse', '4': {}},
  ],
};

@$core.Deprecated('Use chineseServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ChineseServiceBase$messageJson = {
  '.chinese.v1.GetLessonsRequest': GetLessonsRequest$json,
  '.chinese.v1.GetLessonsResponse': GetLessonsResponse$json,
  '.chinese.v1.Lesson': Lesson$json,
  '.chinese.v1.GetChineseListRequest': GetChineseListRequest$json,
  '.chinese.v1.GetChineseListResponse': GetChineseListResponse$json,
  '.chinese.v1.ChineseItem': ChineseItem$json,
  '.chinese.v1.UploadRecordingRequest': UploadRecordingRequest$json,
  '.chinese.v1.UploadRecordingResponse': UploadRecordingResponse$json,
  '.chinese.v1.GetFeedbackRequest': GetFeedbackRequest$json,
  '.chinese.v1.GetFeedbacksResponse': GetFeedbacksResponse$json,
  '.chinese.v1.Feedback': Feedback$json,
};

/// Descriptor for `ChineseService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List chineseServiceDescriptor = $convert.base64Decode(
    'Cg5DaGluZXNlU2VydmljZRJNCgpHZXRMZXNzb25zEh0uY2hpbmVzZS52MS5HZXRMZXNzb25zUm'
    'VxdWVzdBoeLmNoaW5lc2UudjEuR2V0TGVzc29uc1Jlc3BvbnNlIgASWQoOR2V0Q2hpbmVzZUxp'
    'c3QSIS5jaGluZXNlLnYxLkdldENoaW5lc2VMaXN0UmVxdWVzdBoiLmNoaW5lc2UudjEuR2V0Q2'
    'hpbmVzZUxpc3RSZXNwb25zZSIAElwKD1VwbG9hZFJlY29yZGluZxIiLmNoaW5lc2UudjEuVXBs'
    'b2FkUmVjb3JkaW5nUmVxdWVzdBojLmNoaW5lc2UudjEuVXBsb2FkUmVjb3JkaW5nUmVzcG9uc2'
    'UiABJSCgxHZXRGZWVkYmFja3MSHi5jaGluZXNlLnYxLkdldEZlZWRiYWNrUmVxdWVzdBogLmNo'
    'aW5lc2UudjEuR2V0RmVlZGJhY2tzUmVzcG9uc2UiAA==');

