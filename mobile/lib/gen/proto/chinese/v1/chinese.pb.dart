//
//  Generated code. Do not modify.
//  source: proto/chinese/v1/chinese.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class UploadRecordingRequest extends $pb.GeneratedMessage {
  factory UploadRecordingRequest({
    $core.String? itemId,
    $core.List<$core.int>? audioData,
  }) {
    final $result = create();
    if (itemId != null) {
      $result.itemId = itemId;
    }
    if (audioData != null) {
      $result.audioData = audioData;
    }
    return $result;
  }
  UploadRecordingRequest._() : super();
  factory UploadRecordingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadRecordingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadRecordingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'audioData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadRecordingRequest clone() => UploadRecordingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadRecordingRequest copyWith(void Function(UploadRecordingRequest) updates) => super.copyWith((message) => updates(message as UploadRecordingRequest)) as UploadRecordingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadRecordingRequest create() => UploadRecordingRequest._();
  UploadRecordingRequest createEmptyInstance() => create();
  static $pb.PbList<UploadRecordingRequest> createRepeated() => $pb.PbList<UploadRecordingRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadRecordingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadRecordingRequest>(create);
  static UploadRecordingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get audioData => $_getN(1);
  @$pb.TagNumber(2)
  set audioData($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAudioData() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudioData() => clearField(2);
}

