import 'package:flutter/foundation.dart';

import '../data/models/counter_model.dart';
import '../data/repositories/counter_repository.dart';

/// ViewModel — bridges the repository (data) and the View (UI).
/// Extends [ChangeNotifier] so Provider can broadcast updates.
class CounterViewModel extends ChangeNotifier {
  final CounterRepository _repository;

  late CounterModel _model;

  CounterViewModel(this._repository) {
    _model = _repository.getInitialCounter();
  }

  // ── Exposed state ──────────────────────────────────────────────────────────

  int get count => _model.count;

  // ── Actions ────────────────────────────────────────────────────────────────

  void increment() {
    _model = _repository.increment(_model);
    notifyListeners();
  }

  void decrement() {
    _model = _repository.decrement(_model);
    notifyListeners();
  }

  void reset() {
    _model = _repository.getInitialCounter();
    notifyListeners();
  }
}
