# KỊCH BẢN SLIDE THUYẾT TRÌNH ĐỒ ÁN GAME: LỜI NGUYỀN HƯ KHÔNG
## (DETAILED PRESENTATION SLIDE DECK SCRIPT & SPEAKER NOTES)

* **Tên đề tài**: *Lời Nguyền Hư Không (Chronicles of Valdris)*
* **Thời lượng thuyết trình đề xuất**: 12 - 15 phút
* **Cấu trúc bộ Slide**: 18 Slides bám sát 5 cụm tiêu chí đánh giá (Thang điểm 5.0)
* **Quy chuẩn**: Mỗi slide có bố cục hiển thị, trích dẫn mã nguồn/công thức toán, hình ảnh minh chứng cụ thể và lời thoại thuyết trình (*Speaker Script*) từng câu chữ.

---

## TỔNG QUAN PH N BỔ THỜI GIAN THUYẾT TRÌNH

| Khối Nội Dung | Các Slide | Thời Lượng | Tiêu Chí Đáp Ứng |
| :--- | :---: | :---: | :---: |
| **Phần Mở Đầu**: Giới thiệu & Kiến trúc hệ thống | Slide 1 - 3 | 2.0 phút | Tổng quan đề tài |
| **Tiêu Chí 1**: Cốt truyện, Art Style & Combat Mechanics | Slide 4 - 7 | 3.5 phút | **1,0 Điểm** (Cốt truyện, Style, Cơ chế logic) |
| **Tiêu Chí 2**: Nhân vật, Thực thể, Thế giới & UI/UX | Slide 8 - 10 | 2.5 phút | **1,0 Điểm** (Nhiều nhân vật, Thế giới, Đồ họa dễ nhìn) |
| **Tiêu Chí 3**: Gameplay, 4 Chế độ & Hiệu năng 60 FPS | Slide 11 - 12 | 2.5 phút | **1,0 Điểm** (Gameplay độc đáo, Demo mượt/không crash) |
| **Tiêu Chí 4**: 7 Bản đồ, Thể thức 3 Round & Ma trận độ khó | Slide 13 - 14 | 2.0 phút | **1,0 Điểm** (Cấp độ/Maps, Nhiệm vụ có độ khó) |
| **Tiêu Chí 5**: NPC AI, Độ hoàn thiện & Tính thương mại | Slide 15 - 17 | 2.5 phút | **1,0 Điểm** (NPC AI, Hoàn thiện cao, Thương mại) |
| **Tổng Kết & Q&A**: Demo trực tiếp & Hỏi đáp hội đồng | Slide 18 | 2.0 phút | Nghiệm thu sản phẩm |

---

## CHI TIẾT TỪNG SLIDE THUYẾT TRÌNH

---

### SLIDE 1: MÀN HÌNH MỞ ĐẦU (TITLE SLIDE)
* **Thời lượng**: 30 giây
* **Nội dung hiển thị trên Slide**:
  - Logo chính: *VALOR AWAKENING / CHRONICLES OF VALDRIS*
  - Tên đề tài: **NGHIÊN CỨU VÀ PHÁT TRIỂN GAME ĐỐI KHÁNG 2D THỜI GIAN THỰC TRÊN NỀN TẢNG FLUTTER VÀ FLAME ENGINE**
  - Giảng viên hướng dẫn: [Điền tên Giảng viên]
  - Sinh viên thực hiện: [Điền tên Sinh viên / Nhóm]
  - Nền slide: Poster 16-bit cảnh Fire Wizard đối đầu Knight dưới ánh trăng.
* **Minh chứng / Trích dẫn**:
  - Logo và poster thiết kế pixel art từ thư mục `assets/images/`.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Kính thưa quý thầy cô trong Hội đồng chấm đồ án và toàn thể các bạn! Hôm nay, em xin đại diện nhóm trình bày về sản phẩm game đối kháng 2D hành động thời gian thực mang tên: **Biên Niên Sử Lời Nguyền Hư Không - Chronicles of Valdris**. Dự án được xây dựng hoàn toàn trên nền tảng Flutter và Flame Engine, giải quyết bài toán đưa trải nghiệm đối kháng giàu chiều sâu chiến thuật của hệ máy arcade lên thiết bị di động với hiệu năng 60 FPS mượt mà."*

---

