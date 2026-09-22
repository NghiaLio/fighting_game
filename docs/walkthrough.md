# Hoàn Thành Cơ Chế AI Thông Minh Qua 3 Round 🧠⚔️

Hệ thống não bộ AI dựa trên `AiProfile` đã được xây dựng thành công theo đúng bản thiết kế. Dưới đây là tóm tắt những gì đã được hiện thực hóa:

## Thay Đổi Cốt Lõi (Core Logic)

1. **Bộ Hồ Sơ `AiProfile`**: 
   - Tạo mới model tại [`lib/models/ai_profile.dart`](file:///C:/Users/ADMIN/Documents/School/NewGame/fighting_game/lib/models/ai_profile.dart).
   - `AiProfile` sẽ tính toán và tự động sinh ra chỉ số phản xạ dựa vào tổ hợp `mapLevel` (Đẳng cấp Map từ 1 đến 7) và `round` (từ 1 đến 3).

2. **Cập nhật `CharacterComponent` (Bộ Não AI)**:
   - Các nhân vật NPC (`isPlayer: false`) giờ đây sẽ nhận vào một `AiProfile` và tự động điều chỉnh máu tối đa (`maxHp` $\times$ `hpMultiplier`) và sát thương (`damage` $\times$ `damageMultiplier`).
   - Hàm `_handleAI()` được đập đi xây lại hoàn toàn để tiếp nhận các hệ số tỷ lệ từ `AiProfile`:
     - **Phản Xạ (Think Delay)**: AI sẽ ra đòn nhanh hay chậm dựa trên tốc độ tính toán (Round 3 chỉ tốn ~0.2s để phản xạ).
     - **Đỡ Đòn & Né Tránh**: Khi người chơi tung đòn trong tầm đánh, AI có tỷ lệ lùi lại để né đòn (`blockChance`). AI cũng sẽ nhảy nhót (`jumpChance`) khi người chơi đánh hụt.
     - **Áp Sát Chớp Nhoáng (`Run`)**: Khi khoảng cách giữa 2 nhân vật xa hơn mức `runThreshold`, AI sẽ lập tức dùng hoạt ảnh `Run` để lao tới húc người chơi thay vì chỉ đi bộ lững thững.
     - **Chuỗi Combo & Tuyệt Kỹ**: Tỷ lệ ra tuyệt kỹ (`specialChance`) sẽ tăng đột biến ở Round 3 (Lên tới 80%), khiến AI trở thành một cỗ máy spam ULT liên tục nếu người chơi để hở sườn.

3. **Cập Nhật `FightingGame`**:
   - Tự động thay não bộ mới (`AiProfile.forMapAndRound`) cho Enemy mỗi khi `restartMatch()` (chơi lại round đó) hoặc `startNewLevel()` (qua hiệp mới).

## Trải Nghiệm Thay Đổi Như Thế Nào?

Khi bạn chơi ngay lúc này:
> [!NOTE]
> **Round 1:** Máy ngốc nghếch, đi bộ chậm rãi và lâu lâu mới ra đòn, dễ dàng để bạn làm nóng tay.
> **Round 2:** Máy bắt đầu biết lùi lại khi bạn vung kiếm, chủ động lao tới khi ở xa. Máu và sát thương cũng đã trâu hơn một chút.
> **Round 3:** Thử thách thực sự! Máy sẽ phản xạ cực gắt, xả chiêu cuối liên hoàn và liên tục áp sát. Máu và sát thương của boss Round 3 sẽ được buff mạnh (`x1.15`).

Hãy build thử ứng dụng, vào game và chơi đến Round 3 để cảm nhận sự lợi hại của AI mới này nhé! Đừng quên thông báo cho tôi nếu bạn muốn tiếp tục làm tính năng Thanh Năng Lượng (Mana Bar) đã đề cập trong bản thiết kế.
