// test/iot_controller_test.dart
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:proyecto/iot_controller.dart';

import 'mock_sensor.dart';

void main() {
  late MockGeneralSensor mockGeneral;
  late MockHumidity mockHumidity;
  late MockCOx mockCOx;
  late MockLight mockLight;
  late IotController controller;

  setUp(() {
    mockGeneral = MockGeneralSensor();
    mockHumidity = MockHumidity();
    mockCOx = MockCOx();
    mockLight = MockLight();

    controller = IotController(
      generalSensor: mockGeneral,
      humiditySensor: mockHumidity,
      coxDetector: mockCOx,
      lightDetector: mockLight,
    );
  });

  test('General sensor returns a normal value', () async {
    when(() => mockGeneral.readValue())
        .thenAnswer((_) async => 24.7);

    final result = await controller.readGeneral();
    expect(result, 24.7);
    expect(controller.isLoading, false);
  });

  test('General sensor throws exception and fallback is used', () async {
    when(() => mockGeneral.readValue())
        .thenThrow(Exception('Sensor failure'));

    final result = await controller.readGeneral();
    expect(result, -1);
    expect(controller.isLoading, false);
  });


  test('COx sensor triggers danger alert when level is critical', () async {
    when(() => mockCOx.getCOxLevel())
        .thenAnswer((_) async => 250);

    final alert = await controller.checkAirQuality();

    expect(alert, true);
    expect(controller.dangerAlert, true);

    verify(() => mockCOx.getCOxLevel()).called(1);
  });

  test('General sensor simulates loading with delay', () async {
    when(() => mockGeneral.readValue())
        .thenAnswer((_) async {
      await Future.delayed(Duration(milliseconds: 300));
      return 50.0;
    });

    final future = controller.readGeneral();

    expect(controller.isLoading, true);

    final result = await future;
    expect(result, 50.0);
    expect(controller.isLoading, false);
  });

  test(
    'General sensor timeout test (10 sec wait)',
    () async {
      when(() => mockGeneral.readValue())
          .thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 20));
        return 1.0;
      });

      expect(
        () => controller.readGeneral().timeout(Duration(seconds: 5)),
        throwsA(isA<TimeoutException>()),
      );
    },
  );
}