### SLIDE 2: BỐI CẢNH ĐỀ TÀI & BÀI TOÁN THIẾT KẾ (PROBLEM STATEMENT)
* **Thời lượng**: 45 giây
* **Nội dung hiển thị trên Slide**:
  - **Thực trạng**: Game đối kháng di động hiện nay hoặc bị đơn giản hóa thành thẻ bài tự đánh (*Auto-battler*), hoặc giữ cụm phím vuốt arcade phức tạp (*quarter-circle*) gây khó thao tác trên màn hình cảm ứng.
  - **Giải pháp của dự án**:
    1. Giữ trọn chiều sâu đối kháng cổ điển: Khoảng cách (*Spacing*), Phản xạ đỡ đòn (*Parry/Block*), Chuỗi liên hoàn (*Combo Canceling*).
    2. Cải tiến giao diện điều khiển theo chuẩn **MOBA công thái học** trực quan.
    3. Tích hợp trí tuệ nhân tạo thích ứng (Adaptive AI) và chế độ đấu mạng LAN không cần server trung gian.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Trên thị trường di động, việc chơi game đối kháng truyền thống bằng phím ảo thường đem lại cảm giác ức chế do lệnh vuốt phức tạp. Chúng em đặt ra mục tiêu: Làm sao để một người mới chơi có thể tiếp cận ngay trong 30 giây đầu tiên nhờ cụm phím MOBA quen thuộc, nhưng để chiến thắng ở các màn chơi cấp cao thì bắt buộc phải làm chủ được kỹ năng đọc tình huống, căn khoảng cách và quản lý nội năng."*

---

### SLIDE 3: TỔNG QUAN KIẾN TRÚC PHẦN MỀM (SYSTEM ARCHITECTURE)
* **Thời lượng**: 45 giây
* **Nội dung hiển thị trên Slide**:
  - Sơ đồ phân tầng 5 lớp:
    1. **Presentation Layer**: Flutter UI Widgets, HUD, Overlays.
    2. **Engine Layer**: Flame Game Loop, Component Tree, Collision Detection.
    3. **Controller Layer**: GetX Reactive State Management.
    4. **Data & Storage Layer**: Hive NoSQL Local Storage siêu tốc.
    5. **Network Layer**: UDP Datagram Socket & TCP Beacon Lobby.
* **Trích dẫn kỹ thuật**:
  - File điều phối chính: `lib/game/fighting_game.dart`.
  - Service lưu trữ: `lib/services/progress_service.dart`.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Về mặt kỹ thuật, dự án được tổ chức theo kiến trúc 5 phân tầng rõ rệt. Flame Engine đảm nhận Game Loop và xử lý va chạm vật lý; GetX điều phối trạng thái giao diện; cơ sở dữ liệu Hive NoSQL đảm bảo việc ghi nhớ tiến trình game với tốc độ truy xuất mili-giây; và tầng Network phụ trách gói tin UDP thời gian thực cho chế độ thi đấu qua mạng LAN."*

---

### SLIDE 4: TIÊU CHÍ 1.1 - CỐT TRUYỆN "LỜI NGUYỀN HƯ KHÔNG" (NARRATIVE LORE)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - Có cốt truyện hấp dẫn]
* **Nội dung hiển thị trên Slide**:
  - **Truyền thuyết Valdris**: 7 Ngọn Đá Linh Hồn đại diện cho 7 nguyên tố nguyên sơ bị Đại pháp sư Molcharis tha hóa nhằm mở Cánh Cổng Hư Không.
  - **7 Hồi kịch bản chiến dịch**:
    - *Hồi 1 (Rừng Cổ)*: Kỵ Sĩ Tuần Tra tha hóa.
    - *Hồi 2 (Sa Mạc)*: Kiếm Khách Cát Lún.
    - *Hồi 3 (Nham Thạch)*: Pháp Sư Hỏa Ngục.
    - *Hồi 4 (Mây Ngàn)*: Pháp Sư Sấm Sét.
    - *Hồi 5 (Băng Tuyết)*: Hiệp Sĩ Hàn Băng.
    - *Hồi 6 (Bão Tím)*: Đại Tướng Samurai Nobunaga.
    - *Hồi 7 (Đền Cổ Hư Không)*: Chúa Tể Xương Molcharis (Trùm cuối).
* **Minh chứng cụ thể**:
  - **[MC-01]**: Ảnh chụp modal đọc truyện `StoryDialog` trên Bản đồ.
  - **[MC-02]**: Ảnh chi tiết kịch bản Ải 1 và Ải 7 từ file `assets/config/story.json`.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Điểm nhấn đầu tiên của game là cốt truyện được xây dựng chặt chẽ mang tên 'Biên Niên Sử Lời Nguyền Hư Không'. Người chơi sẽ vào vai hiệp sĩ ánh sáng du hành qua 7 vùng đất hiểm trở của đại lục Valdris. Toàn bộ kịch bản 7 hồi từ Rừng Cổ đến Đền Cổ Thác Mây được cấu hình động bằng JSON qua `StoryService`, giúp người chơi hiểu rõ lai lịch từng tên trùm trước khi bước vào trận chiến sinh tử."*

---

