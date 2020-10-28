import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_flutter/mqtt.dart';

void main() {
  runApp(MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String messageFromBroker = 'Idle';
  bool isConnected;
  String connectButtonTitle = 'Connect';
  String disconnectButtonTitle = 'Disconnect';

  void onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>');
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: $message");

    if (message != null) {
      connectButtonTitle = 'connected';
    }
    setState(() {
      messageFromBroker = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text('Using MQTT with flutter!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 200,
                child: Text(
                  messageFromBroker,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 40,
            ),
            FlatButton(
                color: Colors.green,
                onPressed: () {
                  Broker().brokerSetup(onMessage);
                  setState(() {
                    connectButtonTitle = 'connecting';
                    messageFromBroker = 'Waiting for messages...';
                  });
                },
                child: Text(connectButtonTitle)),
            FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Broker().client.disconnect();
                  setState(() {
                    disconnectButtonTitle = 'disconnected!';
                    connectButtonTitle = 'connect';
                    messageFromBroker = 'idle';
                  });
                },
                child: Text(disconnectButtonTitle))
          ],
        ),
      ),
    );
  }
}
