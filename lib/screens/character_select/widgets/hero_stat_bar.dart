import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thanh hiển thị chỉ số sức mạnh trong bảng đá statTablet
class HeroStatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const HeroStatBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: GoogleFonts.cinzel(
              color: Colors.white70,
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 7,
              color: Colors.black.withValues(alpha: 0.65),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.6),
                            color,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 20,
          child: Text(
            '${(value * 100).toInt()}',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