### SLIDE 5: TIÊU CHÍ 1.2 - PHONG CÁCH NGHỆ THUẬT 16-BIT PIXEL ART (ART STYLE)
* **Thời lượng**: 45 giây
* **Tiêu chí đáp ứng**: [1.0đ - Có phong cách nghệ thuật chủ đạo]
* **Nội dung hiển thị trên Slide**:
  - **Phong cách chủ đạo**: 16-bit Retro Dark Fantasy Pixel Art mang âm hưởng game thùng thập niên 90.
  - **Chuẩn hóa Sprite Sheet**:
    - Kích thước chuẩn: **128 x 128 pixel / frame**.
    - Bộ 10 hoạt họa độc lập: `Idle`, `Walk`, `Run`, `Jump`, `Attack 1`, `Attack 2`, `Attack 3`, `Special`, `Hurt`, `Dead`.
  - **Hệ màu tương phản**: Nền tối sẫm huyền ảo (`#1A1A2E`) làm nổi bật hiệu ứng ánh sáng kỹ năng rực rỡ (Cam lửa `#FF5722`, Xanh lôi điện `#00E5FF`).
* **Minh chứng cụ thể**:
  - **[MC-03]**: Ảnh bảng Sprite Sheet hoàn chỉnh 10 trạng thái của Pháp Sư Lửa và Kỵ Sĩ Arthur trong thư mục `assets/images/`.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Về phong cách mỹ thuật, trò chơi trung thành với phong cách 16-bit Pixel Art cổ điển. Tất cả 8 nhân vật đều được thiết kế chuẩn xác trên khung 128x128 pixel với đầy đủ 10 chuỗi chuyển động mượt mà. Sự tương phản giữa phông nền tối huyền ảo và ánh sáng neon rực rỡ của chiêu thức tạo nên nét độc đáo và dễ nhìn trong từng khung hình."*

---

### SLIDE 6: TIÊU CHÍ 1.3 - CƠ CHẾ CHIẾN ĐẤU CỐT LÕI & QUẢN LÝ MANA (COMBAT SYSTEM)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - Cơ chế game đa dạng, logic]
* **Nội dung hiển thị trên Slide**:
  - **Thanh Nội Năng (Mana Gauge 0 -> 100)**:
    - Nạp: Đánh trúng `+10`, Bị đánh `+5`, Tự hồi `+2/s`.
    - Tiêu hao: Đòn nhẹ/vừa tiêu hao `0 Mana`, Đòn nặng tiêu hao `25 Mana`, Tuyệt kỹ tối thượng tiêu hao `50 Mana`.
  - **Chuỗi đòn liên hoàn & Hủy chiêu (Chain Combo Canceling)**:
    $$\text{ATK 1} \xrightarrow{0.2s} \text{ATK 2} \xrightarrow{0.2s} \text{ATK 3} \xrightarrow{\text{Cancel}} \text{ULTIMATE}$$
    - Nối đủ 3 đòn gây choáng đối thủ (*Hit-Stun 0.35s*), hiển thị chữ nảy `2 HITS!`, `3 HITS!`, `COMBO FINISH!`.
* **Minh chứng cụ thể**:
  - **[MC-05]**: Ảnh chụp trận đấu hiển thị chuỗi combo `3 HITS!` và sát thương bạo kích `CRITICAL!`.
  - Trích đoạn code: `_startAttack()` trong `lib/game/components/character_component.dart`.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Cơ chế chiến đấu của game được thiết kế có chiều sâu chiến thuật nhờ thanh Nội Năng Mana và cơ chế Animation Canceling. Người chơi không thể spam chiêu cuối liên tục mà phải dùng đòn đánh thường để tích lũy nội năng. Cửa sổ thời gian hủy chiêu 0.2 giây buộc người chơi phải bấm nhịp nhàng để tạo nên chuỗi liên hoàn 3 đòn gây choáng đối thủ."*

---

### SLIDE 7: TIÊU CHÍ 1.3 (TIẾP) - PHÒNG THỦ, VỠ GIÁP & HIỆU ỨNG CHIẾN TRẬN (GAME FEEL)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - Cơ chế game đa dạng, logic]
* **Nội dung hiển thị trên Slide**:
  - **Cơ chế Đỡ đòn & Phá giáp (Guard & Guard Break)**:
    - Giữ lùi: Kích hoạt khiên thủ thế, **giảm 80% sát thương**, hiện chữ `BLOCKED!`.
    - Bị dồn ép quá 4 đòn liên tiếp: **Vỡ Giáp (Guard Break)**, choáng tê liệt **1.2 giây**, cảnh báo đỏ cam.
  - **Hiệu ứng thị giác đòn đánh (Combat Juice & VFX)**:
    1. *Hit-Stop (0.06s)*: Khựng hình va chạm tạo độ nặng cho nhát chém.
    2. *Screen Shake*: Rung chấn màn hình theo uy lực chiêu thức.
    3. *Damage Flash*: Chớp trắng khi trúng đòn.
    4. *Cinematic K.O. Slow-Mo (0.3x)*: Làm chậm thời gian khi kết liễu trận đấu.
