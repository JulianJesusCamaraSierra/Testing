// lib/iot_controller.dart

import 'sensor_interface.dart';

class IotController {
  final SensorInterface generalSensor;
  final HumiditySensor humiditySensor;
  final COxDetector coxDetector;
  final LightDetector lightDetector;

  bool isLoading = false;
  bool dangerAlert = false;

  IotController({
    required this.generalSensor,
    required this.humiditySensor,
    required this.coxDetector,
    required this.lightDetector,
  });

  Future<double> readGeneral() async {
    try {
      isLoading = true;
      final value = await generalSensor.readValue();
      isLoading = false;
      return value;
    } catch (e) {
      isLoading = false;
      return -1; // fallback
    }
  }

  Future<bool> checkAirQuality() async {
    try {
      final co = await coxDetector.getCOxLevel();
      dangerAlert = co > 200; 
      return dangerAlert;
    } catch (e) {
      dangerAlert = false;
      return false;
    }
  }

  Future<int> getHumidityLevel() async {
    try {
      return await humiditySensor.getHumidity();
    } catch (e) {
      return 0;
    }
  }

  Future<bool> checkLight() async {
    try {
      return await lightDetector.isDark();
    } catch (e) {
      return false;
    }
  }
}
