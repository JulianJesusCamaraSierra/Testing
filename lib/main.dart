import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Sensores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // importante: activa modo oscuro
        scaffoldBackgroundColor: Colors.grey[900], // fondo de toda la app
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.blue),
          bodyMedium: TextStyle(color: Colors.blueAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white10,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
      home: const BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});
  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothConnection? connection;
  bool isConnected = false;
  String temperature = "--";
  String humidity = "--";
  String gasStatus = "--";
  String logText = "Esperando conexión...";

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
    connectToESP32();
  }

  Future<void> connectToESP32() async {
    try {
      setState(() => logText = "Buscando dispositivos emparejados...");
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance
          .getBondedDevices();

      BluetoothDevice? espDevice;
      for (var d in devices) {
        if (d.name == "ESP32_Sensores") {
          espDevice = d;
          break;
        }
      }

      if (espDevice == null) {
        setState(
          () => logText = "⚠️ No se encontró el dispositivo 'ESP32_Sensores'.",
        );
        return;
      }

      setState(() => logText = "Conectando a ${espDevice!.name}...");
      connection = await BluetoothConnection.toAddress(espDevice.address);
      setState(() {
        isConnected = true;
        logText = "✅ Conectado a ${espDevice!.name}";
      });

      connection!.input!
          .listen((Uint8List data) {
            String received = utf8.decode(data).trim();
            List<String> parts = received.split(',');

            if (parts.length == 3) {
              setState(() {
                temperature = parts[0];
                humidity = parts[1];
                gasStatus = parts[2]; // Ya viene "peligro" o "seguro"
              });
            }
          })
          .onDone(() {
            setState(() {
              isConnected = false;
              logText = "🔴 Conexión terminada.";
            });
          });
    } catch (e) {
      setState(() => logText = "❌ Error: $e");
    }
  }

  void disconnect() {
    connection?.dispose();
    connection = null;
    setState(() {
      isConnected = false;
      logText = "🔴 Desconectado.";
    });
  }

  void sendLedCommand(String command) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList("$command\n".codeUnits));
      connection!.output.allSent;
    }
  }

  void sendLed2Command(String command) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList("$command\n".codeUnits));
      connection!.output.allSent;
    }
  }

  void sendServoCommand(String command) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList("$command\n".codeUnits));
      connection!.output.allSent;
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP32 Sensores"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (!isConnected) connectToESP32();
            },
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: disconnect),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  logText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isConnected ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 20),

                // --- TARJETA DE USUARIOS ---
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "👤 Usuarios",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => sendServoCommand("PAPA"),
                              child: const Text("👷🏽‍♂ Papá"),
                            ),
                            ElevatedButton(
                              onPressed: () => sendServoCommand("MAMA"),
                              child: const Text("👩🏿‍💼 Mamá"),
                            ),
                            ElevatedButton(
                              onPressed: () => sendServoCommand("MACHETE"),
                              child: const Text("🏇🏽 Machete"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- TARJETAS DE SENSORES ---
                SensorCard(label: "🌡️ Temperatura", value: "$temperature °C"),
                SensorCard(label: "💧 Humedad", value: "$humidity %"),
                SensorCard(label: "🔥 Gas (FC-22)", value: gasStatus),
                const SizedBox(height: 20),

                // --- TARJETA DE CONTROL LED 1 ---
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Control LED 1",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => sendLedCommand("ON"),
                              child: const Text("Encender"),
                            ),
                            ElevatedButton(
                              onPressed: () => sendLedCommand("OFF"),
                              child: const Text("Apagar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- TARJETA DE CONTROL LED 2 ---
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Control LED 2",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => sendLed2Command(
                                "ON2",
                              ), // 🔹 función independiente

                              child: const Text("Encender"),
                            ),
                            ElevatedButton(
                              onPressed: () => sendLed2Command(
                                "OFF2",
                              ), // 🔹 función independiente
                              child: const Text("Apagar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- TARJETA DE CONTROL PUERTA ---
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "🚪 Puerta",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => sendServoCommand("ABRIR"),
                              child: const Text("🔓 Abrir"),
                            ),
                            ElevatedButton(
                              onPressed: () => sendServoCommand("CERRAR"),
                              child: const Text("🔒 Cerrar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String label;
  final String value;
  const SensorCard({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 20)),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