* **Minh chứng cụ thể**:
  - **[MC-04]**: Ảnh chụp khoảnh khắc kích hoạt `BLOCKED!` và `GUARD BREAK!` trên màn hình thi đấu.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Để ngăn lối chơi ôm góc phòng thủ thụ động, chúng em tích hợp cơ chế Phá Giáp (Guard Break). Nếu đối phương đỡ liên tục quá 4 đòn, thế thủ sẽ vỡ nát và bị choáng trong 1.2 giây. Đồng thời, kỹ thuật Hit-Stop 60 mili-giây và hiệu ứng K.O Slow-Motion 0.3x mang lại cảm giác đòn đánh cực kỳ đanh thép và 'đã tay'."*

---

### SLIDE 8: TIÊU CHÍ 2.1 - HỆ THỐNG 8 TƯỚNG & 5 TRƯỜNG PHÁI VÕ THUẬT (HERO ROSTER)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - Có nhiều nhân vật/đối tượng trong game]
* **Nội dung hiển thị trên Slide**:
  - Bảng cân bằng 8 nhân vật thuộc 5 trường phái võ thuật:
    1. *Pháp Sư (Mages)*: Fire Wizard, Lightning Mage, Wanderer Magician (Tầm xa, chiêu thức khủng).
    2. *Đỡ Đòn (Knights)*: Knight Arthur (Máu dày 130 HP, giáp phản đòn).
    3. *Xạ Thủ (Archers)*: Samurai Hayate (Tầm bắn cực xa, tốc độ 220 px/s).
    4. *Đấu Sĩ (Warriors)*: Samurai Nobunaga, Skeleton Krag (Cận chiến càn quét).
    5. *Võ Sĩ Toàn Năng*: Son Goku (Quyền cước tốc độ cao, Kamehameha).
  - Ma trận cân bằng 4 thuộc tính: `ATK`, `DEF`, `SPD`, `RNG`.
* **Minh chứng cụ thể**:
  - **[MC-06]**: Ảnh chụp Giao diện Chọn Tướng (`CharacterSelectScreen`) hiển thị 8 ô tướng và bảng chỉ số chi tiết.
  - File mã nguồn: `lib/constants/hero_roster_data.dart`.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Game sở hữu dàn nhân vật phong phú với 8 vị tướng thuộc 5 trường phái võ thuật rõ rệt: từ Pháp Sư thả diều tầm xa, Kỵ Sĩ giáp sắt trâu bò, Xạ Thủ bắn tỉa cho đến Đấu Sĩ càn quét. Các chỉ số Công, Thủ, Tốc, Tầm xa được cân bằng tỉ mỉ, tạo nên sự khắc chế chiến thuật đa dạng trong từng kèo đấu."*

---

### SLIDE 9: TIÊU CHÍ 2.2 - HỆ THỐNG THỰC THỂ TƯƠNG TÁC & KINH TẾ GAME (ENTITIES & ECONOMY)
* **Thời lượng**: 45 giây
* **Tiêu chí đáp ứng**: [1.0đ - Nhiều đối tượng/vật phẩm, Thế giới lôi cuốn]
* **Nội dung hiển thị trên Slide**:
  - **Các thực thể đạn tầm xa (Projectiles)**:
    - `FireballComponent`: Cầu lửa phát nổ diện rộng ($v_x = 420\text{ px/s}$).
    - `MagicOrbComponent`: Cầu ma thuật bay quỹ đạo lượn sóng hình sin.
    - `ArrowComponent`: Mũi tên tốc độ cao ($v_x = 650\text{ px/s}$).
  - **Kinh tế & Vật phẩm lưu trữ**:
    - *Đồng Vàng Valdris*: Kiếm qua từng hiệp và màn thắng, dùng để mở khóa tướng trong Shop (500 - 3000 xu).
    - *Sao Chiến Dịch*: Đánh giá trình độ (1 - 3 sao).
    - *Ngọc Hiệp Đấu*: 3 viên ngọc chiến công hiển thị trên thanh HUD.
* **Minh chứng cụ thể**:
  - Trích đoạn code va chạm projectile trong `lib/game/components/fireball_component.dart`.
  - **[MC-15]**: Ảnh chụp màn hình Cửa hàng Hero Shop mở khóa tướng bằng tiền vàng.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Hệ thống thực thể trong game không chỉ dừng lại ở đòn đánh cận chiến mà còn có các loại đạn tầm xa với quỹ đạo độc lập như cầu lửa, cầu ma thuật hình sin và mũi tên xuyên phá. Kết hợp với đó là nền kinh tế tích lũy tiền vàng sau mỗi hiệp thắng để mở khóa các vị tướng thần thoại trong Shop."*

---

