//lib/thermostat.dart
class Thermostat {
  double _targetTemperature = 20.0;

  double get targetTemperature => _targetTemperature;

  //unit to test: adjust temperature and return status message
  String setTargetTemperature(double newTemp){
    if (newTemp < 15.0 ) {
      _targetTemperature = 15.0;
      return "WARNING: Temperature too low, Mantained at 15.0°C";
    }
    if (newTemp > 30.0) {
      _targetTemperature = 30.0;
      return "WARNING: Temperature too high, Mantained at 30.0°C";
    }

    _targetTemperature = newTemp;
    return "Temperature set to ${newTemp.toStringAsFixed(1)}°C";
  }
}