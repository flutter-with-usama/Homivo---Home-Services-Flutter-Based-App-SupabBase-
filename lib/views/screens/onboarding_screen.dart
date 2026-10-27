import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/services/local_cache_service.dart';
import '../../viewmodels/onboarding_viewmodel.dart';
import '../widgets/onboarding_logo.dart';
import '../widgets/onboarding_illustration.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_dot_indicator.dart';
import '../widgets/onboarding_nav_button.dart';

/// Full onboarding screen — assembles all components.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _handleComplete(BuildContext context) async {
    context.read<OnboardingViewModel>().complete();
    await LocalCacheService.instance.markOnboardingCompleted();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();
    final page = vm.currentPage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: Logo + Skip ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const OnboardingLogo(),

                  // Skip button — hidden on last page
                  AnimatedOpacity(
                    opacity: vm.isLast ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: vm.isLast ? null : vm.skip,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Illustration ───────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey('illus_${vm.currentIndex}'),
                  child: Center(
                    child: OnboardingIllustration(pageIndex: page.pageIndex),
                  ),
                ),
              ),
            ),

            // ── Content card ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Title + description
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: OnboardingContent(
                      key: ValueKey('content_${vm.currentIndex}'),
                      title: page.title,
                      description: page.description,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Bottom nav row ───────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back button — invisible on first page (keeps layout)
                      AnimatedOpacity(
                        opacity: vm.isFirst ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: OnboardingNavButton(
                          icon: Icons.arrow_back_rounded,
                          isPrimary: false,
                          onTap: vm.isFirst ? null : vm.previous,
                        ),
                      ),

                      // Dot indicator
                      OnboardingDotIndicator(
                        totalDots: vm.totalPages,
                        activeIndex: vm.currentIndex,
                      ),

                      // Next / Get Started button
                      vm.isLast
                          ? _GetStartedButton(
                              onTap: () => _handleComplete(context),
                            )
                          : OnboardingNavButton(
                              icon: Icons.arrow_forward_rounded,
                              isPrimary: true,
                              onTap: vm.next,
                            ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── "Get Started" wide button ─────────────────────────────────────────────────
class _GetStartedButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GetStartedButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
