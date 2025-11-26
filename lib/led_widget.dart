import 'package:flutter/material.dart';

class LEDWidget extends StatelessWidget {
  final bool isOn;

  const LEDWidget({super.key, required this.isOn});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      size: 40,
      color: isOn ? Colors.green : Colors.grey,
    );
  }
}
