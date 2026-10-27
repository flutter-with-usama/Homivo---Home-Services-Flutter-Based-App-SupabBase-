import 'package:flutter/foundation.dart';

import '../data/models/onboarding_model.dart';
import '../data/repositories/onboarding_repository.dart';

class OnboardingViewModel extends ChangeNotifier {
  final OnboardingRepository _repository;

  late final List<OnboardingModel> _pages;
  int _currentIndex = 0;
  bool _completed = false;

  OnboardingViewModel(this._repository) {
    _pages = _repository.getPages();
  }

  // ── Exposed state ──────────────────────────────────────────────────────────

  List<OnboardingModel> get pages => _pages;
  int get currentIndex => _currentIndex;
  OnboardingModel get currentPage => _pages[_currentIndex];
  bool get isFirst => _currentIndex == 0;
  bool get isLast => _currentIndex == _pages.length - 1;
  int get totalPages => _pages.length;
  bool get completed => _completed;

  // ── Actions ────────────────────────────────────────────────────────────────

  void next() {
    if (!isLast) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previous() {
    if (!isFirst) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void goTo(int index) {
    if (index >= 0 && index < _pages.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Jump straight to the last page (skip) or mark as complete (get started).
  void skip() {
    _currentIndex = _pages.length - 1;
    notifyListeners();
  }

  void complete() {
    _completed = true;
    notifyListeners();
  }
}