### SLIDE 10: TIÊU CHÍ 2.3 - THIẾT KẾ CÔNG THÁI HỌC & ĐỒ HỌA DỄ NHÌN (UI/UX ERGONOMICS)
* **Thời lượng**: 45 giây
* **Tiêu chí đáp ứng**: [1.0đ - Đồ họa dễ nhìn, Thế giới lôi cuốn]
* **Nội dung hiển thị trên Slide**:
  - **Bản đồ chiến dịch tương tác (Interactive World Map)**: 7 ải liên kết, hiển thị số sao và thông tin trùm trực quan.
  - **Cụm điều khiển MOBA công thái học**:
    - D-pad bên trái: Hỗ trợ cử chỉ nhấp đúp (*Double-Tap*) để bứt tốc chạy nhanh (`Run`).
    - Cụm 4 phím kỹ năng bên phải: Bố trí theo hình vòng cung tự nhiên theo tầm với ngón cái.
  - **Camera động kéo dài gấp 2.8 lần màn hình (`mapMultiplier = 2.8`)**: Tự động bám theo tọa độ $X$, mở rộng góc nhìn và loại bỏ cảm giác gò bó.
* **Minh chứng cụ thể**:
  - **[MC-07]**: Ảnh chụp Bản đồ 7 ải chiến dịch.
  - **[MC-08]**: Ảnh chụp giao diện trận đấu HUD MOBA và camera bám đuổi.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Giao diện người dùng được thiết kế dựa trên nguyên lý công thái học di động. Các nút bấm xếp theo hình cánh cung tự nhiên của ngón cái, hỗ trợ nhấp đúp chạy nhanh mượt mà. Đặc biệt, camera động mở rộng sàn đấu gấp 2.8 lần màn hình giúp hai nhân vật có không gian bay nhảy, giữ trọng tâm trận đấu luôn cân đối và dễ nhìn."*

---

### SLIDE 11: TIÊU CHÍ 3.1 - GAMEPLAY ĐỐI KHÁNG ĐỘC ĐÁO & 4 CHẾ ĐỘ CHƠI (GAME MODES)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - Gameplay hấp dẫn, độc đáo]
* **Nội dung hiển thị trên Slide**:
  - **4 Chế độ chơi hoàn chỉnh**:
    1. **Chiến Dịch (Campaign Story Gauntlet)**: Vượt 7 ải cốt truyện tử chiến.
    2. **Đấu Nhanh (Quick Versus)**: Tự do chọn tướng và 3 cấp độ AI.
    3. **Đấu Tập (Training Room)**: Hình nộm hồi máu 50 HP/s, thời gian $\infty$, Mana $\times 3$.
    4. **Đấu Mạng LAN PvP thời gian thực**: Kết nối Wi-Fi/Hotspot nội bộ, giao thức **UDP Datagram Socket**, độ trễ $< 20\text{ms}$.
  - **Kỹ thuật đối kháng chuyên sâu**: Căn cự ly (*Spacing*), Lừa đòn trượt (*Whiff Punish*).
* **Minh chứng cụ thể**:
  - **[MC-15]**: Ảnh chụp màn hình sảnh chờ Đấu Mạng LAN PvP (`LanVersusScreen`).
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Trò chơi cung cấp 4 chế độ chơi đáp ứng mọi nhu cầu: từ cốt truyện Chiến dịch, Đấu nhanh với máy, Phòng tập luyện không giới hạn cho đến chế độ Đấu mạng LAN nội bộ. Tính năng Đấu LAN chạy trên giao thức UDP độ trễ cực thấp dưới 20ms, giúp hai người chơi thi đấu đối kháng trực tiếp mượt mà mà không cần kết nối Internet."*

---

### SLIDE 12: TIÊU CHÍ 3.2 - TỐI ƯU HIỆU NĂNG 60 FPS & BÁO CÁO BUILD APK (PERFORMANCE)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - Demo mượt, không giật lag hoặc crash]
* **Nội dung hiển thị trên Slide**:
  - **Hiệu năng 60 FPS ổn định**:
    - Tăng tốc phần cứng GPU **Impeller / Skia**, thời gian xử lý khung hình chỉ $8\text{ms} - 12\text{ms}$ (chuẩn $< 16.6\text{ms}$).
    - **Asset Preloading**: Tải toàn bộ Texture Atlas vào VRAM từ màn hình khởi động, loại bỏ 100% rác bộ nhớ (Zero GC Stutter).
  - **Kết quả Build Release APK thực tế**:
    - `app-arm64-v8a-release.apk`: **107.3 MB** (Thiết bị 64-bit hiện đại).
    - `app-armeabi-v7a-release.apk`: **104.9 MB** (Thiết bị 32-bit cũ).
    - `app-x86_64-release.apk`: **108.6 MB** (Giả lập và máy tính bảng).
    - Mã thoát: `exit code 0` - Không một lỗi crash hay cảnh báo.
