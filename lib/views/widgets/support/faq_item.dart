import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Expandable FAQ accordion item.
class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _rotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _expanded
              ? AppTheme.primaryLight
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expanded
                ? AppTheme.primary.withValues(alpha: 0.30)
                : const Color(0xFFF0F0F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Question row ─────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _expanded
                          ? AppTheme.primaryDark
                          : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                RotationTransition(
                  turns: _rotation,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _expanded
                        ? AppTheme.primary
                        : AppTheme.textGrey,
                    size: 20,
                  ),
                ),
              ],
            ),

            // ── Answer (animated) ────────────────────────────────────
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.answer,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textGrey,
                    height: 1.55,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
