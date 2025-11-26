import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/battery_monitor.dart';

void main() {
  group('BatteryMonitor Tests', () {
    final battery = BatteryMonitor();

    test('Battery level above 10 is not critical', () {
      expect(battery.isCritical(50), false);
    });

    test('Battery level equal to 10 is critical', () {
      expect(battery.isCritical(10), true);
    });

    test('Battery level below 10 is critical', () {
      expect(battery.isCritical(5), true);
    });
  });
}
