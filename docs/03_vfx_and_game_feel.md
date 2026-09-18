# Hướng Dẫn Hiệu Ứng Hình Ảnh (VFX) & Độ "Đã Tay" (Game Feel)

"Game Feel" (cảm giác tay khi chơi) là ranh giới giữa một trò chơi bình thường và một tựa game đỉnh cao. Người chơi cảm nhận được sức mạnh của nhân vật thông qua **phản hồi thị giác tức thì** khi vũ khí chạm vào đối thủ.

---

## 1. Năm Hiệu Ứng Cốt Lõi Cần Triển Khai

### A. Hiệu Ứng Tia Lửa Va Chạm (Hit Sparks / Slash FX)
* **Mô tả**: Khi lưỡi kiếm chém trúng đối thủ hoặc đòn đâm tiếp xúc giáp, một vệt tia lửa hình bán nguyệt (hoặc chùm sao lửa pixel) bùng lên tại điểm va chạm trong `0.15s - 0.2s` rồi biến mất.
* **Quy cách Sprite Sheet**:
  - Dải sprite nằm ngang gồm **4 đến 6 frames**, mỗi frame kích thước `48x48 px` hoặc `64x64 px`.
  - Màu sắc: Trắng lõi, viền vàng cam rực cháy.
* **Prompt Tạo Hit Spark Bằng AI**:
  > **Prompt**: `16-bit pixel art hit spark effect spritesheet, horizontal sprite sheet strip of 5 frames, sharp golden yellow slash impact burst, white glowing core, comic anime combat impact flash, transparent background, isolated sprite frames, retro Street Fighter Alpha aesthetic --no background, 3d`

---

### B. Hiệu Ứng Nhấp Nháy Khi Bị Thương (Damage Flash / White & Red Tint)
* **Mô tả**: Khi bị dính đòn, toàn bộ sprite của nhân vật nhấp nháy màu trắng sáng hoặc đỏ tươi trong 2 frame (`0.04s - 0.08s`), sau đó trở lại bình thường.
* **Cách thực hiện trong Flutter / Flame (Không cần thêm ảnh)**:
  Sử dụng `Paint` với `ColorFilter.mode` để phủ màu trực tiếp lên Canvas trong `CharacterComponent`:
  ```dart
  // Khi nhận damage, bật cờ _isFlashing = true trong 0.08s:
  final flashPaint = Paint()
    ..colorFilter = const ColorFilter.mode(
      Colors.white, // Hoặc Colors.redAccent
      BlendMode.srcATop,
    );
  // Render sprite với flashPaint thay vì paint mặc định
  ```

---

### C. Cơ Chế Khựng Khung Hình (Hit-Stop / Freeze Frame)
* **Mô tả**: Đây là bí kíp game đối kháng kinh điển của Nhật Bản. Ngay khoảnh khắc kiếm chạm vào người đối thủ:
  - Cả người tấn công và người bị tấn công **dừng hình trong 3 đến 5 frames (khoảng 0.05s - 0.08s)**.
  - Sau 0.05s, chuyển động tiếp tục diễn ra với tốc độ bình thường.
* **Cảm nhận của người chơi**: Tạo cảm giác nhát chém có sức nặng ghê gớm, lưỡi kiếm như đang thực sự chém ngập vào giáp thịt đối thủ chứ không phải lướt qua một bóng ma.

---

### D. Rung Chấn Màn Hình (Screen Shake)
* **Mô tả**: Khi tung các chiêu thức hạng nặng (`Attack 3` - Phun lửa, hoặc `Ultimate` - Cầu lửa nổ):
  - Camera rung lắc ngẫu nhiên với biên độ nhỏ trong `0.15s - 0.25s`.
* **Cách lập trình thuật toán trong `FightingGame`**:
  ```dart
  double _shakeTimer = 0;
  double _shakeIntensity = 0;

  void triggerScreenShake({double duration = 0.2, double intensity = 6.0}) {
    _shakeTimer = duration;
    _shakeIntensity = intensity;
  }

  void _applyShake(double dt) {
    if (_shakeTimer <= 0) return;
    _shakeTimer -= dt;
    final random = Random();
    final offsetX = (random.nextDouble() * 2 - 1) * _shakeIntensity;
    final offsetY = (random.nextDouble() * 2 - 1) * _shakeIntensity;
    stage.position += Vector2(offsetX, offsetY);
  }
  ```

---

### E. Số Sát Thương Nảy Lên (Floating Damage Numbers)
* **Mô tả**: Khi trúng đòn, một con số thể hiện lượng máu bị trừ (ví dụ `-12`, `-36`, hoặc chữ `CRITICAL!`) nảy lên từ trên đầu đối thủ, bay vòng cung lên trên rồi mờ dần trong `0.6s`.
* **Màu sắc trực quan**:
  - Đòn đánh thường: Màu trắng viền đen (`-12`).
  - Đòn đặc biệt / Chí mạng: Màu vàng cam rực cháy, kích thước to hơn (`-48`).
* **Cách thực hiện**: Tạo một `TextComponent` ngắn hạn với thuộc tính `MoveEffect.by` bay lên cao `30px` và `OpacityEffect.fadeOut`.

---

### F. Hiệu Ứng Bụi Tiếp Đất & Chạy (Dust Particles)
* **Mô tả**: Khi nhân vật bứt tốc chạy (`Run`) hoặc từ trên không tiếp đất (`Landing`), một làn khói bụi pixel nhỏ cuộn ra sau gót chân.
* **Quy cách Sprite Sheet**: Dải ngang 4 frame `32x32 px` đám bụi màu xám trắng cuộn lên rồi tan biến.
* **Prompt Tạo Dust Effect Bằng AI**:
  > **Prompt**: `16-bit pixel art dust puff effect spritesheet, horizontal strip of 4 animation frames, cartoon smoke puff kicking up from ground, white and soft grey, transparent background, isolated retro platformer FX --no shadow, background`
