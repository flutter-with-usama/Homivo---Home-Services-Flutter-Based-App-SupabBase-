import 'package:flutter/material.dart';
import 'illustrations/illustration_page1.dart';
import 'illustrations/illustration_page2.dart';
import 'illustrations/illustration_page3.dart';

/// Picks the correct animated illustration based on [pageIndex].
class OnboardingIllustration extends StatelessWidget {
  final int pageIndex;

  const OnboardingIllustration({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return switch (pageIndex) {
      0 => const IllustrationPage1(),
      1 => const IllustrationPage2(),
      2 => const IllustrationPage3(),
      _ => const IllustrationPage1(),
    };
  }
}
