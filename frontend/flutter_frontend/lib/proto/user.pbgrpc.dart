// This is a generated file - do not edit.
//
// Generated from user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $0;

export 'user.pb.dart';

@$pb.GrpcServiceName('user.UserService')
class UserServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  UserServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RegisterResponse> register(
    $0.RegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> login(
    $0.LoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserResponse> getUser(
    $0.GetUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateWorkoutLogResponse> createWorkoutLog(
    $0.CreateWorkoutLogRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createWorkoutLog, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListWorkoutLogsResponse> listWorkoutLogs(
    $0.ListWorkoutLogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listWorkoutLogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateWorkoutLogResponse> updateWorkoutLog(
    $0.UpdateWorkoutLogRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateWorkoutLog, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteWorkoutLogResponse> deleteWorkoutLog(
    $0.DeleteWorkoutLogRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteWorkoutLog, request, options: options);
  }

  // method descriptors

  static final _$register =
      $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterResponse>(
          '/user.UserService/Register',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          $0.RegisterResponse.fromBuffer);
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/user.UserService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      $0.LoginResponse.fromBuffer);
  static final _$getUser =
      $grpc.ClientMethod<$0.GetUserRequest, $0.GetUserResponse>(
          '/user.UserService/GetUser',
          ($0.GetUserRequest value) => value.writeToBuffer(),
          $0.GetUserResponse.fromBuffer);
  static final _$createWorkoutLog = $grpc.ClientMethod<
          $0.CreateWorkoutLogRequest, $0.CreateWorkoutLogResponse>(
      '/user.UserService/CreateWorkoutLog',
      ($0.CreateWorkoutLogRequest value) => value.writeToBuffer(),
      $0.CreateWorkoutLogResponse.fromBuffer);
  static final _$listWorkoutLogs =
      $grpc.ClientMethod<$0.ListWorkoutLogsRequest, $0.ListWorkoutLogsResponse>(
          '/user.UserService/ListWorkoutLogs',
          ($0.ListWorkoutLogsRequest value) => value.writeToBuffer(),
          $0.ListWorkoutLogsResponse.fromBuffer);
  static final _$updateWorkoutLog = $grpc.ClientMethod<
          $0.UpdateWorkoutLogRequest, $0.UpdateWorkoutLogResponse>(
      '/user.UserService/UpdateWorkoutLog',
      ($0.UpdateWorkoutLogRequest value) => value.writeToBuffer(),
      $0.UpdateWorkoutLogResponse.fromBuffer);
  static final _$deleteWorkoutLog = $grpc.ClientMethod<
          $0.DeleteWorkoutLogRequest, $0.DeleteWorkoutLogResponse>(
      '/user.UserService/DeleteWorkoutLog',
      ($0.DeleteWorkoutLogRequest value) => value.writeToBuffer(),
      $0.DeleteWorkoutLogResponse.fromBuffer);
}

@$pb.GrpcServiceName('user.UserService')
abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'user.UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserRequest, $0.GetUserResponse>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetUserRequest.fromBuffer(value),
        ($0.GetUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateWorkoutLogRequest,
            $0.CreateWorkoutLogResponse>(
        'CreateWorkoutLog',
        createWorkoutLog_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateWorkoutLogRequest.fromBuffer(value),
        ($0.CreateWorkoutLogResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListWorkoutLogsRequest,
            $0.ListWorkoutLogsResponse>(
        'ListWorkoutLogs',
        listWorkoutLogs_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListWorkoutLogsRequest.fromBuffer(value),
        ($0.ListWorkoutLogsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateWorkoutLogRequest,
            $0.UpdateWorkoutLogResponse>(
        'UpdateWorkoutLog',
        updateWorkoutLog_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateWorkoutLogRequest.fromBuffer(value),
        ($0.UpdateWorkoutLogResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteWorkoutLogRequest,
            $0.DeleteWorkoutLogResponse>(
        'DeleteWorkoutLog',
        deleteWorkoutLog_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteWorkoutLogRequest.fromBuffer(value),
        ($0.DeleteWorkoutLogResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterResponse> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.RegisterResponse> register(
      $grpc.ServiceCall call, $0.RegisterRequest request);

  $async.Future<$0.LoginResponse> login_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return login($call, await $request);
  }

  $async.Future<$0.LoginResponse> login(
      $grpc.ServiceCall call, $0.LoginRequest request);

  $async.Future<$0.GetUserResponse> getUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetUserRequest> $request) async {
    return getUser($call, await $request);
  }

  $async.Future<$0.GetUserResponse> getUser(
      $grpc.ServiceCall call, $0.GetUserRequest request);

  $async.Future<$0.CreateWorkoutLogResponse> createWorkoutLog_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateWorkoutLogRequest> $request) async {
    return createWorkoutLog($call, await $request);
  }

  $async.Future<$0.CreateWorkoutLogResponse> createWorkoutLog(
      $grpc.ServiceCall call, $0.CreateWorkoutLogRequest request);

  $async.Future<$0.ListWorkoutLogsResponse> listWorkoutLogs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListWorkoutLogsRequest> $request) async {
    return listWorkoutLogs($call, await $request);
  }

  $async.Future<$0.ListWorkoutLogsResponse> listWorkoutLogs(
      $grpc.ServiceCall call, $0.ListWorkoutLogsRequest request);

  $async.Future<$0.UpdateWorkoutLogResponse> updateWorkoutLog_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateWorkoutLogRequest> $request) async {
    return updateWorkoutLog($call, await $request);
  }

  $async.Future<$0.UpdateWorkoutLogResponse> updateWorkoutLog(
      $grpc.ServiceCall call, $0.UpdateWorkoutLogRequest request);

  $async.Future<$0.DeleteWorkoutLogResponse> deleteWorkoutLog_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteWorkoutLogRequest> $request) async {
    return deleteWorkoutLog($call, await $request);
  }

  $async.Future<$0.DeleteWorkoutLogResponse> deleteWorkoutLog(
      $grpc.ServiceCall call, $0.DeleteWorkoutLogRequest request);
}
