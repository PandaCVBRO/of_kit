class Logger {
  Logger.info(String s) {
    if (!_kReleaseMode) {
      print('[ Info] ' + s);
    }
  }

  Logger.warning(String s) {
    if (!_kReleaseMode) {
      print('[Warni] ' + s);
    }
  }

  Logger.error(String s) {
    if (!_kReleaseMode) {
      print('[Error] ' + s);
    }
  }
}

const bool _kReleaseMode = const bool.fromEnvironment("dart.vm.product");
