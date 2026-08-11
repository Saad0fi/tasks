import 'package:injectable/injectable.dart';
import 'package:tasks/core/client_mode/client_mode.dart';

/// Holds thin vs thick mode for this process only (not persisted).
@lazySingleton
class ClientModeService {
  ClientMode _mode = ClientMode.thin;

  ClientMode get currentMode => _mode;

  void setMode(ClientMode mode) {
    _mode = mode;
  }
}