class UploadRecordingResponse extends $pb.GeneratedMessage {
  factory UploadRecordingResponse({
    $fixnum.Int64? size,
    $core.Iterable<$core.double>? pitches,
    $core.String? feedback,
  }) {
    final $result = create();
    if (size != null) {
      $result.size = size;
    }
    if (pitches != null) {
      $result.pitches.addAll(pitches);
    }
    if (feedback != null) {
      $result.feedback = feedback;
    }
    return $result;
  }
  UploadRecordingResponse._() : super();
  factory UploadRecordingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadRecordingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadRecordingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'size')
    ..p<$core.double>(2, _omitFieldNames ? '' : 'pitches', $pb.PbFieldType.KF)
    ..aOS(3, _omitFieldNames ? '' : 'feedback')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadRecordingResponse clone() => UploadRecordingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadRecordingResponse copyWith(void Function(UploadRecordingResponse) updates) => super.copyWith((message) => updates(message as UploadRecordingResponse)) as UploadRecordingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadRecordingResponse create() => UploadRecordingResponse._();
  UploadRecordingResponse createEmptyInstance() => create();
  static $pb.PbList<UploadRecordingResponse> createRepeated() => $pb.PbList<UploadRecordingResponse>();
  @$core.pragma('dart2js:noInline')
  static UploadRecordingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadRecordingResponse>(create);
  static UploadRecordingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get size => $_getI64(0);
  @$pb.TagNumber(1)
  set size($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearSize() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.double> get pitches => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get feedback => $_getSZ(2);
  @$pb.TagNumber(3)
  set feedback($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFeedback() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeedback() => clearField(3);
}

class GetLessonsRequest extends $pb.GeneratedMessage {
  factory GetLessonsRequest() => create();
  GetLessonsRequest._() : super();
  factory GetLessonsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLessonsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetLessonsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLessonsRequest clone() => GetLessonsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLessonsRequest copyWith(void Function(GetLessonsRequest) updates) => super.copyWith((message) => updates(message as GetLessonsRequest)) as GetLessonsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLessonsRequest create() => GetLessonsRequest._();
  GetLessonsRequest createEmptyInstance() => create();
  static $pb.PbList<GetLessonsRequest> createRepeated() => $pb.PbList<GetLessonsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLessonsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLessonsRequest>(create);
  static GetLessonsRequest? _defaultInstance;
}

class GetLessonsResponse extends $pb.GeneratedMessage {
  factory GetLessonsResponse({
    $core.Iterable<Lesson>? lessons,
  }) {
    final $result = create();
    if (lessons != null) {
      $result.lessons.addAll(lessons);
    }
    return $result;
  }
  GetLessonsResponse._() : super();
  factory GetLessonsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLessonsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetLessonsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..pc<Lesson>(1, _omitFieldNames ? '' : 'lessons', $pb.PbFieldType.PM, subBuilder: Lesson.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLessonsResponse clone() => GetLessonsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLessonsResponse copyWith(void Function(GetLessonsResponse) updates) => super.copyWith((message) => updates(message as GetLessonsResponse)) as GetLessonsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLessonsResponse create() => GetLessonsResponse._();
  GetLessonsResponse createEmptyInstance() => create();
  static $pb.PbList<GetLessonsResponse> createRepeated() => $pb.PbList<GetLessonsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLessonsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLessonsResponse>(create);
  static GetLessonsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Lesson> get lessons => $_getList(0);
}

class Lesson extends $pb.GeneratedMessage {
  factory Lesson({
    $core.String? id,
    $core.String? title,
    $core.String? description,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (title != null) {
      $result.title = title;
    }
    if (description != null) {
      $result.description = description;
    }
    return $result;
  }
  Lesson._() : super();
  factory Lesson.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Lesson.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Lesson', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Lesson clone() => Lesson()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Lesson copyWith(void Function(Lesson) updates) => super.copyWith((message) => updates(message as Lesson)) as Lesson;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Lesson create() => Lesson._();
  Lesson createEmptyInstance() => create();
  static $pb.PbList<Lesson> createRepeated() => $pb.PbList<Lesson>();
  @$core.pragma('dart2js:noInline')
  static Lesson getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Lesson>(create);
  static Lesson? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => clearField(3);
}

class GetChineseListRequest extends $pb.GeneratedMessage {
  factory GetChineseListRequest({
    $core.String? lessonId,
  }) {
    final $result = create();
    if (lessonId != null) {
      $result.lessonId = lessonId;
    }
    return $result;
  }
  GetChineseListRequest._() : super();
  factory GetChineseListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetChineseListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetChineseListRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lessonId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetChineseListRequest clone() => GetChineseListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetChineseListRequest copyWith(void Function(GetChineseListRequest) updates) => super.copyWith((message) => updates(message as GetChineseListRequest)) as GetChineseListRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChineseListRequest create() => GetChineseListRequest._();
  GetChineseListRequest createEmptyInstance() => create();
  static $pb.PbList<GetChineseListRequest> createRepeated() => $pb.PbList<GetChineseListRequest>();
  @$core.pragma('dart2js:noInline')
  static GetChineseListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetChineseListRequest>(create);
  static GetChineseListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lessonId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lessonId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLessonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLessonId() => clearField(1);
}

class GetChineseListResponse extends $pb.GeneratedMessage {
  factory GetChineseListResponse({
    $core.Iterable<ChineseItem>? items,
  }) {
    final $result = create();
    if (items != null) {
      $result.items.addAll(items);
    }
    return $result;
  }
  GetChineseListResponse._() : super();
  factory GetChineseListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetChineseListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetChineseListResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..pc<ChineseItem>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: ChineseItem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetChineseListResponse clone() => GetChineseListResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetChineseListResponse copyWith(void Function(GetChineseListResponse) updates) => super.copyWith((message) => updates(message as GetChineseListResponse)) as GetChineseListResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChineseListResponse create() => GetChineseListResponse._();
  GetChineseListResponse createEmptyInstance() => create();
  static $pb.PbList<GetChineseListResponse> createRepeated() => $pb.PbList<GetChineseListResponse>();
  @$core.pragma('dart2js:noInline')
  static GetChineseListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetChineseListResponse>(create);
  static GetChineseListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ChineseItem> get items => $_getList(0);
}

class ChineseItem extends $pb.GeneratedMessage {
  factory ChineseItem({
    $core.String? id,
    $core.String? character,
    $core.String? pinyin,
    $core.String? meaning,
    $core.String? lessonId,
    $core.String? audioUrl,
    $core.Iterable<$core.double>? pitchData,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (character != null) {
      $result.character = character;
    }
    if (pinyin != null) {
      $result.pinyin = pinyin;
    }
    if (meaning != null) {
      $result.meaning = meaning;
    }
    if (lessonId != null) {
      $result.lessonId = lessonId;
    }
    if (audioUrl != null) {
      $result.audioUrl = audioUrl;
    }
    if (pitchData != null) {
      $result.pitchData.addAll(pitchData);
    }
    return $result;
  }
  ChineseItem._() : super();
  factory ChineseItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChineseItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChineseItem', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'character')
    ..aOS(3, _omitFieldNames ? '' : 'pinyin')
    ..aOS(4, _omitFieldNames ? '' : 'meaning')
    ..aOS(5, _omitFieldNames ? '' : 'lessonId')
    ..aOS(6, _omitFieldNames ? '' : 'audioUrl')
    ..p<$core.double>(7, _omitFieldNames ? '' : 'pitchData', $pb.PbFieldType.KF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChineseItem clone() => ChineseItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChineseItem copyWith(void Function(ChineseItem) updates) => super.copyWith((message) => updates(message as ChineseItem)) as ChineseItem;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChineseItem create() => ChineseItem._();
  ChineseItem createEmptyInstance() => create();
  static $pb.PbList<ChineseItem> createRepeated() => $pb.PbList<ChineseItem>();
  @$core.pragma('dart2js:noInline')
  static ChineseItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChineseItem>(create);
  static ChineseItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get character => $_getSZ(1);
  @$pb.TagNumber(2)
  set character($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCharacter() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacter() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get pinyin => $_getSZ(2);
  @$pb.TagNumber(3)
  set pinyin($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPinyin() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinyin() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get meaning => $_getSZ(3);
  @$pb.TagNumber(4)
  set meaning($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMeaning() => $_has(3);
  @$pb.TagNumber(4)
  void clearMeaning() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get lessonId => $_getSZ(4);
  @$pb.TagNumber(5)
  set lessonId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLessonId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLessonId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get audioUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set audioUrl($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAudioUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearAudioUrl() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.double> get pitchData => $_getList(6);
}

class GetFeedbackRequest extends $pb.GeneratedMessage {
  factory GetFeedbackRequest({
    $core.String? itemId,
  }) {
    final $result = create();
    if (itemId != null) {
      $result.itemId = itemId;
    }
    return $result;
  }
  GetFeedbackRequest._() : super();
  factory GetFeedbackRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFeedbackRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFeedbackRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFeedbackRequest clone() => GetFeedbackRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFeedbackRequest copyWith(void Function(GetFeedbackRequest) updates) => super.copyWith((message) => updates(message as GetFeedbackRequest)) as GetFeedbackRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFeedbackRequest create() => GetFeedbackRequest._();
  GetFeedbackRequest createEmptyInstance() => create();
  static $pb.PbList<GetFeedbackRequest> createRepeated() => $pb.PbList<GetFeedbackRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFeedbackRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFeedbackRequest>(create);
  static GetFeedbackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => clearField(1);
}

class Feedback extends $pb.GeneratedMessage {
  factory Feedback({
    $core.String? text,
    $core.String? createdAt,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  Feedback._() : super();
  factory Feedback.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Feedback.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Feedback', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Feedback clone() => Feedback()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Feedback copyWith(void Function(Feedback) updates) => super.copyWith((message) => updates(message as Feedback)) as Feedback;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Feedback create() => Feedback._();
  Feedback createEmptyInstance() => create();
  static $pb.PbList<Feedback> createRepeated() => $pb.PbList<Feedback>();
  @$core.pragma('dart2js:noInline')
  static Feedback getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Feedback>(create);
  static Feedback? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get createdAt => $_getSZ(1);
  @$pb.TagNumber(2)
  set createdAt($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);
}

class GetFeedbacksResponse extends $pb.GeneratedMessage {
  factory GetFeedbacksResponse({
    $core.Iterable<Feedback>? feedbacks,
  }) {
    final $result = create();
    if (feedbacks != null) {
      $result.feedbacks.addAll(feedbacks);
    }
    return $result;
  }
  GetFeedbacksResponse._() : super();
  factory GetFeedbacksResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFeedbacksResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFeedbacksResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'chinese.v1'), createEmptyInstance: create)
    ..pc<Feedback>(1, _omitFieldNames ? '' : 'feedbacks', $pb.PbFieldType.PM, subBuilder: Feedback.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFeedbacksResponse clone() => GetFeedbacksResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFeedbacksResponse copyWith(void Function(GetFeedbacksResponse) updates) => super.copyWith((message) => updates(message as GetFeedbacksResponse)) as GetFeedbacksResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFeedbacksResponse create() => GetFeedbacksResponse._();
  GetFeedbacksResponse createEmptyInstance() => create();
  static $pb.PbList<GetFeedbacksResponse> createRepeated() => $pb.PbList<GetFeedbacksResponse>();
  @$core.pragma('dart2js:noInline')
  static GetFeedbacksResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFeedbacksResponse>(create);
  static GetFeedbacksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Feedback> get feedbacks => $_getList(0);
}

class ChineseServiceApi {
  $pb.RpcClient _client;
  ChineseServiceApi(this._client);

  $async.Future<GetLessonsResponse> getLessons($pb.ClientContext? ctx, GetLessonsRequest request) =>
    _client.invoke<GetLessonsResponse>(ctx, 'ChineseService', 'GetLessons', request, GetLessonsResponse())
  ;
  $async.Future<GetChineseListResponse> getChineseList($pb.ClientContext? ctx, GetChineseListRequest request) =>
    _client.invoke<GetChineseListResponse>(ctx, 'ChineseService', 'GetChineseList', request, GetChineseListResponse())
  ;
  $async.Future<UploadRecordingResponse> uploadRecording($pb.ClientContext? ctx, UploadRecordingRequest request) =>
    _client.invoke<UploadRecordingResponse>(ctx, 'ChineseService', 'UploadRecording', request, UploadRecordingResponse())
  ;
  $async.Future<GetFeedbacksResponse> getFeedbacks($pb.ClientContext? ctx, GetFeedbackRequest request) =>
    _client.invoke<GetFeedbacksResponse>(ctx, 'ChineseService', 'GetFeedbacks', request, GetFeedbacksResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
