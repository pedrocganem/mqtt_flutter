import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Broker {
  static final Broker _singleton = Broker._internal();

  factory Broker() {
    return _singleton;
  }

  Broker._internal();

  //Define class variables:

  String broker = 'dev-mqtt.favotecnologia.com.br';
  int port = 1883;
  String username = 'super1';
  String password = 'super1';
  String clientIdentifier = 'mqtt-test';
  MqttServerClient client;
  StreamSubscription subscription;

  Future<MqttServerClient> brokerSetup(Function function) async {
    client = MqttServerClient.withPort(broker, clientIdentifier, port);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.secure = false;

    final connMessage = MqttConnectMessage()
        .authenticateAs(username, password)
        .keepAliveFor(60)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .withClientIdentifier(clientIdentifier);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
      client.subscribe("vice/1339/sensors", MqttQos.atLeastOnce);
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    subscription = client.updates.listen(function);

    return client;
  }
}

void onConnected() {
  print('connected');
}

void onDisconnected() {
  print('disconnected');
}

void onSubscribed(String topic) {
  print('subscribed to $topic');
}

void onSubscribeFail(String topic) {
  print('failed to subscribe to $topic');
}

void on() {
  print('disconnected');
}

void pong() {
  print('ping response arrived');
}