* **Minh chứng cụ thể**:
  - **[MC-09]**: Ảnh chụp màn hình Terminal chạy lệnh `flutter build apk --release --split-per-abi` hoàn thành 100%.
  - **[MC-10]**: Video 30s quay màn hình thiết bị thật duy trì 60 FPS liên tục.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Để đảm bảo trải nghiệm thi đấu không gián đoạn, dự án tối ưu hóa sâu phần cứng với Impeller Engine và nạp trước toàn bộ tài nguyên vào VRAM, duy trì đường đồ thị thẳng tắp 60 FPS. Chúng em đã xuất bản thành công bản Release APK độc lập cho 3 kiến trúc vi xử lý với dung lượng tối ưu chỉ khoảng 105MB, khởi chạy tức thì và không xảy ra bất kỳ lỗi crash nào."*

---

### SLIDE 13: TIÊU CHÍ 4.1 - 7 ĐẤU TRƯỜNG BẢN ĐỒ THẾ GIỚI (7 ARENAS ROADMAP)
* **Thời lượng**: 45 giây
* **Tiêu chí đáp ứng**: [1.0đ - Có nhiều cấp độ chơi (levels)/bản đồ (maps)]
* **Nội dung hiển thị trên Slide**:
  - Lộ trình 7 Đấu trường mỹ thuật độc lập:
    - *Map 1*: Rừng Cổ Valdris (`bg1.png`) - Cảnh rừng thông thanh bình (Tân binh).
    - *Map 2*: Hẻm Núi Sa Mạc (`bg5.png`) - Cát đỏ hoàng hôn (Tập sự).
    - *Map 3*: Vực Nham Thạch (`bg3.png`) - Magma sục sôi rực lửa (Chiến binh).
    - *Map 4*: Thung Lũng Mây Ngàn (`bg4.png`) - Đảo nổi thiên giới (Kỳ cựu).
    - *Map 5*: Đỉnh Núi Băng Tuyết (`bg2.png`) - Lâu đài trăng rằm băng giá (Tinh anh).
    - *Map 6*: Pháo Đài Bão Tím (`bg6.png`) - Sấm sét cuồng phong (Bậc thầy).
    - *Map 7*: Đền Cổ Thác Mây (`bg7.png`) - Phong ấn Hư Không (Ác mộng).
* **Minh chứng cụ thể**:
  - Ảnh ghép thumbnail 7 bối cảnh đấu trường pixel art phong phú.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Hệ thống cấp độ đưa người chơi qua 7 bản đồ đấu trường phong cảnh đa dạng: từ Rừng Cổ, Sa Mạc, Miệng Núi Lửa cho tới Đền Cổ Thác Mây. Mỗi đấu trường đều sở hữu bối cảnh Parallax và nhạc nền BGM đặc trưng, phản ánh chính xác hành trình thám hiểm trong cốt truyện."*

---

### SLIDE 14: TIÊU CHÍ 4.2 - THỂ THỨC 3 HIỆP TỬ CHIẾN & MA TRẬN ĐỘ KHÓ 2 CHIỀU (GAUNTLET CHALLENGE)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - Hoàn thành cấp độ chơi có độ khó và thú vị]
* **Nội dung hiển thị trên Slide**:
  - **Quy tắc bắt buộc Thắng 3/3 Round (Must-Win 3 Rounds Gauntlet)**:
    - Người chơi phải thắng liên tục cả 3 Round để qua ải. Thua 1 round bị xử Thua cuộc.
    - Kế thừa khí thế: Hồi 100% HP, **bảo lưu 50% Mana** sang hiệp tiếp theo.
  - **Ma trận toán học nâng độ khó 2 chiều**:
    $$\mathbf{Difficulty} = \mathbf{MapLevel\ (1..7)} \times \mathbf{RoundLevel\ (1..3)}$$
    - Máu NPC tăng từ $1.0\times$ (Map 1) lên tới $2.5\times$ (Map 7 Boss).
    - Phản xạ AI rút ngắn từ $1.2\text{s}$ xuống chớp nhoáng $0.15\text{s}$.
  - **Đánh giá 3 Sao**: Dựa trên tỷ lệ máu còn lại sau Round 3 ($\ge 70\%$ đạt 3 sao).
* **Minh chứng cụ thể**:
  - **[MC-11]**: Ảnh chụp banner chuyển hiệp `ROUND 1`, `ROUND 2`, `FINAL ROUND`.
  - **[MC-12]**: Ảnh chụp Modal Chiến Thắng nảy 3 Sao và cộng tiền vàng.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Độ thử thách của game được đẩy lên cao trào nhờ thể thức 3 Hiệp tử chiến: người chơi bắt buộc phải thắng trọn vẹn cả 3 Round. Độ khó leo thang theo ma trận 2 chiều: đối thủ không chỉ khỏe hơn theo từng Map mà còn 'thức tỉnh' thông minh hơn qua từng Round, mang lại cảm giác chinh phục cực kỳ kịch tính và phấn khích."*

