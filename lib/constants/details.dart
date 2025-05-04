import 'package:flutter/material.dart';

class Details {
  static List<BoxShadow> boxShadowList = [
    // Layer 1: Closest to the container (strongest shadow)
    BoxShadow(
      color:
          const Color(0xFF000000).withOpacity(0.06), // #0000000F ≈ opacity 0.06
      offset: const Offset(0, 2),
      blurRadius: 5,
      spreadRadius: 0,
    ),
    // Layer 2
    BoxShadow(
      color:
          const Color(0xFF000000).withOpacity(0.05), // #0000000D ≈ opacity 0.05
      offset: const Offset(0, 9),
      blurRadius: 9,
      spreadRadius: 0,
    ),
    // Layer 3
    BoxShadow(
      color:
          const Color(0xFF000000).withOpacity(0.03), // #00000008 ≈ opacity 0.03
      offset: const Offset(0, 20),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    // Layer 4
    BoxShadow(
      color:
          const Color(0xFF000000).withOpacity(0.01), // #00000003 ≈ opacity 0.01
      offset: const Offset(0, 36),
      blurRadius: 14,
      spreadRadius: 0,
    ),
    // Layer 5: Farthest from container (lightest shadow)
    BoxShadow(
      color: const Color(0xFF000000)
          .withOpacity(0), // #00000000 = fully transparent
      offset: const Offset(0, 56),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}
