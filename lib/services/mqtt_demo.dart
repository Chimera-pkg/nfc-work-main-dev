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
const deviceID = 'AVA-B81FB608';
// const deviceID = 'ABC-B81FB608';
const String pingTopic = '/PING/$deviceID';
const responseTopic = '/RESPONSE/$deviceID';
bool deviceCheck = false;

final client = MqttServerClient.withPort('wss://$broker', clientId, port);

Future<int> connect() async {
  // deviceCheck = false;
  client.logging(on: true);
  client.useWebSocket = true;
  client.keepAlivePeriod = 60;
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
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
    return 0;
  } on SocketException catch (e) {
    log('Socket exception - $e');
    client.disconnect();
    return 0;
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    log('Client connected');
    // await subscribeToTopics();
    log('PING....');
    await sendPing();
    log(deviceCheck.toString());
    if (deviceCheck == true) {
      log("message 1");
      return 1;
    } else {
      return 0;
    }
  } else {
    log('Client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    return 0;
  }
}

Future<int> subscribeToTopics() async {
  int status = 0;
  client.onSubscribed = (String topic) {
    log('Subscribed to $topic');
  };

  client.onSubscribeFail = (String topic) {
    log('Failed to subscribe to $topic');
  };

  client.subscribe(pingTopic, MqttQos.atLeastOnce);
  client.subscribe(responseTopic, MqttQos.atLeastOnce);

  client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    log('Received message: $message from topic: ${c[0].topic}');

    if (c[0].topic == pingTopic) {
      log('Ping received from device');
      client.publishMessage(responseTopic, MqttQos.atLeastOnce,
          MqttClientPayloadBuilder().addString('connected').payload!);
      status = 1;
    } else if (c[0].topic == responseTopic) {
      log('Response received: $message');
    }
  });
  return status;
}

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

Future<void> sendPing() async {
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
      if (payload == "Data Kekirim Pada Flutter") {
        deviceCheck = true;
      }
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
