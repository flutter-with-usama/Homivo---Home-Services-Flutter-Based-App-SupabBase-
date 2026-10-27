import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/counter_viewmodel.dart';

/// Displays the current counter value.
/// Uses [Consumer] so only this widget rebuilds on change.
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterViewModel>(
      builder: (context, vm, _) {
        return Column(
          children: [
            const Text('You have pushed the button this many times:'),
            const SizedBox(height: 8),
            Text(
              '${vm.count}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        );
      },
    );
  }
}
