import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:demo_nfc/controller/controller_success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// final client = MqttServerClient('hairdresser.cloudmqtt.com', '35489');

String broker = 'hairdresser.cloudmqtt.com';
int port = 35489;
String clientId = 'flutter_client1263';
String username = 'bdihabyp';
String password = 'zFv3EzhKhjme';
const deviceID = 'AVA-B81FB608'; // Replace with the actual device ID
const String pingTopic = '/PING/$deviceID';
const responseTopic = '/RESPONSE/$deviceID';

final client = MqttServerClient.withPort('wss://$broker', clientId, port);

Future<int> connect() async {
  // client = MqttServerClient.withPort('$wsScheme$broker', clientId, port);
  client.logging(on: true);
  client.useWebSocket = true; // Enable WebSocket
  client.keepAlivePeriod = 60; // Set the keep-alive period
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  // client.onSubscribed = onSubscribed;
  // client.onUnsubscribed = onUnsubscribed;
  // client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .withClientIdentifier(clientId)
      .authenticateAs(username, password)
      .startClean()
      .withWillQos(MqttQos.atMostOnce);

  client.connectionMessage = connMessage;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    log('Client exception - $e');
    client.disconnect();
    return 1; // Ensure to return an error code or handle as needed
  } on SocketException catch (e) {
    log('Socket exception - $e');
    client.disconnect();
    return 1; // Ensure to return an error code or handle as needed
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    log('Client connected');
    subscribeToTopics();
    log('PING....');
    sendPing();
    return 0;
  } else {
    log('Client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    return 1;
  }

  // client.logging(on: true);
  // client.keepAlivePeriod = 60;
  // client.onDisconnected = onDisconnected;
  // client.onConnected = onConnected;
  // client.pongCallback = pong;
  // client.setProtocolV311();

  // final connMess = MqttConnectMessage()
  //     .withClientIdentifier('dart_client')
  //     .withWillTopic('willtopic')
  //     .withWillMessage('My Will message')
  //     .startClean()
  //     .withWillQos(MqttQos.atLeastOnce)
  //     .authenticateAs(
  //         'bdihabyp', 'zFv3EzhKhjme'); // Add your username and password here
  // log('Client connecting....');
  // client.connectionMessage = connMess;

  // try {
  //   await client.connect();
  // } on NoConnectionException catch (e) {
  //   log('Client exception - $e');
  //   client.disconnect();
  //   return 1; // Ensure to return an error code or handle as needed
  // } on SocketException catch (e) {
  //   log('Socket exception - $e');
  //   client.disconnect();
  //   return 1; // Ensure to return an error code or handle as needed
  // }

  // if (client.connectionStatus!.state == MqttConnectionState.connected) {
  //   log('Client connected');
  //   subscribeToTopics();
  //   return 0;
  // } else {
  //   log(
  //       'Client connection failed - disconnecting, status is ${client.connectionStatus}');
  //   client.disconnect();
  //   return 1;
  // }
}

void subscribeToTopics() {
  // Define the subscription status callback
  client.onSubscribed = (String topic) {
    log('Subscribed to $topic');
  };

  client.onSubscribeFail = (String topic) {
    log('Failed to subscribe to $topic');
  };

  // Subscribe to topics
  client.subscribe(pingTopic, MqttQos.atLeastOnce);
  client.subscribe(responseTopic, MqttQos.atLeastOnce);

  // Listen for incoming messages
  client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    log('Received message: $message from topic: ${c[0].topic}');

    if (c[0].topic == pingTopic) {
      log('Ping received from device');
      client.publishMessage(responseTopic, MqttQos.atLeastOnce,
          MqttClientPayloadBuilder().addString('connected').payload!);
    } else if (c[0].topic == responseTopic) {
      log('Response received: $message');
    }
  });
}

// void subscribeToTopics() {
//   final deviceID = 'AVA-B81FB608'; // Replace with the actual device ID
//   final pingTopic = '/PING/$deviceID';
//   final responseTopic = '/RESPONSE/$deviceID';

//   client.subscribe(pingTopic, MqttQos.atLeastOnce);
//   client.subscribe(responseTopic, MqttQos.atLeastOnce);

//   client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//     final recMess = c![0].payload as MqttPublishMessage;
//     final message =
//         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

//     log('Received message: $message from topic: ${c[0].topic}');

//     if (c[0].topic == pingTopic) {
//       log('Ping received from device');
//       client.publishMessage(responseTopic, MqttQos.atLeastOnce,
//           MqttClientPayloadBuilder().addString('connected').payload!);
//     } else if (c[0].topic == responseTopic) {
//       log('Response received: $message');
//     }
//   });
// }

void onDisconnected() {
  log('OnDisconnected client callback - Client disconnection');
  Rx<bool> loadingValue = Get.find<SuccessController>().isLoading;

  if (loadingValue.isTrue) {
    if (Get.isDialogOpen == false) {
      log('test dialog');
      // disconnectDialog();
    }
  }

  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    log('OnDisconnected callback is solicited, this is correct');
  } else {
    log('OnDisconnected callback is unsolicited or unexpected');
    // Attempt to reconnect after a delay
    Future.delayed(Duration(seconds: 5), () {
      connectToMqtt();
    });
  }
}

void onConnected() {
  log('OnConnected client callback - Client connection was successful');
  subscribeToTopics();
}

void pong() {
  log('Ping response client callback invoked');
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
  log('Client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    log('Client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    log('Socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    log('Client connected');
    subscribeToTopics();
  } else {
    log('Client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
  }
}

void sendPing() {
  final builder = MqttClientPayloadBuilder();
  builder.addString('ping');
  client.publishMessage(pingTopic, MqttQos.atMostOnce, builder.payload!);
  log('Ping message sent to topic $pingTopic');

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final MqttPublishMessage message = c![0].payload as MqttPublishMessage;
    final String payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    if (c[0].topic == responseTopic) {
      log('Pong response received from topic $responseTopic: $payload');
    }
  });
}

void disconnectDialog() {
  Get.dialog(
    AlertDialog(
      title: const Text('FAILED'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('client connection failed'),
            Text('disconnecting'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