---

### SLIDE 15: TIÊU CHÍ 5.1 - TRÍ TUỆ NHÂN TẠO NPC THÍCH ỨNG (ADAPTIVE AI SYSTEM)
* **Thời lượng**: 1.0 phút
* **Tiêu chí đáp ứng**: [1.0đ - NPC có tính năng thông minh sử dụng AI]
* **Nội dung hiển thị trên Slide**:
  - **Cây quyết định phân tầng của AI**:
    1. **Radar né đạn tầm xa (Projectile Evasion)**: Quét đạn trong cự ly $< 180\text{px}$, tự động kích hoạt nhảy né trên không ($40\% - 85\%$).
    2. **Bộ nhớ nhận diện thói quen (Pattern Recognition Memory)**: Ghi nhận lịch sử đòn đánh (`_opponentAttackHistory`). Nếu người chơi spam 1 chiêu quá 3 lần, AI lập tức tăng **+30%** tỷ lệ nhảy né hoặc thủ thế phản đòn.
    3. **Trừng phạt đòn hụt (Whiff Punish)**: Lao vào dồn combo khi người chơi đánh trượt.
    4. **Ép góc (Corner Pressure) & Chiến thuật theo % Máu**.
* **Minh chứng cụ thể**:
  - **[MC-13]**: Ảnh chụp đoạn code thuật toán AI né đạn tầm xa trong file `lib/game/components/character_component.dart`.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Điểm sáng kỹ thuật của dự án là bộ não NPC AI thích ứng. AI được trang bị radar quét đạn tầm xa để chủ động nhảy né quả cầu lửa đang bay tới; đặc biệt có bộ nhớ nhận diện mẫu hình: nếu người chơi lạm dụng một chiêu quá 3 lần, máy sẽ lập tức 'bắt bài' và phản công trừng phạt, tạo nên một đối thủ thông minh và sống động."*

---

### SLIDE 16: TIÊU CHÍ 5.2 - ĐỘ HOÀN THIỆN CAO CỦA SẢN PHẨM (POLISH & ARCHITECTURE)
* **Thời lượng**: 45 giây
* **Tiêu chí đáp ứng**: [1.0đ - Có độ hoàn thiện cao]
* **Nội dung hiển thị trên Slide**:
  - **Quy trình trải nghiệm khép kín**:
    $$\text{Splash} \rightarrow \text{Home} \rightarrow \text{Map} \rightarrow \text{Hero Select} \rightarrow \text{Battle} \rightarrow \text{Pause/Settings} \rightarrow \text{Victory} \rightarrow \text{Shop}$$
  - **Lưu trữ vĩnh viễn với Hive NoSQL**: Lưu tự động màn chơi cao nhất, số sao, số xu và danh sách tướng mở khóa. Tắt game mở lại giữ nguyên trạng thái.
  - **Hệ thống m Thanh Chuyên Nghiệp**: Tách biệt BGM/SFX, tích hợp bộ lọc chống chồng âm (*Audio Throttle 0.08s*) ngăn rè tiếng, rung phản hồi Haptic khi đánh.
* **Minh chứng cụ thể**:
  - **[MC-14]**: Ảnh chụp Hộp thoại Cài Đặt (Settings Modal) điều chỉnh âm lượng BGM/SFX và rung.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Sản phẩm đạt độ hoàn thiện cao với chu trình trải nghiệm khép kín từ màn hình khởi động đến cửa hàng. Dữ liệu tiến trình được lưu vĩnh viễn bằng Hive NoSQL cực kỳ ổn định. Hệ thống âm thanh được tinh chỉnh phân luồng BGM và SFX độc lập với bộ lọc chống đè tiếng, đem lại cảm giác chỉn chu của một sản phẩm thương mại."*

---

### SLIDE 17: TIÊU CHÍ 5.3 - TIỀM NĂNG THƯƠNG MẠI HÓA (COMMERCIAL VIABILITY)
* **Thời lượng**: 45 giây
* **Tiêu chí đáp ứng**: [1.0đ - Có khả năng thương mại]
* **Nội dung hiển thị trên Slide**:
  - **Vòng lặp kinh tế F2P (Core Loop)**:
    $$\text{Vượt Ải / Thắng Hiệp} \longrightarrow \text{Kiếm Tiền Vàng} \longrightarrow \text{Mở Khóa Tướng Mới} \longrightarrow \text{Chinh Phục Ải Cao Hơn}$$
  - **Mô hình doanh thu sẵn sàng tích hợp**:
    - *Rewarded Video Ads (Google AdMob)*: Xem video 30s hồi sinh tại Round 3 hoặc nhân đôi vàng thưởng.
    - *In-App Purchases (IAP)*: Bán gói tướng thần thoại, gói ngọc và skin.
  - **Ưu thế thị trường**: Dung lượng nhẹ (~105MB), chơi Offline 100% kết hợp Đấu mạng LAN hấp dẫn phân khúc học sinh, sinh viên và văn phòng.
