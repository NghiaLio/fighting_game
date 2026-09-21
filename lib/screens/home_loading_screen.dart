import 'dart:async';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomeLoadingScreen extends StatefulWidget {
  const HomeLoadingScreen({super.key});

  @override
  State<HomeLoadingScreen> createState() => _HomeLoadingScreenState();
}

class _HomeLoadingScreenState extends State<HomeLoadingScreen>
    with TickerProviderStateMixin {
  // Logo fade & float animation
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;

  // Pulse effect for logo
  late AnimationController _pulseController;
  late Animation<double> _logoScale;

  // Shimmer effect for loading bar
  late AnimationController _shimmerController;

  // Loading progress
  double _targetProgress = 0.0;
  double _currentProgress = 0.0;
  String _statusText = 'Starting game engine...';
  bool _isLoaded = false;
  bool _isNavigating = false;
  Timer? _progressTicker;

  @override
  void initState() {
    super.initState();

    // 1. Dismiss native splash right away as soon as this home screen mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    // 2. Logo entrance animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0.0, -0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutCubic,
    ));

    // 3. Subtle breathing scale
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _logoScale = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 4. Shimmer on loading bar
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _logoController.forward();

    // 5. Smooth progress interpolation ticker (60 FPS)
    _progressTicker = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted) return;
      if (_currentProgress < _targetProgress) {
        setState(() {
          _currentProgress += (_targetProgress - _currentProgress) * 0.08 + 0.002;
          if (_currentProgress >= 0.999 && _targetProgress >= 1.0) {
            _currentProgress = 1.0;
            _isLoaded = true;
          }
        });
      }
    });

    // 6. Start preloading game assets
    _preloadGameAssets();
  }

  Future<void> _preloadGameAssets() async {
    // Step 1: Initialize
    try {
      await UiTileset.load();
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() {
      _targetProgress = 0.18;
      _statusText = 'Initializing graphics & tilesets...';
    });

    // Step 2: Preload UI Buttons and Arena Background
    try {
      await Flame.images.loadAll([
        'Backgrounds/bg1.png',
        'Buttons/left.png',
        'Buttons/right.png',
        'Buttons/up.png',
        'Buttons/attack.png',
        'Buttons/special.png',
        'Buttons/sprint.png',
      ]);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _targetProgress = 0.45;
      _statusText = 'Loading arena & input controls...';
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // Step 3: Preload Player Character Sprites
    try {
      await Flame.images.loadAll([
        'Fire_Wizard/Idle.png',
        'Fire_Wizard/Walk.png',
        'Fire_Wizard/Run.png',
        'Fire_Wizard/Jump.png',
        'Fire_Wizard/Attack_1.png',
        'Fire_Wizard/Attack_2.png',
        'Fire_Wizard/Attack_3.png',
        'Fire_Wizard/Special.png',
        'Fire_Wizard/Hurt.png',
        'Fire_Wizard/Dead.png',
        'Fire_Wizard/Projectile1.png',
      ]);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _targetProgress = 0.72;
      _statusText = 'Loading Fire Wizard character data...';
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // Step 4: Preload Enemy Character Sprites
    try {
      await Flame.images.loadAll([
        'Knight_1/Idle.png',
        'Knight_1/Walk.png',
        'Knight_1/Run.png',
        'Knight_1/Jump.png',
        'Knight_1/Attack_1.png',
        'Knight_1/Attack_2.png',
        'Knight_1/Attack_3.png',
        'Knight_1/Special.png',
        'Knight_1/Hurt.png',
        'Knight_1/Dead.png',
      ]);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _targetProgress = 0.92;
      _statusText = 'Preparing arena & AI opponents...';
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Step 5: Finalize
    setState(() {
      _targetProgress = 1.0;
      _statusText = 'Ready! Prepare for battle!';
    });

    // Auto-navigate after reaching 100% if user doesn't press
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted && !_isNavigating) {
      _startGame();
    }
  }

  void _startGame() {
    if (_isNavigating || !_isLoaded) return;
    _isNavigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _progressTicker?.cancel();
    _logoController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final progressPercent = (_currentProgress * 100).clamp(0, 100).toInt();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Scene (bg_home.png)
          Image.asset(
            'assets/images/Bg_homes/bg_home.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.black),
          ),

          // 2. Cinematic Vignette Overlay (dark edges for focus)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.15,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.75),
                ],
                stops: const [0.4, 0.75, 1.0],
              ),
            ),
          ),

          // 3. Top Logo (situated with top padding, fades & floats in)
          Positioned(
            top: size.height * 0.06,
            left: 0,
            right: 0,
            child: Center(
              child: SlideTransition(
                position: _logoSlide,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Hero(
                      tag: 'game_logo',
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: (size.width * 0.46).clamp(240.0, 480.0),
                          maxHeight: (size.height * 0.38).clamp(90.0, 180.0),
                        ),
                        child: Image.asset(
                          'assets/images/Bg_homes/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. Bottom Loading Bar & Status
          Positioned(
            bottom: size.height * 0.08,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: (size.width * 0.62).clamp(320.0, 620.0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Status text and percentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _statusText,
                          style: GameTypography.pixel(
                            color: Colors.amber.shade200,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$progressPercent%',
                          style: GameTypography.pixel(
                            color: Colors.amber.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 4,
                              ),
                              Shadow(
                                color: Color(0xFFE65100),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Slider Loading Bar
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E0B09),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFD4AF37), // Medieval Gold
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                          BoxShadow(
                            color: const Color(0xFFFF6F00).withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2.5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            // Glowing gradient fill
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _currentProgress.clamp(0.0, 1.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFB71C1C), // Deep Crimson
                                      Color(0xFFFF6D00), // Fiery Orange
                                      Color(0xFFFFD54F), // Radiant Gold
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Animated shimmer light passing through
                            if (_currentProgress > 0.05 && _currentProgress < 1.0)
                              AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, child) {
                                  return Positioned(
                                    left: (_shimmerController.value *
                                            ((size.width * 0.62)
                                                .clamp(320.0, 620.0))) -
                                        60,
                                    top: 0,
                                    bottom: 0,
                                    width: 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.0),
                                            Colors.white.withValues(alpha: 0.45),
                                            Colors.white.withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Tap to start indicator when 100%
                    AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: _startGame,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD4AF37),
                                Color(0xFFFF8F00),
                                Color(0xFFD4AF37),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700)
                                    .withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            'TAP TO START',
                            style: GameTypography.pixel(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
