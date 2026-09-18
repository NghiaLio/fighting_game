# Hướng Dẫn Thiết Kế Giao Diện & Bộ Prompt Tạo Ảnh AI (UI/UX)

Tài liệu này cung cấp chi tiết kiến trúc các màn hình cần thiết để phát triển game thành một sản phẩm hoàn chỉnh, đi kèm **các prompt chuyên biệt để tạo ảnh bằng AI (Midjourney, DALL-E 3, Stable Diffusion, Recraft, Leonardo AI)** đồng bộ với phong cách Pixel Art 16-bit sẵn có trong dự án.

---

## 1. Phong Cách Đồ Họa Cốt Lõi (Art Style Consistency)
- **Thể loại**: 2D Fantasy Pixel Art Fighting Game (cảm hứng từ *Street Fighter III: 3rd Strike*, *King of Fighters '98*, *Guilty Gear Isuka*, *BlazBlue*).
- **Màu sắc chủ đạo**: Tối huyền ảo (Dark Fantasy), ánh kim vàng, xanh neon phép thuật, viền giả kim loại đồng/vàng cổ điển.
- **Cách đính kèm ảnh có sẵn làm Reference (Image-to-Image / Style Reference)**:
  Khi sử dụng các công cụ như Midjourney (dùng tham số `--sref <link_ảnh>` hoặc đính kèm ảnh), Leonardo AI hay Stable Diffusion (ControlNet Reference):
  - Hãy đính kèm ảnh: `assets/images/Fire_Wizard/Idle.png`, `assets/images/Knight_1/Idle.png` để AI học phong cách Pixel Art nhân vật.
  - Đính kèm ảnh: `assets/images/Backgrounds/bg1.png` để AI học phong cách màu sắc thiên nhiên và độ chi tiết của cảnh nền.

---

## 2. Chi Tiết Các Màn Hình & Prompt AI Tương Ứng

### Màn hình 1: Màn Hình Khởi Động & Tiêu Đề (Splash & Main Title Screen)
* **Thành phần**:
  - Logo tên game hoành tráng (Ví dụ: *CHRONICLES OF VALOR* hoặc *ARCANE BRAWL*).
  - Hoạt ảnh nền động (hai tướng Fire Wizard và Knight đang đứng đối đầu giữa nền rừng bốc lửa).
  - Nút bấm chính: `PLAY GAME` (Chơi ngay), `ARCADE` (Leo tháp), `TRAINING` (Luyện tập), `SETTINGS` (Cài đặt).
* **Assets cần thêm**:
  - `title_logo.png`: Logo tên game với chữ pixel mạ vàng bốc lửa.
  - `menu_wood_panel.png`: Khung bảng gỗ/đá cổ làm nền menu.
* **Prompt Tạo Logo Game (DALL-E / Midjourney)**:
  > **Prompt**: `16-bit pixel art video game logo title, text reads "VALOR AWAKENING", epic dark fantasy fighting game title logo, gilded gold metallic bevel, glowing orange fire embers, ornate stone border, high contrast, clean transparent background, arcade style, authentic retro pixel graphics, pixelated aesthetic --no smooth, modern 3d, vector --ar 16:9`

* **Prompt Tạo Cảnh Nền Menu Chính (Background Art)**:
  > **Prompt**: `16-bit pixel art fantasy fighting game title screen background, wide panoramic landscape, dark twilight forest illuminated by mystic blue moon and glowing red magical bonfire, a hooded fire wizard and an armored knight locked in intense standoff silhouettes, cinematic composition, rich pixel textures, retro Capcom Neo-Geo aesthetic, pixel art masterpiece --ar 16:9`

---

### Màn hình 2: Màn Hình Chọn Nhân Vật (Character Selection Screen)
* **Thành phần**:
  - Lưới hiển thị 12 ô tướng (Grid 2x6 hoặc 3x4) tương ứng với 12 nhân vật có sẵn trong `assets/images/`:
    1. Fire Wizard (Pháp sư lửa)
    2. Lightning Mage (Pháp sư sấm sét)
    3. Wanderer Magician (Du mục thuật sĩ)
    4. Knight 1, Knight 2, Knight 3 (Hiệp sĩ kiếm, giáo, giáp nặng)
    5. Samurai, Samurai Archer, Samurai Commander (Võ sĩ đạo)
    6. Skeleton Archer, Skeleton Spearman, Skeleton Warrior (Đội quân xương)
  - Cửa sổ lớn ở hai bên:
    - Bên trái: Player 1 (Hiển thị chân dung lớn + hoạt ảnh Idle preview + Tên + 4 thanh chỉ số: Công, Thủ, Tốc, Tầm xa).
    - Bên phải: Đối thủ Player 2 / CPU.
* **Assets cần thêm**:
  - 12 Icon Avatar chân dung vuông `avatar_<tên_tướng>.png` (64x64 px).
  - Khung viền chọn tướng `char_select_frame.png` (khung kim loại pixel khi con trỏ di chuyển đến).
* **Prompt Tạo Khung Viền & Giao Diện Chọn Tướng (Character Select UI)**:
  > **Prompt**: `16-bit pixel art character selection screen UI kit for fighting game, modular UI elements on transparent background, ornate gothic bronze portrait frames, gold glowing cursor selector box, stat gauge bars (HP, ATK, SPD, RNG), arcade fighting game interface, crisp pixel grid, Street Fighter 3rd Strike aesthetic --no blur, anti-aliased --ar 16:9`

* **Prompt Tạo Bộ Avatar Chân Dung 12 Tướng (Pixel Portrait)**:
  *(Ví dụ tạo chân dung cho Fire Wizard & Knight)*:
  > **Prompt**: `16-bit pixel art character bust portrait, dramatic lighting, fantasy warrior icon, 64x64 pixel resolution style, crisp edges, limited color palette, clean solid color background for sprite cutout. Character: hooded arcane fire mage with glowing fiery eyes and burning runes / stoic knight in ornate steel helm with blue plume. Authentic retro fighting game roster portrait --no modern render`

---

### Màn hình 3: Màn Hình Chọn Đấu Trường (Stage Selection)
* **Thành phần**:
  - Trưng bày 7 bản đồ có sẵn trong `assets/images/Backgrounds/` (`bg1.png` đến `bg7.png`):
    - Stage 1: Rừng bách thảo cổ thụ (`bg1.png`)
    - Stage 2: Hẻm núi sa mạc rực nắng (`bg2.png`)
    - Stage 3: Hang động nham thạch ngầm (`bg3.png`)
    - Stage 4: Hoàng hôn bình nguyên thảo nguyên (`bg4.png`)
    - Stage 5: Đêm trăng thành quách tuyết phủ (`bg5.png`)
    - Stage 6: Thung lũng sấm chớp âm u (`bg6.png`)
    - Stage 7: Đền cổ hoang tàn u tối (`bg7.png`)
  - Thẻ bài thu nhỏ (Stage Preview Card) hình chữ nhật bo góc với khung viền đá pixel.
* **Assets cần thêm**:
  - `stage_card_border.png`: Khung viền pixel để lồng ảnh thumbnail bản đồ vào.

---

### Màn hình 4: Bảng Cài Đặt & Menu Tạm Dừng (Pause & Settings Modal)
* **Thành phần**:
  - Nền mờ làm tối trận đấu (Blur overlay).
  - Bảng Popup bằng đá chạm khắc pixel nằm giữa màn hình.
  - Tùy chỉnh thanh trượt âm lượng: `BGM Volume`, `SFX Volume`.
  - Nút chuyển đổi: `Touch Controls Haptic` (Rung phản hồi khi đánh), `Button Opacity` (Độ mờ của nút MOBA).
  - 3 nút lệnh: `RESUME` (Tiếp tục), `RESTART` (Đánh lại màn này), `EXIT TO MENU` (Về menu chính).
* **Prompt Tạo Khung Popup Modal (Gothic Pixel Popup Frame)**:
  > **Prompt**: `Pixel art pause menu dialog box, 16-bit retro UI popup window, stone carved slab with iron rivets, medieval fantasy border, antique wooden banner header with ribbon, slider bars and toggle switches in pixel style, isolated on transparent background, fighting game UI element --ar 4:3`

---

### Màn hình 5: Màn Hình Kết Quả Trận Đấu (Victory / Defeat / K.O Screen)
* **Thành phần**:
  - Chữ **`K.O`** / **`VICTORY`** / **`DEFEAT`** xuất hiện với hiệu ứng phóng to chấn động (Stamp effect).
  - Bảng tổng kết số liệu:
    - Thời gian trận đấu (Battle Time).
    - Tổng sát thương gây ra (Damage Dealt).
    - Chuỗi combo dài nhất (Max Combo).
  - 3 nút hành động: `REMATCH` (Tái đấu), `CHANGE HERO` (Đổi tướng), `MAIN MENU`.
* **Prompt Tạo Chữ Hiệu Ứng K.O / VICTORY (Arcade Text Stamps)**:
  > **Prompt**: `16-bit pixel art massive "K.O." banner typography and "VICTORY" banner, retro arcade fighting game victory splash, bold red and golden yellow gradient lettering, deep drop shadow, dramatic comic impact spikes and lightning accents, transparent background, authentic 90s Capcom Neo Geo style --no 3d render, vector`
