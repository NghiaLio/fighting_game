import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/controllers/lan_versus_controller.dart';
import 'package:fighting_game/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanVersusScreen extends StatelessWidget {
  const LanVersusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanVersusController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Phông nền Dark Fantasy
          Image.asset(
            AppAssets.bgHome,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Lớp phủ Vignette tối điện ảnh
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),

          // 3. Nút Back góc trái
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFFFD54F)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // 4. Nội dung chính
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E140E).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFC107), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 24,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tiêu đề
                      const Text(
                        'PVP LAN MATCH',
                        style: TextStyle(
                          fontFamily: 'Pixel',
                          color: Color(0xFFFFD54F),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
                            Shadow(color: Color(0xFFD84315), blurRadius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Trạng thái hệ thống
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF5D4037)),
                        ),
                        child: Text(
                          controller.status.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Pixel',
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Thông số mạng
                      if (controller.connected.value) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi, color: Colors.amber, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'UDP RTT: ${controller.rttMs.value}ms',
                              style: const TextStyle(
                                fontFamily: 'Pixel',
                                color: Colors.amber,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Icon(
                              controller.peerReady.value ? Icons.check_circle_rounded : Icons.pending_rounded,
                              color: controller.peerReady.value ? Colors.greenAccent : Colors.orangeAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.peerReady.value ? 'OPPONENT READY' : 'WAITING FOR OPPONENT',
                              style: TextStyle(
                                fontFamily: 'Pixel',
                                color: controller.peerReady.value ? Colors.greenAccent : Colors.orangeAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Dropdown chọn nhân vật
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<CharacterType>(
                              value: controller.character.value,
                              dropdownColor: const Color(0xFF28211B),
                              style: const TextStyle(
                                fontFamily: 'Pixel',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'YOUR HERO',
                                labelStyle: TextStyle(
                                  fontFamily: 'Pixel',
                                  color: Color(0xFFFFC107),
                                  fontSize: 12,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF5D4037)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFFC107)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              items: CharacterType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name.toUpperCase()),
                                );
                              }).toList(),
                              onChanged: controller.roomEnded.value
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        controller.setCharacter(value);
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Nhập IP / Quét IP
                      if (!controller.hosting.value) ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.ipController,
                                onChanged: (_) => controller.setIpEdited(),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                style: const TextStyle(
                                  fontFamily: 'Pixel',
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'HOST IPv4 (LAN)',
                                  hintText: 'Enter Host IP',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Pixel',
                                    color: Color(0xFFFFC107),
                                    fontSize: 11,
                                  ),
                                  hintStyle: TextStyle(
                                    fontFamily: 'Pixel',
                                    color: Colors.white30,
                                    fontSize: 11,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF5D4037)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFFC107)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD84315),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: const BorderSide(color: Color(0xFFFFD54F)),
                                ),
                              ),
                              onPressed: controller.scanning.value || controller.busy.value 
                                  ? null 
                                  : () => controller.scanForHost(context),
                              icon: controller.scanning.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.wifi_find, size: 18),
                              label: Text(
                                controller.scanning.value ? 'SCANNING' : 'SCAN IP',
                                style: const TextStyle(
                                  fontFamily: 'Pixel',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Nút tương tác chính (Tạo/Vào/Ready)
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          if (!controller.connected.value && !controller.roomEnded.value)
                            _buildActionButton(
                              title: 'CREATE ROOM',
                              icon: Icons.add_moderator_rounded,
                              onPressed: controller.busy.value || controller.hosting.value ? null : controller.host,
                              isPrimary: true,
                            ),
                          if (!controller.connected.value && !controller.hosting.value && !controller.roomEnded.value)
                            _buildActionButton(
                              title: 'JOIN MATCH',
                              icon: Icons.login_rounded,
                              onPressed: controller.busy.value ? null : controller.join,
                              isPrimary: false,
                            ),
                          if (controller.connected.value && !controller.roomEnded.value)
                            _buildActionButton(
                              title: controller.myReady.value ? 'CANCEL READY' : 'READY',
                              icon: controller.myReady.value ? Icons.cancel_rounded : Icons.check_circle_rounded,
                              onPressed: controller.toggleReady,
                              isPrimary: !controller.myReady.value,
                              color: controller.myReady.value ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Ghi chú
                      const Text(
                        'Both devices must be on the same Wi-Fi/Hotspot.\nHost must allow application through firewall.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pixel',
                          color: Colors.white54,
                          fontSize: 10,
                          height: 1.5,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isPrimary,
    Color? color,
  }) {
    final bgColor = color ?? (isPrimary ? const Color(0xFF006064) : const Color(0xFF424242));
    final borderColor = color != null
        ? color.withValues(alpha: 0.5)
        : (isPrimary ? const Color(0xFF00E5FF) : Colors.grey);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.black45,
        disabledForegroundColor: Colors.white30,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: isPrimary ? 8 : 2,
        shadowColor: bgColor.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: onPressed != null ? borderColor : Colors.transparent, width: 1.5),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pixel',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
