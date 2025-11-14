import 'dart:async';

/// Simple debouncer utility following KISS principle
/// Delays execution until user stops typing
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Run the action after the delay
  /// Cancels previous pending action if called again
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Clean up timer
  void dispose() {
    _timer?.cancel();
  }
}
