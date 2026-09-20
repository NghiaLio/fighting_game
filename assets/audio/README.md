# Thư mục âm thanh (Audio SFX & BGM)

Đặt các tệp âm thanh (định dạng `.mp3`, `.ogg`, `.wav`) vào thư mục này để game tự động phát.

### Các tệp âm thanh được định cấu hình sẵn:
- `click.mp3` : Âm thanh bấm nút giao diện (UI click / button press).
- `skill.mp3` : Âm thanh tung chiêu thức trong trận.
- `victory.mp3` : Nhạc kết thúc chiến thắng.
- `defeat.mp3` : Nhạc kết thúc thất bại.
- `bgm_home.mp3` : Nhạc nền màn hình chính.
- `bgm_battle.mp3` : Nhạc nền trong trận chiến.

Lưu ý: Nếu file âm thanh chưa được copy vào, `AudioService` sẽ tự động bắt lỗi an toàn (safe-catch) và không làm gián đoạn hay crash game, đồng thời vẫn giữ nguyên hiệu ứng rung (Haptic feedback) trên điện thoại.
