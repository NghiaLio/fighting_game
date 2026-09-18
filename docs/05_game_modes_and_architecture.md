# Chế Độ Chơi, Kiến Trúc Mã Nguồn & Lưu Trữ Dữ Liệu (Game Architecture)

Tài liệu này hướng dẫn cách tổ chức mã nguồn Flutter/Flame và các chế độ chơi để đưa game lên kho ứng dụng (Google Play / App Store / Windows Store).

---

## 1. Ba Chế Độ Chơi Cốt Lõi (Core Game Modes)

### A. Chế Độ Vượt Màn Thử Thách (Arcade / Stage Gauntlet)
* **Luật chơi cốt lõi**:
  - Người chơi chọn 1 tướng anh hùng yêu thích.
  - Vượt qua **7 Màn đấu (7 Maps)** tương ứng với 7 bối cảnh đấu trường từ `bg1.png` đến `bg7.png`.
  - **Quy tắc bắt buộc (Must Win 3/3 Rounds)**: Ở mỗi màn đấu (Map), người chơi **phải đánh bại đối thủ liên tiếp 3 hiệp đấu (Round 1, 2 và 3)**. Nếu sẩy chân thua ở bất kỳ Round nào, người chơi bị tính Game Over (có thể dùng lượt Retry hoặc đấu lại Map).
  - **Tiến trình leo thang 7 Màn**:
    - **Map 1 (Rừng Xanh - `bg1.png`)**: Skeleton Warrior (Tân binh - Khởi động).
    - **Map 2 (Sa Mạc Cát - `bg2.png`)**: Skeleton Spearman (Tầm giáo nhử đòn khó chịu).
    - **Map 3 (Rừng Ma Sương Mù - `bg3.png`)**: Skeleton Archer (Bắn tên từ xa cực rát).
    - **Map 4 (Đền Cổ Hoang Tàn - `bg4.png`)**: Knight 1 / Knight 2 (Giáp sắt kiên cố, áp sát đè góc).
    - **Map 5 (Thác Nước Long Ẩn - `bg5.png`)**: Wanderer / Samurai (Lướt kiếm thần tốc).
    - **Map 6 (Huyết Điện Cấm Kỵ - `bg6.png`)**: Lightning Mage (Phép giật sấm sét liên hoàn).
    - **Map 7 (Hư Không Hắc Ám - `bg7.png`)**: **FINAL BOSS** (Samurai Commander / Fire Wizard thức tỉnh: 2.5x Máu, sát thương cực lớn, phản xạ 0.15s).
  - Sau khi chiến thắng trọn vẹn cả 7 Màn: Mở khóa danh hiệu Huyền Thoại Đấu Trường, mở khóa trang phục bí mật và ghi danh bảng thành tích.

### B. Chế Độ Đấu Nhanh (Quick Versus / AI Battle)
* **Luật chơi**:
  - Tự do chọn 1 tướng cho mình và 1 tướng cho máy (CPU).
  - Tự do chọn 1 trong 7 bản đồ đấu trường.
  - Tự chọn 3 mức độ thông minh của AI:
    - `Easy`: Phản xạ chậm 1.5s, chỉ đánh thường.
    - `Normal`: Phản xạ 0.8s, biết chạy áp sát và tung combo.
    - `Hard`: Phản xạ 0.3s, biết nhảy né đòn, biết dùng chiêu cuối khi đối thủ hở sườn.

### C. Chế Độ Phòng Tập Luyện (Practice / Training Room)
* **Mục đích**: Để người chơi làm quen với hệ thống nút MOBA và thử nghiệm tầm đánh của các chiêu thức.
* **Đặc điểm**:
  - Đối thủ là một "hình nộm" (Dummy): Máu không bao giờ cạn (tự động hồi đầy ngay lập tức).
  - Có thể bật/tắt hành vi của Dummy: *Đứng yên*, *Nhảy tại chỗ*, hoặc *Đánh trả nhẹ*.
  - Hiển thị bảng thông số trực tiếp trên góc màn hình: Lượng sát thương vừa gây ra, khoảng cách pixel hiện tại giữa 2 tướng.

---

## 2. Hệ Thống Lưu Trữ Dữ Liệu Cục Bộ (Persistence with SharedPreferences)

Cài đặt package `shared_preferences: ^2.3.0` để lưu trạng thái người chơi kể cả khi tắt game:
* **Các dữ liệu cần lưu trữ**:
  1. `bgm_volume` (double: 0.0 -> 1.0): Âm lượng nhạc nền.
  2. `sfx_volume` (double: 0.0 -> 1.0): Âm lượng hiệu ứng âm thanh.
  3. `high_score_arcade` (int): Điểm kỷ lục chế độ leo tháp.
  4. `unlocked_characters` (List<String>): Danh sách các tướng đã mở khóa.
  5. `last_selected_p1` (String): Tướng gần nhất người chơi từng chọn để tự động focus trong lần chơi kế tiếp.

* **Ví dụ code mẫu Service lưu trữ**:
  ```dart
  import 'package:shared_preferences/shared_preferences.dart';

  class GameStorageService {
    static late SharedPreferences _prefs;

    static Future<void> init() async {
      _prefs = await SharedPreferences.getInstance();
    }

    static double get bgmVolume => _prefs.getDouble('bgm_volume') ?? 0.7;
    static set bgmVolume(double val) => _prefs.setDouble('bgm_volume', val);

    static double get sfxVolume => _prefs.getDouble('sfx_volume') ?? 0.85;
    static set sfxVolume(double val) => _prefs.setDouble('sfx_volume', val);

    static int get arcadeHighScore => _prefs.getInt('high_score_arcade') ?? 0;
    static set arcadeHighScore(int score) => _prefs.setInt('high_score_arcade', score);
  }
  ```

---

## 3. Cấu Trúc Mã Nguồn Dự Án Khi Hoàn Thiện

```text
lib/
├── enums/                  # Các enum trạng thái, loại nhân vật, độ khó game
│   ├── character_state.dart
│   ├── character_type.dart
│   └── game_mode.dart      # arcade, quickVersus, training
├── models/                 # Model dữ liệu
├── constants/              # Hằng số màu sắc, cấu hình game
├── services/               # Quản lý âm thanh (AudioService), Lưu trữ (StorageService)
├── screens/                # Các màn hình Flutter widget
│   ├── main_menu_screen.dart
│   ├── character_select_screen.dart
│   ├── stage_select_screen.dart
│   └── game_play_screen.dart # Chứa GameWidget<FightingGame>
├── game/                   # Toàn bộ logic Flame Engine
│   ├── fighting_game.dart  # Core game loop, camera, stage
│   └── components/         # Các thành phần trong game
│       ├── character_component.dart
│       ├── background_component.dart
│       ├── fireball_component.dart
│       ├── hud_component.dart
│       ├── game_controls.dart
│       └── vfx/            # Hit sparks, damage numbers, dust
└── main.dart               # Khởi chạy app, landscape lock, điều hướng màn hình
```
