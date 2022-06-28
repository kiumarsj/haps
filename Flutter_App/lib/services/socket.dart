import 'dart:io';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';

class MySocket {
  final connection = HubConnectionBuilder()
      .withUrl(
          'https://api.iot.davoodhoseini.ir/gadgets',
          HttpConnectionOptions(
            client: IOClient(
                HttpClient()..badCertificateCallback = (x, y, z) => true),
            logging: (level, message) => print(message),
          ))
      .build();
}
