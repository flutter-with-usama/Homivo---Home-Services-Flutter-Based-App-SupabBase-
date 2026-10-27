import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/counter_viewmodel.dart';

/// Increment / Decrement buttons — reads ViewModel via [context.read].
class CounterControls extends StatelessWidget {
  const CounterControls({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CounterViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: 'decrement',
          onPressed: vm.decrement,
          tooltip: 'Decrement',
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 24),
        FloatingActionButton(
          heroTag: 'increment',
          onPressed: vm.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
