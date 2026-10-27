import 'package:flutter/material.dart';

/// White rounded card that groups a set of [ProfileMenuItem]s with a section title.
class ProfileMenuCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const ProfileMenuCard({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
