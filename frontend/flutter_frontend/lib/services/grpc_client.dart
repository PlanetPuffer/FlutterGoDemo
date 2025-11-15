import 'package:grpc/grpc.dart';

String backendHost() {
  return 'localhost';
}

ClientChannel createChannel() {
  return ClientChannel(
    backendHost(),
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
}