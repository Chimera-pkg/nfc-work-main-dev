import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('hairdresser.cloudmqtt.com', '35489');

Future<int> main() async {
  client.logging(on: true);
  client.keepAlivePeriod = 60;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.pongCallback = pong;
  client.setProtocolV311();

  final connMess = MqttConnectMessage()
      .withClientIdentifier('dart_client')
      .withWillTopic('willtopic')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce)
      .authenticateAs(
          'bdihabyp', 'zFv3EzhKhjme'); // Add your username and password here
  print('Client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('Client exception - $e');
    client.disconnect();
    return 1; // Ensure to return an error code or handle as needed
  } on SocketException catch (e) {
    print('Socket exception - $e');
    client.disconnect();
    return 1; // Ensure to return an error code or handle as needed
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Client connected');
    subscribeToTopics();
    return 0;
  } else {
    print(
        'Client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    return 1;
  }
}

void subscribeToTopics() {
  final deviceID = 'AVA-B81FB608'; // Replace with the actual device ID
  final pingTopic = '/PING/$deviceID';
  final responseTopic = '/RESPONSE/$deviceID';

  client.subscribe(pingTopic, MqttQos.atLeastOnce);
  client.subscribe(responseTopic, MqttQos.atLeastOnce);

  client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('Received message: $message from topic: ${c[0].topic}');

    if (c[0].topic == pingTopic) {
      print('Ping received from device');
      client.publishMessage(responseTopic, MqttQos.atLeastOnce,
          MqttClientPayloadBuilder().addString('connected').payload!);
    } else if (c[0].topic == responseTopic) {
      print('Response received: $message');
    }
  });
}

void onDisconnected() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  } else {
    print('OnDisconnected callback is unsolicited or unexpected');
    // Attempt to reconnect after a delay
    Future.delayed(Duration(seconds: 5), () {
      connectToMqtt();
    });
  }
}

void onConnected() {
  print('OnConnected client callback - Client connection was successful');
  subscribeToTopics();
}

void pong() {
  print('Ping response client callback invoked');
}

Future<void> connectToMqtt() async {
  final connMess = MqttConnectMessage()
      .withClientIdentifier('dart_client')
      .withWillTopic('willtopic')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce)
      .authenticateAs(
          'bdihabyp', 'zFv3EzhKhjme'); // Add your username and password here
  print('Client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('Client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('Socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Client connected');
    subscribeToTopics();
  } else {
    print(
        'Client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
  }
}
