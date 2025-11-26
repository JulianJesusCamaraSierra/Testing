import 'package:mocktail/mocktail.dart';
import 'package:proyecto/sensor_interface.dart';

class MockGeneralSensor extends Mock implements SensorInterface {}
class MockHumidity extends Mock implements HumiditySensor {}
class MockCOx extends Mock implements COxDetector {}
class MockLight extends Mock implements LightDetector {}
