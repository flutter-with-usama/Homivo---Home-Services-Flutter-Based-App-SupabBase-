import 'package:provider/provider.dart';

import '../data/repositories/counter_repository_impl.dart';
import '../viewmodels/counter_viewmodel.dart';

/// All top-level providers registered in one place.
/// Add new [ChangeNotifierProvider] entries here as the app grows.
List<ChangeNotifierProvider> appProviders = [
  ChangeNotifierProvider<CounterViewModel>(
    create: (_) => CounterViewModel(CounterRepositoryImpl()),
  ),
];
