class LogBuffer {
  final List<String> _logs = [];

  void add(String entry) {
    if (_logs.length == 5) {
      _logs.removeAt(0); // elimina el más viejo
    }
    _logs.add(entry);
  }

  List<String> getLogs() {
    return List.unmodifiable(_logs);
  }
}
