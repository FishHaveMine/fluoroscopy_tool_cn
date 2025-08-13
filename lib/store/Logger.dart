class Logger {
  static const String _tag = 'Master'; // 统一 Tag

  static void d(dynamic message) {
    print('[$_tag] [DEBUG] $message');
  }

  static void i(dynamic message) {
    print('[$_tag] [INFO] $message');
  }

  static void w(dynamic message) {
    print('[$_tag] [WARN] $message');
  }

  static void e(dynamic message) {
    print('[$_tag] [ERROR] $message');
  }
}
