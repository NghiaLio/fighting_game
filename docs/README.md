# Fighting Game — Kế Hoạch Phát Triển & Hoàn Thiện Dự Án

Tài liệu này tổng hợp toàn bộ lộ trình kỹ thuật, thiết kế đồ họa, âm thanh và kiến trúc để nâng cấp tựa game đối kháng 2D (Flutter + Flame) hiện tại lên một sản phẩm hoàn thiện, có chiều sâu và đạt chuẩn thương mại.

---

## 📚 Mục Lục Tài Liệu Chi Tiết

| File Tài Liệu | Nội Dung Chính |
| :--- | :--- |
| 📄 **[`01_ui_ux_screens_and_prompts.md`](file:///c:/Users/ADMIN/Documents/School/NewGame/fighting_game/docs/01_ui_ux_screens_and_prompts.md)** | **Thiết kế các màn hình & Bộ Prompt AI**: Main Menu, Chọn 12 Tướng, Chọn 7 Bản Đồ, Bảng Cài Đặt, Màn Hình Thắng/Thua K.O kèm prompt chuyên biệt cho Midjourney / DALL-E / Stable Diffusion. |
| 📄 **[`02_audio_and_sfx_guide.md`](file:///c:/Users/ADMIN/Documents/School/NewGame/fighting_game/docs/02_audio_and_sfx_guide.md)** | **Âm thanh & Nhạc nền (BGM & SFX)**: Danh mục các hiệu ứng âm thanh cần thiết, từ khóa tìm kiếm chuẩn trên Freesound/OpenGameArt và mã nguồn tích hợp `FlameAudio`. |
| 📄 **[`03_vfx_and_game_feel.md`](file:///c:/Users/ADMIN/Documents/School/NewGame/fighting_game/docs/03_vfx_and_game_feel.md)** | **Độ "Đã Tay" & Hiệu ứng Thị Giác (VFX)**: Tia lửa va chạm (Hit Sparks), Rung màn hình (Screen Shake), Khựng hình (Hit-Stop), Số sát thương nảy lên (Damage Numbers), Bụi tiếp đất. |
| 📄 **[`04_combat_mechanics_system.md`](file:///c:/Users/ADMIN/Documents/School/NewGame/fighting_game/docs/04_combat_mechanics_system.md)** | **Cơ chế Chiến Đấu Nâng Cao**: Thanh Nội năng (Mana/Energy), Hệ thống Combo liên hoàn, Đỡ đòn (Block/Guard) và bảng cân bằng chỉ số cho 5 trường phái võ thuật. |
| 📄 **[`05_game_modes_and_architecture.md`](file:///c:/Users/ADMIN/Documents/School/NewGame/fighting_game/docs/05_game_modes_and_architecture.md)** | **Chế Độ Chơi & Kiến Trúc Mã Nguồn**: Chế độ Leo Tháp (Arcade), Phòng Luyện Tập (Training), Đấu nhanh (Quick Fight), Hệ thống lưu dữ liệu bằng `shared_preferences` và cấu trúc dự án chuẩn. |

---

## 🎮 Tài Nguyên Sẵn Có Trong Dự Án
- **12 Nhân Vật Hoàn Chỉnh** (`assets/images/`): Đầy đủ sprite 128x128 từ Idle, Walk, Run, Jump, Attack 1, 2, 3, Special, Hurt, Dead.
- **7 Đấu Trường Phong Cảnh** (`assets/images/Backgrounds/`): Rừng cây, Sa mạc, Hang động, Hoàng hôn, Đêm trăng, Sấm sét, Đền cổ.
- **Hệ thống điều khiển MOBA** (`game_controls.dart`): Nút tròn nhỏ gọn, nhấp đúp chạy nhanh, bố cục vòng cung kỹ năng.
- **Camera động & Bản đồ nối dài**: Tự động bám theo nhân vật, bảo vệ vùng an toàn không bị khuất nút.
