// lib/sensor_interface.dart

abstract class SensorInterface {
  Future<double> readValue();
}

abstract class HumiditySensor {
  Future<int> getHumidity();
}

abstract class COxDetector {
  Future<int> getCOxLevel();
}

abstract class LightDetector {
  Future<bool> isDark();
}