* **Minh chứng cụ thể**:
  - Sơ đồ vòng lặp kinh tế và giao diện Hero Shop trong báo cáo.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Về khả năng thương mại, game sở hữu vòng lặp kinh tế cân bằng, kích thích người chơi cày cuốc mở khóa tướng. Thiết kế sẵn sàng tích hợp quảng cáo Rewarded Video hồi sinh mà không gây ức chế cho người dùng. Khả năng chơi Offline mượt mà kết hợp đấu LAN là lợi thế cạnh tranh rất lớn để tiếp cận phân khúc học đường và giới trẻ."*

---

### SLIDE 18: KẾT LUẬN & KIỂM CHỨNG BAREM ĐIỂM (SUMMARY & Q&A)
* **Thời lượng**: 1.5 phút
* **Nội dung hiển thị trên Slide**:
  - **Bảng đối soát 5 Tiêu Chí Đánh Giá (Đạt chuẩn 5.0 / 5.0)**:
    1. Cốt truyện hấp dẫn, Art Style thống nhất, Cơ chế chiến đấu logic $\rightarrow$ **ĐẠT (1.0/1.0)**
    2. 8 Nhân vật, Thực thể đa dạng, Thế giới lôi cuốn, Đồ họa dễ nhìn $\rightarrow$ **ĐẠT (1.0/1.0)**
    3. Gameplay đối kháng độc đáo, 4 chế độ chơi, Demo 60 FPS không crash $\rightarrow$ **ĐẠT (1.0/1.0)**
    4. 7 Bản đồ phong phú, Thể thức 3 Hiệp tử chiến kịch tính $\rightarrow$ **ĐẠT (1.0/1.0)**
    5. NPC AI thích ứng thông minh, Độ hoàn thiện cao, Có tiềm năng thương mại $\rightarrow$ **ĐẠT (1.0/1.0)**
  - Lời cảm ơn Hội đồng & Mời đặt câu hỏi Q&A.
* **Minh chứng cụ thể**:
  - Sẵn sàng thiết bị chạy bản Release APK để Hội đồng trực tiếp trải nghiệm và kiểm chứng 15 mục minh chứng trong Phụ lục.
* **Lời thoại thuyết trình (Speaker Notes)**:
  > *"Tổng kết lại, sản phẩm 'Chronicles of Valdris' đã đáp ứng toàn diện và vượt mức cả 5 cụm tiêu chí của đồ án từ cốt truyện, mỹ thuật, gameplay 60 FPS cho đến trí tuệ nhân tạo NPC thích ứng. Em xin chân thành cảm ơn quý thầy cô trong Hội đồng đã chú ý lắng nghe. Sau đây, em xin phép kính mời quý thầy cô cùng trải nghiệm bản demo trực tiếp trên thiết bị và đặt câu hỏi cho nhóm chúng em! Xin trân trọng cảm ơn!"*

---

## 📋 BẢNG HƯỚNG DẪN THAO TÁC MINH CHỨNG KHI THUYẾT TRÌNH

| Khi Thuyết Trình Đến | Hành Động Minh Chứng Trực Tiếp Cần Thực Hiện |
| :--- | :--- |
| **Slide 4 (Cốt truyện)** | Mở máy demo $\rightarrow$ Vào Bản đồ $\rightarrow$ Nhấn nút "Sách Cốt Truyện" cho Hội đồng xem dialog chữ tiếng Việt. |
| **Slide 7 (Đỡ đòn & Vỡ giáp)** | Vào trận đấu $\rightarrow$ Giữ phím Lùi cho nhân vật hiện vòng hào quang và chữ `BLOCKED!`. Sau đó dồn ép đối thủ đỡ 4 hit để hiện chữ `GUARD BREAK!`. |
| **Slide 10 (Điều khiển MOBA)** | Thao tác ngón cái nhấp đúp D-pad cho nhân vật bứt tốc chạy nhanh (`Run`) và vung đòn combo hình cánh cung. |
| **Slide 12 (Hiệu năng & APK)** | Mở slide ảnh terminal kết quả `flutter build apk` (3 file APK) và cho Hội đồng xem game chạy 60 FPS không giật lag. |
| **Slide 15 (AI né đạn)** | Chọn Pháp Sư Lửa $\rightarrow$ Tung chiêu bắn cầu lửa từ xa $\rightarrow$ Chỉ cho Hội đồng thấy Boss máy lập tức kích hoạt cú nhảy né trên không. |
| **Slide 18 (Q&A)** | Đưa thiết bị di động có cài sẵn file APK cho thầy cô trực tiếp cầm tay trải nghiệm. |
