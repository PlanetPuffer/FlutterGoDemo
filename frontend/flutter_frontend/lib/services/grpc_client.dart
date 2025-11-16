import 'package:grpc/grpc.dart';

String backendHost() {
    return '34.212.62.125';
    // return 'localhost'; //switching to localhost for testing with local server, change back for deployment

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