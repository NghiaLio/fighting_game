# Hướng Dẫn Âm Thanh, Nhạc Nền & Từ Khóa Tìm Kiếm (Audio & SFX)

Âm thanh chính là linh hồn mang lại độ "nặng", uy lực của các đòn đánh và nhịp độ kích thích trong game đối kháng. Dự án đã cài đặt sẵn thư viện **`flame_audio: ^2.12.2`**.

---

## 1. Cấu Trúc Thư Mục Âm Thanh Khuyên Dùng
Tạo thư mục trong project theo cấu trúc sau:
```text
assets/
└── audio/
    ├── bgm/                  # Nhạc nền lặp lại (Background Music - định dạng .mp3 hoặc .ogg)
    │   ├── menu_theme.mp3    # Nhạc trang trọng, hào hùng ngoài sảnh chính
    │   ├── battle_forest.mp3 # Nhạc dồn dập cho map rừng cây (bg1)
    │   ├── battle_desert.mp3 # Nhạc dồn dập cho map sa mạc (bg2)
    │   └── victory_jingle.mp3# Đoạn nhạc ngắn 5s khi thắng trận
    └── sfx/                  # Âm thanh hiệu ứng ngắn (Sound Effects - định dạng .wav)
        ├── announcer/        # Giọng đọc trọng tài
        ├── combat/           # Tiếng va chạm, chém, đấm
        ├── skills/           # Tiếng phép thuật, lửa, sét
        └── movement/         # Tiếng bước chân, nhảy, tiếp đất
```

---

## 2. Danh Sách Sound Effect Cần Thiết & Từ Khóa Tìm Kiếm Chuẩn

Bạn có thể tìm và tải miễn phí 100% (CC0 hoặc Royalty-Free) tại các nguồn uy tín:
- [Freesound.org](https://freesound.org/)
- [OpenGameArt.org](https://opengameart.org/)
- [Itch.io Game Audio](https://itch.io/game-assets/free/tag-sound-effects)
- [Sonniss GDC Archive](https://sonniss.com/gameaudioarchive)

### A. Nhóm Âm Thanh Trọng Tài / Thông Báo (Announcer Voice)
*Phong cách: Giọng nam trầm, dõng dạc phong cách Arcade cổ điển.*
| Tên File | Thời điểm phát | Từ khóa tìm kiếm gợi ý |
| :--- | :--- | :--- |
| `announcer_round1.wav` | Khi bắt đầu hiệp 1 ("Round 1") | `arcade announcer round one`, `fighting game voice` |
| `announcer_fight.wav` | Sau Round 1 để bắt đầu đấu ("Fight!") | `announcer fight yell`, `retro fighting fight sound` |
| `announcer_ko.wav` | Khi một bên hết máu ("K.O!") | `retro announcer KO`, `game over shout` |
| `announcer_you_win.wav` | Khi người chơi thắng ("You Win!") | `announcer you win`, `victory shout arcade` |

### B. Nhóm Âm Thanh Giao Tranh (Combat & Impact SFX)
*Yêu cầu: Âm thanh dứt khoát, có độ đanh và bass để cảm nhận được lực chém.*
| Tên File | Sử dụng cho hành động | Từ khóa tìm kiếm gợi ý |
| :--- | :--- | :--- |
| `slash_light.wav` | Đòn chém kiếm nhẹ (`ATK 1`) | `sword whoosh light`, `blade swing sound` |
| `slash_heavy.wav` | Đòn đâm/chém mạnh (`ATK 2`, `ATK 3`) | `heavy sword slash`, `katana slice cut` |
| `hit_flesh.wav` | Đòn chém trúng cơ thể đối thủ | `blade hit flesh impact`, `sword slash impact gore` |
| `hit_blunt.wav` | Đòn đánh trúng giáp sắt / xương | `armor hit clank`, `blunt impact thump` |
| `block_guard.wav`| Khi đòn đánh bị khiên đỡ | `shield block metal clank`, `sword parry clash` |

### C. Nhóm Âm Thanh Phép Thuật & Kỹ Năng (Magic & Skill SFX)
*Đặc trưng cho Fire Wizard, Lightning Mage, Wanderer.*
| Tên File | Sử dụng cho hành động | Từ khóa tìm kiếm gợi ý |
| :--- | :--- | :--- |
| `flame_cast.wav` | Khi vung tay tụ lửa (bắt đầu chiêu Special/ATK3)| `magic fire cast whoosh`, `fire ignite spell` |
| `flame_breath.wav` | Chiêu phun lửa dài (`ATK 3` của Fire Wizard) | `flamethrower continuous loop`, `fire breath dragon` |
| `fireball_fly.wav` | Quả cầu lửa đang bay ngang màn hình | `fireball flying loop`, `burning projectile whistle` |
| `fireball_explode.wav` | Quả cầu lửa phát nổ khi chạm đối thủ | `fire explosion blast boom`, `pyro blast impact` |
| `lightning_strike.wav` | Phép giật sét (Lightning Mage) | `lightning bolt magic strike`, `electric zap thunder` |

### D. Nhóm Âm Thanh Di Chuyển & Phản Hồi Cơ Thể (Movement & Grunts)
| Tên File | Sử dụng cho hành động | Từ khóa tìm kiếm gợi ý |
| :--- | :--- | :--- |
| `footstep_run.wav` | Khi nhân vật bứt tốc chạy (`Run`) | `footsteps dirt running fast`, `grass footsteps sound` |
| `jump_takeoff.wav` | Khi nhún chân bật nhảy lên (`Jump`) | `retro game jump 16bit`, `whoosh hop jump` |
| `jump_land.wav` | Khi chạm chân xuống đất (`Landing`) | `body landing thump dust`, `footstep heavy land` |
| `hurt_grunt_m.wav` | Tiếng rên khi bị trúng đòn (Nam) | `male damage grunt hurt sound`, `fighter hit voice` |
| `death_fall.wav` | Tiếng ngã sụp xuống nền đất khi chết | `body fall dirt thud`, `heavy armor drop ground` |

---

## 3. Cách Tích Hợp Vào Mã Nguồn Flame Game

Trong file `fighting_game.dart`, tải trước tất cả file âm thanh vào bộ nhớ đệm:
```dart
import 'package:flame_audio/flame_audio.dart';

// Trong onLoad() của FightingGame:
await FlameAudio.audioCache.loadAll([
  'sfx/combat/slash_light.wav',
  'sfx/combat/hit_flesh.wav',
  'sfx/skills/fireball_cast.wav',
  'sfx/skills/fireball_explode.wav',
  'sfx/movement/jump_takeoff.wav',
  'sfx/movement/jump_land.wav',
  'sfx/announcer/announcer_fight.wav',
  'sfx/announcer/announcer_ko.wav',
  'bgm/battle_forest.mp3',
]);

// Phát nhạc nền lặp lại vô tận:
FlameAudio.bgm.play('bgm/battle_forest.mp3', volume: 0.6);

// Phát hiệu ứng âm thanh tức thời trong đòn đánh:
FlameAudio.play('sfx/combat/slash_light.wav', volume: 0.85);
```
