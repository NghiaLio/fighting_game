import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeroUnlockDialog extends StatefulWidget {
  final HeroInfo hero;
  final int currentLevel;
  final int coins;
  final Future<bool> Function() onUnlock;

  const HeroUnlockDialog({
    super.key,
    required this.hero,
    required this.currentLevel,
    required this.coins,
    required this.onUnlock,
  });

  @override
  State<HeroUnlockDialog> createState() => _HeroUnlockDialogState();
}

class _HeroUnlockDialogState extends State<HeroUnlockDialog> {
  bool _isUnlocking = false;
  String? _message;

  Future<void> _unlock() async {
    if (_isUnlocking) return;
    setState(() {
      _isUnlocking = true;
      _message = null;
    });

    final unlocked = await widget.onUnlock();
    if (!mounted) return;

    if (unlocked) {
      Get.back();
      return;
    }

    setState(() {
      _isUnlocking = false;
      _message = 'KHÔNG ĐỦ TIỀN VÀNG';
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelLocked = widget.currentLevel < widget.hero.unlockLevel;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: UiTileWidget(
          tile: UiTile.hangingBoard,
          width: 390,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(42, 90, 42, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CHƯA MỞ KHÓA: ${widget.hero.name}',
                  textAlign: TextAlign.center,
                  style: GameTypography.pixel(
                    color: const Color(0xFFFFD54F),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  levelLocked
                      ? 'YÊU CẦU ĐẠT CẤP ${widget.hero.unlockLevel}'
                      : 'ĐÃ ĐẠT CẤP YÊU CẦU',
                  style: GameTypography.pixel(
                    color: levelLocked
                        ? Colors.orangeAccent
                        : Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'MỞ KHÓA VỚI ${widget.hero.unlockPrice} VÀNG',
                  style: GameTypography.pixel(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'VÀNG CỦA BẠN: ${widget.coins}',
                  style: GameTypography.pixel(
                    color: const Color(0xFFFFD54F),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _message!,
                    style: GameTypography.pixel(
                      color: Colors.redAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UiTileButton(
                      tile: UiTile.shortButton,
                      label: 'HỦY',
                      width: 120,
                      height: 40,
                      fontSize: 11,
                      onTap: Get.back,
                    ),
                    const SizedBox(width: 12),
                    UiTileButton(
                      tile: UiTile.shortButton,
                      label: _isUnlocking ? '...' : 'MỞ KHÓA',
                      width: 120,
                      height: 40,
                      fontSize: 11,
                      textColor: const Color(0xFFFFD54F),
                      onTap: _unlock,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
