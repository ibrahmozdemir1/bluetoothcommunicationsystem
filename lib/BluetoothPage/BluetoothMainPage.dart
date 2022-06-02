import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'communication.dart';
import 'SelectBondedDevicePage.dart';
//import './ChatPage2.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
BluetoothDevice selectedDevice;
final TextEditingController textEditingController = new TextEditingController();
BluetoothConnection connection;

class _MainPage extends State<MainPage> {
  String deviceName;

  @override
  void initState() {
    super.initState();

    stateDevice();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  // This code is just a example if y

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  Future<String> stateDevice() async {
    if (selectedDevice != null) {
      return "Bağlantı Mevcut : ${deviceName}";
    } else {
      return "Bağlantı Mevcut Değil";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 90, 163),
        title: const Text('Kablosuz İletişim Sistemi'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 145, 199, 243),
              Colors.white,
              Color.fromARGB(255, 145, 199, 243),
            ])),
        child: ListView(
          children: <Widget>[
            Divider(),
            SwitchListTile(
              activeColor: Color.fromARGB(255, 6, 90, 163),
              inactiveTrackColor: Color.fromRGBO(181, 8, 11, 1),
              title: const Text('Bluetoothu Aç'),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: const Text('Bluetooth Durumu'),
              subtitle: (_bluetoothState.isEnabled != true)
                  ? Text("Bluetooth Kapalı")
                  : Text("Bluetooth Açık"),
              trailing: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 6, 90, 163)),
                child: const Text('Cihaz Seç ve Bağlan'),
                onPressed: () async {
                  selectedDevice = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(checkAvailability: false);
                      },
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 6, 90, 163)),
                child: const Text('Mesaj Gönder'),
                onPressed: () {
                  selectedDevice != null
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatPage(
                                server: selectedDevice,
                              );
                            },
                          ),
                        )
                      : showGeneralDialog(
                          context: context,
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return _informationDialog(context);
                          });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ShapeBorder _defaultShape() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
    side: const BorderSide(
      color: Color.fromARGB(255, 6, 90, 163),
    ),
  );
}

_getCloseButton(context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
    child: GestureDetector(
      onTap: () {},
      child: Container(
        alignment: FractionalOffset.topRight,
        child: TextButton(
          style: TextButton.styleFrom(padding: const EdgeInsets.all(4.0)),
          child: Center(child: Text("Geri Dön")),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

Widget _informationDialog(context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    shape: _defaultShape(),
    content: Padding(
      padding: const EdgeInsets.all(2),
      child: SizedBox(
        width: 55,
        height: 90,
        child: Column(
          children: <Widget>[
            Center(
              child: Text("Lütfen Bir Cihaza Bağlanın"),
            ),
            _getCloseButton(context),
          ],
        ),
      ),
    ),
  );
}
