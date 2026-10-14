import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

// =============================================================
//  الإعدادات الثابتة والبيانات الخاصة بالبرنامج (Agora)
// =============================================================
const String agoraAppId = "9117c14488754e2aa06fc5ed56e32e5c";

const String adminEmail = "mmaymanmm2020@gmail.com";
const String adminPassword = "Mmaymanmm2020";

class GiftItem {
  final String id;
  final String name;
  final String icon;
  final int priceInCoins;

  GiftItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.priceInCoins,
  });

  int get karmaValue => (priceInCoins / 5).floor();
}

final List<GiftItem> allGifts = [
  GiftItem(id: '1', name: 'وردة', icon: '🌹', priceInCoins: 5),
  GiftItem(id: '2', name: 'قلب', icon: '❤️', priceInCoins: 10),
  GiftItem(id: '3', name: 'قهوة', icon: '☕', priceInCoins: 25),
  GiftItem(id: '4', name: 'خاتم', icon: '💍', priceInCoins: 50),
  GiftItem(id: '5', name: 'تاج', icon: '👑', priceInCoins: 100),
  GiftItem(id: '6', name: 'سيارة', icon: '🏎️', priceInCoins: 250),
  GiftItem(id: '7', name: 'طائرة', icon: '🛩️', priceInCoins: 500),
  GiftItem(id: '8', name: 'قلعة', icon: '🏰', priceInCoins: 1000),
  GiftItem(id: '9', name: 'صاروخ', icon: '🚀', priceInCoins: 2500),
  GiftItem(id: '10', name: 'كوكب', icon: '🪐', priceInCoins: 5000),
  GiftItem(id: '11', name: 'تنين', icon: '🐉', priceInCoins: 10000),
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WePlayAudioApp());
}

class WePlayAudioApp extends StatelessWidget {
  const WePlayAudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WePlay Voice Rooms',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111319),
        primaryColor: Colors.amber,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E222D),
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// =============================================================
//  1. شاشة تسجيل الدخول
// =============================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAdminEmail = false;

  void _login() {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال البريد والاسم')),
      );
      return;
    }

    bool isVerifiedAdmin = false;

    if (email.toLowerCase() == adminEmail.toLowerCase()) {
      if (password != adminPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('رمز الإدارة غير صحيح!')),
        );
        return;
      }
      isVerifiedAdmin = true;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainDashboardScreen(
          userName: isVerifiedAdmin ? "Lymon" : name,
          userEmail: email,
          isVerifiedAdmin: isVerifiedAdmin,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars_rounded, size: 90, color: Colors.amber),
              const SizedBox(height: 12),
              const Text(
                "تطبيق الغرف الصوتية والكاريزما",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                onChanged: (val) {
                  setState(() {
                    _isAdminEmail = val.trim().toLowerCase() == adminEmail.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              if (_isAdminEmail) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'رمز الإدارة المخفي',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.amber),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
//  2. الشاشة الرئيسية وإدارة الروم الدائم والمؤقت
// =============================================================
class MainDashboardScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final bool isVerifiedAdmin;

  const MainDashboardScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.isVerifiedAdmin,
  });

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  late int coins;
  int karma = 0;
  bool hasPermanentRoom = false;
  final _tempRoomController = TextEditingController(text: "Temp_Room_1");

  @override
  void initState() {
    super.initState();
    coins = widget.isVerifiedAdmin ? 9999999 : 10000;
    hasPermanentRoom = widget.isVerifiedAdmin;
  }

  int get starsCount => (karma / 1000).floor();
  int get userLevel => 1 + (karma / 200).floor();

  void _buyPermanentRoom() {
    const int permanentRoomCost = 6666;
    if (coins < permanentRoomCost && !widget.isVerifiedAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رصيدك لا يكفي! شراء الروم الدائم يتطلب 6666 عملة')),
      );
      return;
    }

    setState(() {
      if (!widget.isVerifiedAdmin) {
        coins -= permanentRoomCost;
      }
      hasPermanentRoom = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('🎉 مبروك! تمتلك الآن رواعاً دائماً للأبد في حسابك'),
      ),
    );
  }

  void _openPermanentRoom() async {
    await Permission.microphone.request();
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
