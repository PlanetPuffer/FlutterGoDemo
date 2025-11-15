// This is a generated file - do not edit.
//
// Generated from user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgAS'
    'gJUghwYXNzd29yZA==');

@$core.Deprecated('Use registerResponseDescriptor instead')
const RegisterResponse$json = {
  '1': 'RegisterResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEg4KAmlkGAEgASgEUgJpZBIUCgVlbWFpbBgCIAEoCVIFZW1haW'
    'w=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEg4KAmlkGAEgASgEUgJpZBIUCgVlbWFpbBgCIAEoCVIFZW1haWwSFA'
    'oFdG9rZW4YAyABKAlSBXRva2Vu');

@$core.Deprecated('Use getUserRequestDescriptor instead')
const GetUserRequest$json = {
  '1': 'GetUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor =
    $convert.base64Decode('Cg5HZXRVc2VyUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQ=');

@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = {
  '1': 'GetUserResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2VyUmVzcG9uc2USDgoCaWQYASABKARSAmlkEhQKBWVtYWlsGAIgASgJUgVlbWFpbA'
    '==');

@$core.Deprecated('Use workoutLogMessageDescriptor instead')
const WorkoutLogMessage$json = {
  '1': 'WorkoutLogMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {'1': 'created_at_unix', '3': 4, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'updated_at_unix', '3': 5, '4': 1, '5': 3, '10': 'updatedAtUnix'},
  ],
};

/// Descriptor for `WorkoutLogMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutLogMessageDescriptor = $convert.base64Decode(
    'ChFXb3Jrb3V0TG9nTWVzc2FnZRIOCgJpZBgBIAEoBFICaWQSFwoHdXNlcl9pZBgCIAEoBFIGdX'
    'NlcklkEhgKB2NvbnRlbnQYAyABKAlSB2NvbnRlbnQSJgoPY3JlYXRlZF9hdF91bml4GAQgASgD'
    'Ug1jcmVhdGVkQXRVbml4EiYKD3VwZGF0ZWRfYXRfdW5peBgFIAEoA1INdXBkYXRlZEF0VW5peA'
    '==');

@$core.Deprecated('Use listWorkoutLogsRequestDescriptor instead')
const ListWorkoutLogsRequest$json = {
  '1': 'ListWorkoutLogsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
  ],
};

/// Descriptor for `ListWorkoutLogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkoutLogsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0V29ya291dExvZ3NSZXF1ZXN0EhcKB3VzZXJfaWQYASABKARSBnVzZXJJZA==');

@$core.Deprecated('Use listWorkoutLogsResponseDescriptor instead')
const ListWorkoutLogsResponse$json = {
  '1': 'ListWorkoutLogsResponse',
  '2': [
    {
      '1': 'logs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.user.WorkoutLogMessage',
      '10': 'logs'
    },
  ],
};

/// Descriptor for `ListWorkoutLogsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkoutLogsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0V29ya291dExvZ3NSZXNwb25zZRIrCgRsb2dzGAEgAygLMhcudXNlci5Xb3Jrb3V0TG'
        '9nTWVzc2FnZVIEbG9ncw==');

@$core.Deprecated('Use createWorkoutLogRequestDescriptor instead')
const CreateWorkoutLogRequest$json = {
  '1': 'CreateWorkoutLogRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `CreateWorkoutLogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWorkoutLogRequestDescriptor =
    $convert.base64Decode(
        'ChdDcmVhdGVXb3Jrb3V0TG9nUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgEUgZ1c2VySWQSGAoHY2'
        '9udGVudBgCIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use createWorkoutLogResponseDescriptor instead')
const CreateWorkoutLogResponse$json = {
  '1': 'CreateWorkoutLogResponse',
  '2': [
    {
      '1': 'log',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.user.WorkoutLogMessage',
      '10': 'log'
    },
  ],
};

/// Descriptor for `CreateWorkoutLogResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWorkoutLogResponseDescriptor =
    $convert.base64Decode(
        'ChhDcmVhdGVXb3Jrb3V0TG9nUmVzcG9uc2USKQoDbG9nGAEgASgLMhcudXNlci5Xb3Jrb3V0TG'
        '9nTWVzc2FnZVIDbG9n');

@$core.Deprecated('Use updateWorkoutLogRequestDescriptor instead')
const UpdateWorkoutLogRequest$json = {
  '1': 'UpdateWorkoutLogRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `UpdateWorkoutLogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateWorkoutLogRequestDescriptor =
    $convert.base64Decode(
        'ChdVcGRhdGVXb3Jrb3V0TG9nUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQSFwoHdXNlcl9pZBgCIA'
        'EoBFIGdXNlcklkEhgKB2NvbnRlbnQYAyABKAlSB2NvbnRlbnQ=');

@$core.Deprecated('Use updateWorkoutLogResponseDescriptor instead')
const UpdateWorkoutLogResponse$json = {
  '1': 'UpdateWorkoutLogResponse',
  '2': [
    {
      '1': 'log',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.user.WorkoutLogMessage',
      '10': 'log'
    },
  ],
};

/// Descriptor for `UpdateWorkoutLogResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateWorkoutLogResponseDescriptor =
    $convert.base64Decode(
        'ChhVcGRhdGVXb3Jrb3V0TG9nUmVzcG9uc2USKQoDbG9nGAEgASgLMhcudXNlci5Xb3Jrb3V0TG'
        '9nTWVzc2FnZVIDbG9n');

@$core.Deprecated('Use deleteWorkoutLogRequestDescriptor instead')
const DeleteWorkoutLogRequest$json = {
  '1': 'DeleteWorkoutLogRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
  ],
};

/// Descriptor for `DeleteWorkoutLogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWorkoutLogRequestDescriptor =
    $convert.base64Decode(
        'ChdEZWxldGVXb3Jrb3V0TG9nUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQSFwoHdXNlcl9pZBgCIA'
        'EoBFIGdXNlcklk');

@$core.Deprecated('Use deleteWorkoutLogResponseDescriptor instead')
const DeleteWorkoutLogResponse$json = {
  '1': 'DeleteWorkoutLogResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteWorkoutLogResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWorkoutLogResponseDescriptor =
    $convert.base64Decode(
        'ChhEZWxldGVXb3Jrb3V0TG9nUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');
