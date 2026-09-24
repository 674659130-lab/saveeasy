import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart';

void main() {
  runApp(const SaveEasyApp());
}

class SaveEasyApp extends StatelessWidget {
  const SaveEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaveEasy - แอปออมเงิน',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B8B),
          primary: const Color(0xFFFF6B8B),
          secondary: const Color(0xFFFF8DA1),
          surface: const Color(0xFFFFF5F7),
        ),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFFD6E0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF6B8B), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  late AnimationController _piggyAnimController;
  late Animation<double> _coinBounceAnimation;

  @override
  void initState() {
    super.initState();
    _piggyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _coinBounceAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(
        parent: _piggyAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _piggyAnimController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        final inputEmail = _emailController.text.trim();
        final userName = inputEmail.contains('@')
            ? inputEmail.split('@')[0]
            : inputEmail;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text('เข้าสู่ระบบสำเร็จ! ยินดีต้อนรับกลับมา คุณ $userName 🐷'),
              ],
            ),
            backgroundColor: const Color(0xFFFF6B8B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: userName,
              loginMethod: 'Email',
            ),
          ),
        );
      }
    }
  }

  void _handleSocialAuth(String provider, String defaultName, Color brandColor) {
    final nameController = TextEditingController(text: defaultName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
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
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: brandColor.withOpacity(0.15),
                  child: const Text('🐷', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เข้าสู่ระบบด้วย $provider',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'เชื่อมต่อบัญชี $provider เพื่อใช้งาน SaveEasy',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('ชื่อบัญชีผู้ใช้งานของคุณ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'กรอกชื่อบัญชี $provider',
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final userName = nameController.text.trim().isNotEmpty
                      ? nameController.text.trim()
                      : defaultName;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('เข้าสู่ระบบสำเร็จผ่าน $provider! ยินดีต้อนรับคุณ $userName 🐷✨'),
                      backgroundColor: const Color(0xFFFF6B8B),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        userName: userName,
                        loginMethod: provider,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: Text(
                  'ดำเนินการต่อด้วย $provider',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F5),
              Color(0xFFFFE4E1),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Animated Piggy Bank Header
                AnimatedBuilder(
                  animation: _coinBounceAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(140, 140),
                      painter: PiggyBankPainter(coinOffsetY: _coinBounceAnimation.value),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // App Name & Subtitle
                const Text(
                  'SaveEasy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD81B60),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ออมง่ายๆ กับน้องหมูเซฟออม',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF8E44AD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('🐷💰', style: TextStyle(fontSize: 16)),
                  ],
                ),

                const SizedBox(height: 32),

                // Card Container for Form
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B8B).withOpacity(0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Username / Email Input
                        const Text(
                          'อีเมล หรือ ชื่อผู้ใช้งาน',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'example@email.com',
                            prefixIcon: Icon(Icons.person_outline, color: Color(0xFFFF6B8B)),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'กรุณากรอกอีเมลหรือชื่อผู้ใช้งาน';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Password Input
                        const Text(
                          'รหัสผ่าน',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF6B8B)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFFFF94A8),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกรหัสผ่าน';
                            }
                            if (value.length < 6) {
                              return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: const Color(0xFFFF6B8B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'จดจำฉันไว้',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ระบบจะส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของคุณ'),
                                    backgroundColor: Color(0xFFFF8DA1),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'ลืมรหัสผ่าน?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF6B8B),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFFFF6B8B).withOpacity(0.4),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B8B),
                                    Color(0xFFFF8E53),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        'เข้าสู่ระบบ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Color(0xFFFFD6E0), thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'หรือเข้าสู่ระบบด้วย',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFFFD6E0), thickness: 1)),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Social Logins (Google, Facebook, LINE, Apple)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSocialButton(
                              icon: Icons.g_mobiledata_rounded,
                              iconColor: Colors.redAccent,
                              label: 'Google',
                              onTap: () => _handleSocialAuth('Google', 'คุณ Google Saver', Colors.redAccent),
                            ),
                            _buildSocialButton(
                              icon: Icons.facebook_rounded,
                              iconColor: const Color(0xFF1877F2),
                              label: 'Facebook',
                              onTap: () => _handleSocialAuth('Facebook', 'คุณ Facebook Saver', const Color(0xFF1877F2)),
                            ),
                            _buildSocialButton(
                              icon: Icons.chat_bubble_outline_rounded,
                              iconColor: const Color(0xFF00B900),
                              label: 'LINE',
                              onTap: () => _handleSocialAuth('LINE', 'คุณ LINE Saver', const Color(0xFF00B900)),
                            ),
                            _buildSocialButton(
                              icon: Icons.apple,
                              iconColor: Colors.black87,
                              label: 'Apple',
                              onTap: () => _handleSocialAuth('Apple', 'คุณ Apple Saver', Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ยังไม่มีบัญชี SaveEasy ใช่ไหม? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD81B60),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 68,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD6E0), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter for drawing a cute Piggy Bank with floating Coin
class PiggyBankPainter extends CustomPainter {
  final double coinOffsetY;

  PiggyBankPainter({required this.coinOffsetY});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);

    // 1. Piggy Body Gradient & Shadow
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFB7C5), // Light Pink
          Color(0xFFFF7597), // Vibrant Pink
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: 45));

    final bodyShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Ground Shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 42),
        width: 80,
        height: 16,
      ),
      bodyShadowPaint,
    );

    // Piggy Feet
    final footPaint = Paint()..color = const Color(0xFFFF5C83);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - 32, center.dy + 25, 14, 18),
        const Radius.circular(6),
      ),
      footPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx + 18, center.dy + 25, 14, 18),
        const Radius.circular(6),
      ),
      footPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - 18, center.dy + 28, 12, 16),
        const Radius.circular(6),
      ),
      footPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx + 6, center.dy + 28, 12, 16),
        const Radius.circular(6),
      ),
      footPaint,
    );

    // Main Piggy Body
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 95, height: 80),
      bodyPaint,
    );

    // Ears
    final earOuterPaint = Paint()..color = const Color(0xFFFF7597);
    final earInnerPaint = Paint()..color = const Color(0xFFFFD6E0);

    // Left Ear
    final leftEarPath = Path()
      ..moveTo(center.dx - 36, center.dy - 22)
      ..quadraticBezierTo(center.dx - 48, center.dy - 48, center.dx - 22, center.dy - 34)
      ..close();
    canvas.drawPath(leftEarPath, earOuterPaint);

    final leftEarInner = Path()
      ..moveTo(center.dx - 34, center.dy - 24)
      ..quadraticBezierTo(center.dx - 42, center.dy - 42, center.dx - 24, center.dy - 32)
      ..close();
    canvas.drawPath(leftEarInner, earInnerPaint);

    // Right Ear
    final rightEarPath = Path()
      ..moveTo(center.dx + 36, center.dy - 22)
      ..quadraticBezierTo(center.dx + 48, center.dy - 48, center.dx + 22, center.dy - 34)
      ..close();
    canvas.drawPath(rightEarPath, earOuterPaint);

    final rightEarInner = Path()
      ..moveTo(center.dx + 34, center.dy - 24)
      ..quadraticBezierTo(center.dx + 42, center.dy - 42, center.dx + 24, center.dy - 32)
      ..close();
    canvas.drawPath(rightEarInner, earInnerPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx - 20, center.dy - 8), 4.5, eyePaint);
    canvas.drawCircle(Offset(center.dx - 21.5, center.dy - 9.5), 1.5, Paint()..color = Colors.white);

    canvas.drawCircle(Offset(center.dx + 20, center.dy - 8), 4.5, eyePaint);
    canvas.drawCircle(Offset(center.dx + 18.5, center.dy - 9.5), 1.5, Paint()..color = Colors.white);

    // Blushing Cheeks
    final cheekPaint = Paint()
      ..color = const Color(0xFFFF4081).withOpacity(0.35);
    canvas.drawCircle(Offset(center.dx - 28, center.dy + 4), 6, cheekPaint);
    canvas.drawCircle(Offset(center.dx + 28, center.dy + 4), 6, cheekPaint);

    // Snout / Nose
    final snoutPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF94A8), Color(0xFFFF5C83)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCenter(
        center: Offset(center.dx, center.dy + 6),
        width: 32,
        height: 24,
      ));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + 6),
          width: 32,
          height: 24,
        ),
        const Radius.circular(12),
      ),
      snoutPaint,
    );

    // Nostrils
    final nostrilPaint = Paint()..color = const Color(0xFFD81B60);
    canvas.drawCircle(Offset(center.dx - 6, center.dy + 6), 3, nostrilPaint);
    canvas.drawCircle(Offset(center.dx + 6, center.dy + 6), 3, nostrilPaint);

    // Coin Slot
    final slotPaint = Paint()
      ..color = const Color(0xFFD81B60)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(center.dx - 12, center.dy - 35),
      Offset(center.dx + 12, center.dy - 35),
      slotPaint,
    );

    // 2. Floating Golden Coin
    final coinCenter = Offset(center.dx, center.dy - 55 + coinOffsetY);

    final coinShadow = Paint()
      ..color = Colors.amber.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(coinCenter, 16, coinShadow);

    final coinPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: coinCenter, radius: 15));

    canvas.drawCircle(coinCenter, 15, coinPaint);

    // Inner Ring
    final coinRingPaint = Paint()
      ..color = const Color(0xFFFF8F00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(coinCenter, 11, coinRingPaint);

    // Baht Symbol
    const textSpan = TextSpan(
      text: '฿',
      style: TextStyle(
        color: Color(0xFF7F4F00),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(coinCenter.dx - textPainter.width / 2, coinCenter.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant PiggyBankPainter oldDelegate) {
    return oldDelegate.coinOffsetY != coinOffsetY;
  }
}
