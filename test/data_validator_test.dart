import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data_validator.dart';

void main() {
  group('DataValidator Tests', () {
    final validator = DataValidator();

    test('Valid value inside range', () {
      expect(validator.isValid(50), true);
    });

    test('Value below range should be invalid', () {
      expect(validator.isValid(0), false);
    });

    test('Value above range should be invalid', () {
      expect(validator.isValid(150), false);
    });
  });
}
