import 'dart:ui';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  late FightingGame _game;

  @override
  void initState() {
    super.initState();
    _game = FightingGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget<FightingGame>(
        game: _game,
        overlayBuilderMap: {
          'GameOver': (context, game) => _GameOverOverlay(game: game),
        },
      ),
    );
  }
}

class _GameOverOverlay extends StatefulWidget {
  final FightingGame game;

  const _GameOverOverlay({required this.game});

  @override
  State<_GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<_GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVictory = widget.game.isVictory;
    final primaryColor =
        isVictory ? const Color(0xFFFFD54F) : const Color(0xFFFF5252);
    final borderColor =
        isVictory ? const Color(0xFFD4AF37) : const Color(0xFFB71C1C);
    final glowColor =
        isVictory ? const Color(0xFFFF9800) : const Color(0xFFD32F2F);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        alignment: Alignment.center,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 440,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF141013),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.45),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.9),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Icon(
                    isVictory
                        ? Icons.emoji_events_rounded
                        : Icons.shield_outlined,
                    color: primaryColor,
                    size: 48,
                    shadows: [
                      Shadow(
                        color: glowColor,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title: CHIẾN THẮNG / THẤT BẠI
                  Text(
                    isVictory ? 'CHIẾN THẮNG!' : 'THẤT BẠI!',
                    style: GoogleFonts.cinzel(
                      color: primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                      shadows: [
                        Shadow(
                          color: glowColor,
                          blurRadius: 14,
                        ),
                        const Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    isVictory
                        ? 'Tuyệt vời! Bạn đã hạ gục hoàn toàn đối thủ!'
                        : 'Bạn đã gục ngã! Đừng nản lòng, hãy phục thù!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút Về Trang Chủ (Home)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.home_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: Text(
                            'TRANG CHỦ',
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.08),
                            side: BorderSide(
                              color: Colors.grey.shade600,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Nút Chơi Lại (Replay)
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isVictory
                                  ? const [
                                      Color(0xFFFFD54F),
                                      Color(0xFFFF8F00),
                                    ]
                                  : const [
                                      Color(0xFFFF7043),
                                      Color(0xFFD84315),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: glowColor.withValues(alpha: 0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              widget.game.restartMatch();
                            },
                            icon: Icon(
                              Icons.replay_rounded,
                              size: 20,
                              color: isVictory ? Colors.black : Colors.white,
                            ),
                            label: Text(
                              'CHƠI LẠI',
                              style: GoogleFonts.cinzel(
                                color: isVictory ? Colors.black : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
