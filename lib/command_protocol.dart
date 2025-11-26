class CommandProtocol {
  String createCommand(String action, dynamic data) {
    return '$action:$data';
  }
}