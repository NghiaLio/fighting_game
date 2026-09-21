import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:flutter/material.dart';

/// Overlay thông báo Round (1, 2, 3) hiện lên khi bắt đầu trận.
/// - Scale-in rồi hold, sau đó fade-out, tự động gọi [onDone].
/// - Sử dụng [TickerProviderStateMixin] để hỗ trợ nhiều AnimationController.
class RoundAnnouncementOverlay extends StatefulWidget {
  final int round;
  final VoidCallback onDone;

  const RoundAnnouncementOverlay({
    super.key,
    required this.round,
    required this.onDone,
  });

  @override
  State<RoundAnnouncementOverlay> createState() =>
      _RoundAnnouncementOverlayState();
}

class _RoundAnnouncementOverlayState extends State<RoundAnnouncementOverlay>
    with TickerProviderStateMixin {
  // Phase 1: Scale-in (0 → 1)
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scale;

  // Phase 2: Fade-out (1 → 0)
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;

  static const _holdDuration = Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();

    // --- Phase 1: scale-in ---
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutBack),
    );

    // --- Phase 2: fade-out ---
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn),
    );
    _fadeCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onDone();
      }
    });

    // Bắt đầu: scale-in → hold → fade-out
    _scaleCtrl.forward().then((_) {
      if (!mounted) return;
      // Phát âm thanh SAU khi scale-in xong để tránh delay
      Future.delayed(_holdDuration, () {
        if (mounted) _fadeCtrl.forward();
      });
    });

    // Phát âm thanh round ngay khi widget mount
    AudioService.playSkillSfx(_roundAudio(widget.round));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  String _roundImage(int round) {
    switch (round) {
      case 2:
        return AppAssets.imgRound2Flutter;
      case 3:
        return AppAssets.imgRound3Flutter;
      default:
        return AppAssets.imgRound1Flutter;
    }
  }

  String _roundAudio(int round) {
    switch (round) {
      case 2:
        return AppAssets.sfxRound2;
      case 3:
        return AppAssets.sfxRound3;
      default:
        return AppAssets.sfxRound1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleCtrl, _fadeCtrl]),
      builder: (context, _) {
        return Opacity(
          opacity: _fade.value,
          child: Container(
            color: Colors.black.withValues(alpha: 0.55),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: _scale.value,
              child: Image.asset(
                _roundImage(widget.round),
                width: screenW * 0.38, // ~38% chiều rộng màn hình (landscape)
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
