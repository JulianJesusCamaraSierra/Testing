import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/command_protocol.dart';

void main() {
  group('CommandProtocol Tests', () {
    final protocol = CommandProtocol();

    test('Create command returns proper format', () {
      expect(protocol.createCommand("SET", 99), "SET:99");
    });

    test('Create command supports string data', () {
      expect(protocol.createCommand("MSG", "HELLO"), "MSG:HELLO");
    });
  });
}
