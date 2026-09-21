import 'dart:async';
import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

/// Controller quản lý tiến trình tải tài nguyên, hoạt ảnh và điều hướng của màn hình tải (HomeLoadingScreen)
class HomeLoadingController extends GetxController
    with GetTickerProviderStateMixin {
  static HomeLoadingController get to => Get.find<HomeLoadingController>();

  // Hoạt ảnh xuất hiện logo (Fade & Slide)
  late final AnimationController logoController;
  late final Animation<double> logoOpacity;
  late final Animation<Offset> logoSlide;

  // Hiệu ứng nhịp thở cho logo (Breathing Scale)
  late final AnimationController pulseController;
  late final Animation<double> logoScale;

  // Hiệu ứng ánh sáng quét qua thanh loading (Shimmer)
  late final AnimationController shimmerController;

  // Tiến trình tải (Reactive)
  double _targetProgress = 0.0;
  final RxDouble currentProgress = 0.0.obs;
  final RxString statusText = AppStrings.loadingInitGraphics.obs;
  final RxBool isLoaded = false.obs;

  bool _isNavigating = false;
  Timer? _progressTicker;

  @override
  void onInit() {
    super.onInit();

    // 1. Tắt splash native ngay khi màn hình khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    // 2. Hoạt ảnh xuất hiện logo
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    logoOpacity = CurvedAnimation(
      parent: logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );
    logoSlide = Tween<Offset>(
      begin: const Offset(0.0, -0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: logoController,
      curve: Curves.easeOutCubic,
    ));

    // 3. Hiệu ứng nhịp thở
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    logoScale = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    // 4. Shimmer thanh loading
    shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    logoController.forward();

    // 5. Bộ đếm làm mượt tiến trình tải (60 FPS)
    _progressTicker = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (currentProgress.value < _targetProgress) {
        final next = currentProgress.value +
            (_targetProgress - currentProgress.value) * 0.08 +
            0.002;
        if (next >= 0.999 && _targetProgress >= 1.0) {
          currentProgress.value = 1.0;
          isLoaded.value = true;
        } else {
          currentProgress.value = next;
        }
      }
    });

    // 6. Bắt đầu nạp tài nguyên game
    _preloadGameAssets();
  }

  Future<void> _preloadGameAssets() async {
    // Bước 1: Khởi tạo Tileset
    try {
      await UiTileset.load();
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 200));
    _targetProgress = 0.18;
    statusText.value = AppStrings.loadingInitGraphics;

    // Bước 2: Tải trước UI Buttons, Arena Background, VFX & Audio SoundPool
    try {
      await Future.wait([
        Flame.images.loadAll([
          AppAssets.arenaBg1,
          ...AppAssets.battleControls,
          AppAssets.hitSpark,
          AppAssets.dustPuff,
          AppAssets.vfxWin,
          AppAssets.vfxLose,
          AppAssets.round1,
          AppAssets.round2,
          AppAssets.round3,
        ]),
        AudioService.preloadAll(),
      ]);
    } catch (_) {}

    _targetProgress = 0.45;
    statusText.value = AppStrings.loadingArenaControls;
    await Future.delayed(const Duration(milliseconds: 400));

    // Bước 3: Tải Sprite nhân vật người chơi (Fire Wizard)
    try {
      final fireWizardSprites = CharacterState.values
          .map((s) => AppAssets.characterStateFlamePath(
              CharacterType.fireWizard.spritePath, s.spritePath))
          .toList()
        ..add(AppAssets.fireballProjectile);
      await Flame.images.loadAll(fireWizardSprites);
    } catch (_) {}

    _targetProgress = 0.72;
    statusText.value = AppStrings.loadingFireWizard;
    await Future.delayed(const Duration(milliseconds: 400));

    // Bước 4: Tải Sprite kẻ địch (Knight 1)
    try {
      final knightSprites = CharacterState.values
          .map((s) => AppAssets.characterStateFlamePath(
              CharacterType.knight1.spritePath, s.spritePath))
          .toList();
      await Flame.images.loadAll(knightSprites);
    } catch (_) {}

    _targetProgress = 0.92;
    statusText.value = AppStrings.loadingPreparingArena;
    await Future.delayed(const Duration(milliseconds: 500));

    // Bước 5: Hoàn tất
    _targetProgress = 1.0;
    statusText.value = AppStrings.loadingReady;

    // Tự động chuyển màn hình sau 1.2s nếu người chơi chưa chạm
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!_isNavigating) {
      startGame();
    }
  }

  /// Chuyển tiếp vào màn hình chính (HomeScreen)
  void startGame() {
    if (_isNavigating || !isLoaded.value) return;
    _isNavigating = true;

    Get.off(
      () => const HomeScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void onClose() {
    _progressTicker?.cancel();
    logoController.dispose();
    pulseController.dispose();
    shimmerController.dispose();
    super.onClose();
  }
}
