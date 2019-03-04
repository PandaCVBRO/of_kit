class OFLogger {
  OFLogger.debug(String s) {
    if (!_kReleaseMode) {
      print('[Debug] ' + s);
    }
  }

  OFLogger.info(String s) {
    if (!_kReleaseMode) {
      print('[ Info] ' + s);
    }
  }

  OFLogger.warning(String s) {
    if (!_kReleaseMode) {
      print('[Warni] ' + s);
    }
  }

  OFLogger.error(String s) {
    if (!_kReleaseMode) {
      print('[Error] ' + s);
    }
  }
}

const bool _kReleaseMode = const bool.fromEnvironment("dart.vm.product");
