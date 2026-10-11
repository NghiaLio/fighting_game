import 'package:flutter/material.dart';

/// Animation 1-3 sao nảy lên theo thứ tự + hiển thị thưởng xu
class StarRatingAnimation extends StatefulWidget {
  final int stars;
  final int coinsEarned;

  const StarRatingAnimation({
    super.key,
    required this.stars,
    required this.coinsEarned,
  });

  @override
  State<StarRatingAnimation> createState() => _StarRatingAnimationState();
}

class _StarRatingAnimationState extends State<StarRatingAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _starControllers;
  late final AnimationController _coinController;

  @override
  void initState() {
    super.initState();
    _starControllers = List.generate(3, (_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
    });
    _coinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    for (int i = 0; i < widget.stars; i++) {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      _starControllers[i].forward();
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _coinController.forward();
  }

  @override
  void dispose() {
    for (final c in _starControllers) {
      c.dispose();
    }
    _coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final shouldShow = index < widget.stars;
            final controller = _starControllers[index];
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final scale = shouldShow
                    ? Curves.easeOutBack.transform(controller.value)
                    : 0.0;
                return Transform.scale(
                  scale: scale.clamp(0.0, 1.0).toDouble(),
                  child: Icon(
                    Icons.star_rounded,
                    size: 32,
                    color: shouldShow
                        ? const Color(0xFFFFD54F)
                        : Colors.grey.shade700,
                    shadows: shouldShow
                        ? [
                            const Shadow(
                              color: Color(0xFFFF8F00),
                              blurRadius: 8,
                            )
                          ]
                        : null,
                  ),
                );
              },
            );
          }),
        ),
        AnimatedBuilder(
          animation: _coinController,
          builder: (context, child) {
            final opacity = _coinController.value;
            final translateY = (1.0 - _coinController.value) * -10;
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, translateY),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on_rounded,
                        size: 14, color: Color(0xFFFFD54F)),
                    SizedBox(width: 4),
                    Text(
                      '',
                      style: TextStyle(
                        color: Color(0xFFFFD54F),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
