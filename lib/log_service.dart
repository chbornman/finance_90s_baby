// log_service.dart
import 'package:logger/logger.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  // Private constructor
  LogService._internal();

  // Expose the singleton instance
  static LogService get instance => _instance;

  // Logging methods
  void info(String message) {
    _logger.i(message);
  }

  void error(String message) {
    _logger.e(message);
  }

  // Add more levels if needed
}