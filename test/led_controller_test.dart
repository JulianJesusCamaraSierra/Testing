import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/led_controller.dart';

void main() {
  group('LEDController Tests', () {
    late LEDController led;

    setUp(() {
      led = LEDController();
    });

    test('LED should be off by default', () {
      expect(led.isOn, false);
    });

    test('LED turns on correctly', () {
      led.turnOn();
      expect(led.isOn, true);
    });

    test('LED turns off correctly', () {
      led.turnOn();
      led.turnOff();
      expect(led.isOn, false);
    });
  });
}
