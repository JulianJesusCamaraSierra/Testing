import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/log_buffer.dart';

void main() {
  group('LogBuffer Tests', () {
    late LogBuffer buffer;

    setUp(() => buffer = LogBuffer());

    test('Should store logs normally', () {
      buffer.add("Log1");
      buffer.add("Log2");
      expect(buffer.getLogs(), ["Log1", "Log2"]);
    });

    test('Should only keep last 5 logs', () {
      for (int i = 1; i <= 7; i++) {
        buffer.add("Log$i");
      }

      expect(buffer.getLogs().length, 5);
      expect(buffer.getLogs(), ["Log3", "Log4", "Log5", "Log6", "Log7"]);
    });
  });
}
