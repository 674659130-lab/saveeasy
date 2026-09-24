import 'package:flutter/material.dart';
import 'main.dart';

class SavingsGoal {
  String id;
  String title;
  String emoji;
  double currentAmount;
  double targetAmount;
  Color color;
  bool isCompleted;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.emoji,
    required this.currentAmount,
    required this.targetAmount,
    required this.color,
    this.isCompleted = false,
  });
}

class SavingsTransaction {
  String title;
  String subtitle;
  double amount;
  String emoji;

  SavingsTransaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.emoji,
  });
}

class HomePage extends StatefulWidget {
  final String userName;
  final String loginMethod;

  const HomePage({
    super.key,
    this.userName = 'คุณน้องออม',
    this.loginMethod = 'Email',
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isBalanceVisible = true;
  double _totalSavings = 25450.00;
  int _userExp = 1850;
  int _userLevel = 5;

  late String _currentUserName;
  String _userAvatarEmoji = '🐷';
  String? _profileImageUrl;
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  String _reminderTime = '20:00 น.';

  String _currencySymbol = '฿';
  String _currencyName = 'บาทไทย (THB)';

  @override
  void initState() {
    super.initState();
    _currentUserName = widget.userName;
  }

  final List<SavingsGoal> _goals = [
    SavingsGoal(
      id: '1',
      title: 'ซื้อ iPhone 16 Pro',
      emoji: '📱',
      currentAmount: 22000,
      targetAmount: 35000,
      color: const Color(0xFFFF8DA1),
    ),
    SavingsGoal(
      id: '2',
      title: 'ทริปเที่ยวญี่ปุ่น 🌸',
      emoji: '✈️',
      currentAmount: 18500,
      targetAmount: 20000,
      color: const Color(0xFF9B51E0),
    ),
    SavingsGoal(
      id: '3',
      title: 'กองทุนฉุกเฉินน้องหมู',
      emoji: '🛡️',
      currentAmount: 10000,
      targetAmount: 10000,
      color: const Color(0xFF27AE60),
      isCompleted: true,
    ),
  ];

  final List<SavingsTransaction> _transactions = [
    SavingsTransaction(
      title: 'หยอดกระปุกประจำวัน',
      subtitle: 'วันนี้ • 10:30 น.',
      amount: 200.0,
      emoji: '🐷',
    ),
    SavingsTransaction(
      title: 'ประหยัดค่ากาแฟ',
      subtitle: 'เมื่อวาน • 15:45 น.',
      amount: 60.0,
      emoji: '☕',
    ),
    SavingsTransaction(
      title: 'โบนัสเป้าหมายญี่ปุ่น',
      subtitle: '15 พ.ค. • 09:00 น.',
      amount: 1000.0,
      emoji: '🎯',
    ),
  ];

  Widget _buildAvatarWidget({required double size, required double fontSize}) {
    if (_profileImageUrl != null &&
        _profileImageUrl!.trim().isNotEmpty &&
        _profileImageUrl!.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          _profileImageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFF6B8B),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(_userAvatarEmoji, style: TextStyle(fontSize: fontSize)),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text(_userAvatarEmoji, style: TextStyle(fontSize: fontSize)),
      );
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🐷', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('ออกจากระบบ'),
          ],
        ),
        content: const Text('คุณต้องการออกจากระบบ SaveEasy หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B8B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelectorDialog() {
    final currencies = [
      {'symbol': '฿', 'code': 'THB', 'name': 'บาทไทย (฿ THB)'},
      {'symbol': '\$', 'code': 'USD', 'name': 'ดอลลาร์สหรัฐ (\$ USD)'},
      {'symbol': '€', 'code': 'EUR', 'name': 'ยูโร (€ EUR)'},
      {'symbol': '¥', 'code': 'JPY', 'name': 'เยนญี่ปุ่น (¥ JPY)'},
      {'symbol': '₩', 'code': 'KRW', 'name': 'วอนเกาหลี (₩ KRW)'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('💱', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text('เลือกสกุลเงินหลัก', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final c = currencies[index];
                  final isSelected = _currencySymbol == c['symbol'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? const Color(0xFFFF6B8B) : const Color(0xFFFFF0F3),
                      child: Text(
                        c['symbol']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFFF6B8B),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(c['name']!, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Color(0xFFFF6B8B)) : null,
                    onTap: () {
                      setState(() {
                        _currencySymbol = c['symbol']!;
                        _currencyName = c['name']!;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('เปลี่ยนสกุลเงินเป็น ${c['name']} เรียบร้อยแล้ว 💵✨'),
                          backgroundColor: const Color(0xFFFF6B8B),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet() {
    final nameController = TextEditingController(text: _currentUserName);
    final imageUrlController = TextEditingController(text: _profileImageUrl ?? '');
    final emojis = ['🐷', '🦄', '🐰', '🐼', '🐱', '🦊'];
    String selectedEmoji = _userAvatarEmoji;
    String? tempImageUrl = _profileImageUrl;

    final presetImages = [
      {'name': 'หมูสีชมพู 🌸', 'url': 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=200'},
      {'name': 'ลูกแมวน้อย 🐱', 'url': 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?w=200'},
      {'name': 'สุนัขน่ารัก 🐶', 'url': 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=200'},
      {'name': 'กระต่ายป่า 🐰', 'url': 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=200'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('📸', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text('เปลี่ยนรูปโปรไฟล์ & แก้ไขข้อมูล', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),

                // Avatar Preview
                Center(
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFF0F3),
                      border: Border.all(color: const Color(0xFFFF6B8B), width: 3),
                    ),
                    child: tempImageUrl != null &&
                            tempImageUrl!.trim().isNotEmpty &&
                            tempImageUrl!.startsWith('http')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(48),
                            child: Image.network(
                              tempImageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFFF6B8B),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Text(selectedEmoji, style: const TextStyle(fontSize: 48)),
                              ),
                            ),
                          )
                        : Center(child: Text(selectedEmoji, style: const TextStyle(fontSize: 48))),
                  ),
                ),
                const SizedBox(height: 20),

                const Text('เลือกรูปโปรไฟล์ตัวอย่าง', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),

                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: presetImages.length,
                    itemBuilder: (context, index) {
                      final item = presetImages[index];
                      final url = item['url']!;
                      final isSelected = tempImageUrl == url;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(item['name']!),
                          selected: isSelected,
                          selectedColor: const Color(0xFFFF6B8B),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            setSheetState(() {
                              if (selected) {
                                tempImageUrl = url;
                                imageUrlController.text = url;
                              } else {
                                tempImageUrl = null;
                                imageUrlController.clear();
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                const Text('หรือวางแนบ URL ลิงก์รูปภาพ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: imageUrlController,
                        decoration: InputDecoration(
                          hintText: 'https://example.com/photo.jpg',
                          prefixIcon: const Icon(Icons.link, color: Color(0xFFFF6B8B)),
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setSheetState(() {
                          final text = imageUrlController.text.trim();
                          if (text.isNotEmpty && text.startsWith('http')) {
                            tempImageUrl = text;
                          } else {
                            tempImageUrl = null;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B8B),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('พรีวิว', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Text('เลือกสัญลักษณ์อวตาร (Emoji)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: emojis.map((e) {
                    final isSel = e == selectedEmoji && (tempImageUrl == null || tempImageUrl!.isEmpty);
                    return GestureDetector(
                      onTap: () {
                        setSheetState(() {
                          selectedEmoji = e;
                          tempImageUrl = null;
                          imageUrlController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFFFD6E0) : const Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                          border: Border.all(color: isSel ? const Color(0xFFFF6B8B) : Colors.transparent, width: 2),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),

                const Text('ชื่อโปรไฟล์ของคุณ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'กรอกชื่อโปรไฟล์ของคุณ',
                    filled: true,
                    fillColor: const Color(0xFFF9F9F9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final newName = nameController.text.trim();
                      if (newName.isNotEmpty) {
                        setState(() {
                          _currentUserName = newName;
                          _userAvatarEmoji = selectedEmoji;
                          _profileImageUrl = tempImageUrl;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('เปลี่ยนรูปโปรไฟล์และอัปเดตข้อมูลสำเร็จ! 📸✨'),
                            backgroundColor: Color(0xFFFF6B8B),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B8B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                    ),
                    child: const Text('บันทึกการเปลี่ยนแปลง 💖', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationSettingsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text('🔔', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 8),
                      Text('การแจ้งเตือนออมเงิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _notificationsEnabled,
                activeColor: const Color(0xFFFF6B8B),
                title: const Text('เปิดการแจ้งเตือนเตือนออมเงินประจำวัน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('แจ้งเตือนทุกวันเพื่อรักษาความต่อเนื่องการออม', style: TextStyle(fontSize: 12)),
                onChanged: (val) {
                  setState(() => _notificationsEnabled = val);
                  setSheetState(() {});
                },
              ),
              const Divider(),
              if (_notificationsEnabled) ...[
                const Text('เวลาแจ้งเตือนประจำวัน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: ['08:00 น.', '12:00 น.', '18:00 น.', '20:00 น.'].map((time) {
                    final isSel = time == _reminderTime;
                    return ChoiceChip(
                      label: Text(time),
                      selected: isSel,
                      selectedColor: const Color(0xFFFF6B8B),
                      labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _reminderTime = time);
                          setSheetState(() {});
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgesDialog() {
    final badges = [
      {'emoji': '🥇', 'title': 'ออมวันแรก', 'desc': 'เริ่มต้นออมเงินกับ SaveEasy', 'unlocked': true},
      {'emoji': '🔥', 'title': 'สตรีค 7 วัน', 'desc': 'หยอดกระปุกติดต่อกัน 7 วัน', 'unlocked': true},
      {'emoji': '🎯', 'title': 'เป้าหมายแรกสำเร็จ', 'desc': 'พิชิตเป้าหมายการออม 1 รายการ', 'unlocked': true},
      {'emoji': '👑', 'title': 'Piggy Master', 'desc': 'ยศน้องหมูถึงระดับ Level 5', 'unlocked': true},
      {'emoji': '💎', 'title': 'นักออมหลักแสน', 'desc': 'ยอดเงินออมรวมครบ 100,000 บาท', 'unlocked': false},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('🏆', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text('เหรียญรางวัลเกียรติยศ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  final b = badges[index];
                  final unlocked = b['unlocked'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: unlocked ? const Color(0xFFFFF0F3) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: unlocked ? const Color(0xFFFFD6E0) : Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        Text(b['emoji'] as String, style: TextStyle(fontSize: 28, color: unlocked ? null : Colors.grey)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(b['desc'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Icon(
                          unlocked ? Icons.check_circle_rounded : Icons.lock_rounded,
                          color: unlocked ? const Color(0xFFFF6B8B) : Colors.grey,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🔑', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('เปลี่ยนรหัสผ่าน'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'รหัสผ่านปัจจุบัน',
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'รหัสผ่านใหม่ (อย่างน้อย 6 ตัวอักษร)',
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              if (newPassController.text.length >= 6) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จเรียบร้อย! 🔑✨'), backgroundColor: Color(0xFFFF6B8B)),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B8B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('เปลี่ยนรหัสผ่าน', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddDepositDialog({SavingsGoal? goalTarget}) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🐷', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 8),
                      Text(
                        goalTarget != null
                            ? 'ออมเข้า: ${goalTarget.title}'
                            : 'หยอดกระปุกหมูออม',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'จำนวนเงินที่ต้องการออม',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B8B),
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '$_currencySymbol ',
                  prefixStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B8B),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFFF0F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'บันทึกเพิ่มเติม',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: goalTarget != null ? 'ออมเพิ่มเพื่อเป้าหมาย' : 'เช่น ค่าขนม, ค่ากาแฟวันนี้',
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (amount > 0) {
                      setState(() {
                        _totalSavings += amount;
                        _userExp += (amount / 10).round();
                        if (_userExp >= 2000) {
                          _userLevel += 1;
                          _userExp -= 2000;
                        }

                        if (goalTarget != null) {
                          goalTarget.currentAmount += amount;
                          if (goalTarget.currentAmount >= goalTarget.targetAmount) {
                            goalTarget.isCompleted = true;
                          }
                        }

                        final noteText = noteController.text.trim();
                        _transactions.insert(
                          0,
                          SavingsTransaction(
                            title: goalTarget != null ? 'ออมเข้า ${goalTarget.title}' : (noteText.isNotEmpty ? noteText : 'หยอดกระปุกหมู'),
                            subtitle: 'วันนี้ • เมื่อครู่นี้',
                            amount: amount,
                            emoji: goalTarget != null ? goalTarget.emoji : '🐷',
                          ),
                        );
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('หยอดกระปุกสำเร็จ +$_currencySymbol${amount.toStringAsFixed(2)} 🐷🎉'),
                          backgroundColor: const Color(0xFFFF6B8B),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B8B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'บันทึกการออม',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    String selectedEmoji = '🎁';

    final emojis = ['🎁', '📱', '✈️', '🚗', '🏠', '💻', '🎮', '🎓', '💍'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Row(
                children: [
                  Text('🎯', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text('สร้างเป้าหมายการออมใหม่'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('เลือกสัญลักษณ์ (Emoji)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: emojis.map((e) {
                        final isSelected = e == selectedEmoji;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedEmoji = e;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFD6E0) : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFF6B8B) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(e, style: const TextStyle(fontSize: 22)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('ชื่อเป้าหมาย', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'เช่น ตั๋วคอนเสิร์ต, โน้ตบุ๊กใหม่',
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('เป้าหมายจำนวนเงิน', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: targetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '10,000',
                        prefixText: '$_currencySymbol ',
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final target = double.tryParse(targetController.text) ?? 0.0;

                    if (title.isNotEmpty && target > 0) {
                      setState(() {
                        _goals.add(
                          SavingsGoal(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: title,
                            emoji: selectedEmoji,
                            currentAmount: 0,
                            targetAmount: target,
                            color: const Color(0xFFFF6B8B),
                          ),
                        );
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('สร้างเป้าหมาย "$title" สำเร็จแล้ว! 🎯✨'),
                          backgroundColor: const Color(0xFFFF6B8B),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B8B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('สร้างเป้าหมาย', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showQuestsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text('🎁', style: TextStyle(fontSize: 28)),
                      SizedBox(width: 8),
                      Text(
                        'ภารกิจน้องหมูรับรางวัล',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildQuestTile(
                title: 'หยอดกระปุกประจำวัน',
                desc: 'หยอดเงินออมอย่างน้อย 1 ครั้งวันนี้',
                reward: '+50 EXP',
                isDone: true,
              ),
              const SizedBox(height: 10),
              _buildQuestTile(
                title: 'สร้างเป้าหมายแรกของคุณ',
                desc: 'กำหนดเป้าหมายออมเงินเพื่ออนาคต',
                reward: '+100 EXP',
                isDone: _goals.isNotEmpty,
              ),
              const SizedBox(height: 10),
              _buildQuestTile(
                title: 'ออมเงินติดต่อกัน 3 วัน',
                desc: 'รักษาวินัยการออมอย่างต่อเนื่อง',
                reward: '+150 EXP',
                isDone: false,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestTile({
    required String title,
    required String desc,
    required String reward,
    required bool isDone,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD6E0), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isDone
                ? null
                : () {
                    setState(() {
                      _userExp += 50;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('รับรางวัลเรียบร้อย! +50 EXP 🎁✨'),
                        backgroundColor: Color(0xFFFF6B8B),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDone ? Colors.grey[300] : const Color(0xFFFF6B8B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isDone ? 'รับแล้ว' : reward,
              style: TextStyle(
                color: isDone ? Colors.grey[600] : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex == 2 ? 0 : _selectedIndex,
          children: [
            _buildHomeTab(),
            _buildGoalsTab(),
            _buildHomeTab(),
            _buildStatsTab(),
            _buildProfileTab(),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B8B).withOpacity(0.12),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 2) {
                _showAddDepositDialog();
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFFF6B8B),
            unselectedItemColor: const Color(0xFFB0B0B0),
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'หน้าหลัก',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_rounded),
                label: 'เป้าหมาย',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B8B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                label: 'หยอดกระปุก',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_rounded),
                label: 'สถิติ',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'โปรไฟล์',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB 0: HOME TAB ---
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _showEditProfileSheet,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFF0F3),
                        border: Border.all(color: const Color(0xFFFF6B8B), width: 2),
                      ),
                      child: _buildAvatarWidget(size: 50, fontSize: 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _showEditProfileSheet,
                        child: Row(
                          children: [
                            Text(
                              'สวัสดี, $_currentUserName 👋',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.edit_outlined, size: 14, color: Color(0xFFFF6B8B)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Piggy Saver Lv. $_userLevel 🏆',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFF6B8B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4E1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.loginMethod,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD81B60),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: _handleLogout,
                tooltip: 'ออกจากระบบ',
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFFF6B8B),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Total Savings Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B8B), Color(0xFFFF8DA1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B8B).withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ยอดเงินออมรวมทั้งหมด',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      child: Icon(
                        _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isBalanceVisible ? '$_currencySymbol ${_totalSavings.toStringAsFixed(2)}' : '$_currencySymbol ••••••••',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'เป้าหมายเดือนนี้ ($_currencySymbol 30,000)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            '85%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.85,
                          minHeight: 8,
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.add_circle_outline_rounded,
                label: 'หยอดกระปุก',
                color: const Color(0xFFFF6B8B),
                onTap: () => _showAddDepositDialog(),
              ),
              _buildActionButton(
                icon: Icons.flag_outlined,
                label: 'สร้างเป้าหมาย',
                color: const Color(0xFF9B51E0),
                onTap: _showAddGoalDialog,
              ),
              _buildActionButton(
                icon: Icons.bar_chart_rounded,
                label: 'สรุปสถิติ',
                color: const Color(0xFF2F80ED),
                onTap: () => setState(() => _selectedIndex = 3),
              ),
              _buildActionButton(
                icon: Icons.card_giftcard_rounded,
                label: 'ภารกิจหมู',
                color: const Color(0xFFF2994A),
                onTap: _showQuestsDialog,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Savings Goals Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'เป้าหมายการออม',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 1),
                child: const Text('ดูทั้งหมด', style: TextStyle(color: Color(0xFFFF6B8B), fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ..._goals.map((goal) => Column(
                children: [
                  _buildGoalCardItem(goal),
                  const SizedBox(height: 12),
                ],
              )),

          const SizedBox(height: 20),

          // Transactions Summary
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ประวัติการออมล่าสุด',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ..._transactions.map((tx) => _buildTransactionTile(
                title: tx.title,
                subtitle: tx.subtitle,
                amount: '+$_currencySymbol ${tx.amount.toStringAsFixed(2)}',
                emoji: tx.emoji,
              )),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- TAB 1: GOALS TAB ---
  Widget _buildGoalsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'เป้าหมายการออม 🎯',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
              ElevatedButton.icon(
                onPressed: _showAddGoalDialog,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('สร้างเป้าหมาย', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B8B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'ตั้งเป้าหมายแล้วเริ่มหยอดกระปุกเพื่อฝันของคุณ!',
            style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
          ),
          const SizedBox(height: 20),

          ..._goals.map((goal) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildGoalCardItem(goal, showDepositButton: true),
              )),
        ],
      ),
    );
  }

  // --- TAB 3: STATS TAB ---
  Widget _buildStatsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'สถิติการออม 📊',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          const Text('วิเคราะห์วินัยทางการเงินและยอดออมสะสมของคุณ', style: TextStyle(fontSize: 14, color: Color(0xFF777777))),
          const SizedBox(height: 20),

          // Overview Stats Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('ออมเดือนนี้', '$_currencySymbol 8,450', const Color(0xFFFF6B8B)),
                Container(width: 1, height: 40, color: Colors.grey[200]),
                _buildStatItem('เฉลี่ย/วัน', '$_currencySymbol 281', const Color(0xFF9B51E0)),
                Container(width: 1, height: 40, color: Colors.grey[200]),
                _buildStatItem('ออมต่อเนื่อง', '14 วัน 🔥', const Color(0xFFF2994A)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bar Chart Simulation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('กราฟการออมสัปดาห์นี้', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBarChartColumn('จ', 120, false),
                    _buildBarChartColumn('อ', 80, false),
                    _buildBarChartColumn('พ', 150, false),
                    _buildBarChartColumn('พฤ', 200, false),
                    _buildBarChartColumn('ศ', 90, false),
                    _buildBarChartColumn('ส', 300, true),
                    _buildBarChartColumn('อา', 250, true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: PROFILE TAB ---
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Avatar & EXP Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF6B8B).withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                // Whole Avatar Circle Clickable!
                GestureDetector(
                  onTap: _showEditProfileSheet,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFF0F3),
                          border: Border.all(color: const Color(0xFFFF6B8B), width: 3),
                        ),
                        child: _buildAvatarWidget(size: 90, fontSize: 48),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B8B),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Dedicated Button to Change Photo
                OutlinedButton.icon(
                  onPressed: _showEditProfileSheet,
                  icon: const Icon(Icons.photo_camera_outlined, size: 16, color: Color(0xFFFF6B8B)),
                  label: const Text('เปลี่ยนรูปโปรไฟล์', style: TextStyle(color: Color(0xFFFF6B8B), fontWeight: FontWeight.bold, fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF6B8B), width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: _showEditProfileSheet,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentUserName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.edit_outlined, size: 18, color: Color(0xFFFF6B8B)),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'เข้าสู่ระบบผ่าน: ${widget.loginMethod}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFFFF6B8B), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // EXP Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Piggy Saver Lv. $_userLevel 🏆', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('$_userExp / 2000 EXP', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_userExp / 2000).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: const Color(0xFFFFF0F3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B8B)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Badges / Achievements Shortcut
          InkWell(
            onTap: _showBadgesDialog,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFD6E0)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('🏆', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('เหรียญรางวัล & เกียรติยศ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('ปลดล็อกแล้ว 4 / 5 เหรียญ', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFFF6B8B)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Settings List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.monetization_on_outlined, color: Color(0xFFFF6B8B)),
                  title: const Text('เลือกสกุลเงินหลัก'),
                  subtitle: Text(_currencyName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: _showCurrencySelectorDialog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFFFF6B8B)),
                  title: const Text('การแจ้งเตือนเตือนออมเงิน'),
                  subtitle: Text(_notificationsEnabled ? 'เปิดอยู่ ($_reminderTime)' : 'ปิดอยู่', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: _showNotificationSettingsDialog,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded, color: Color(0xFF9B51E0)),
                  title: const Text('สแกนลายนิ้วมือ / Face ID'),
                  activeColor: const Color(0xFFFF6B8B),
                  value: _biometricsEnabled,
                  onChanged: (val) {
                    setState(() => _biometricsEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val ? 'เปิดใช้งานระบบยืนยันตัวตนชีวมิติเรียบร้อย 🔒' : 'ปิดการใช้งานระบบยืนยันตัวตนชีวมิติแล้ว'),
                        backgroundColor: const Color(0xFFFF6B8B),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_reset_rounded, color: Color(0xFF2F80ED)),
                  title: const Text('เปลี่ยนรหัสผ่าน'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: _showChangePasswordDialog,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout_rounded, color: Color(0xFFFF6B8B)),
              label: const Text('ออกจากระบบ', style: TextStyle(color: Color(0xFFFF6B8B), fontSize: 16, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6B8B), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBarChartColumn(String day, double height, bool isHighlight) {
    return Column(
      children: [
        Container(
          width: 16,
          height: height / 2.5,
          decoration: BoxDecoration(
            color: isHighlight ? const Color(0xFFFF6B8B) : const Color(0xFFFFD6E0),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCardItem(SavingsGoal goal, {bool showDepositButton = false}) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(goal.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              if (goal.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27AE60).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'สำเร็จแล้ว! 🎉',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27AE60),
                    ),
                  ),
                )
              else
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: goal.color,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation<Color>(goal.color),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'สะสมแล้ว: $_currencySymbol ${goal.currentAmount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
              ),
              Text(
                'เป้าหมาย: $_currencySymbol ${goal.targetAmount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
              ),
            ],
          ),
          if (showDepositButton && !goal.isCompleted) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton.icon(
                onPressed: () => _showAddDepositDialog(goalTarget: goal),
                icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                label: const Text('ออมเพิ่มเข้าเป้าหมายนี้', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: goal.color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionTile({
    required String title,
    required String subtitle,
    required String amount,
    required String emoji,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF27AE60),
            ),
          ),
        ],
      ),
    );
  }
}
