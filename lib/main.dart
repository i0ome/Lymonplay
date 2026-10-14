import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

// =============================================================
//  الإعدادات الثابتة والبيانات الخاصة بالبرنامج (ZegoCloud)
// =============================================================
const int zegoAppID = 123456789; // استبدلها برقم AppID الخاص بك من ZegoCloud
const String zegoAppSign = "YOUR_ZEGOCLOUD_APP_SIGN_HERE"; // استبدلها بـ AppSign الخاص بك

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

  void _openPermanentRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioRoomScreen(
          roomID: "Permanent_${widget.userName}",
          roomTitle: "روم ${widget.userName} الدائم 👑",
          userName: widget.userName,
          isVerifiedAdmin: widget.isVerifiedAdmin,
          currentCoins: coins,
          currentKarma: karma,
          onUserDataUpdated: (newCoins, newKarma) {
            setState(() {
              coins = newCoins;
              karma = newKarma;
            });
          },
        ),
      ),
    );
  }

  void _openTemporaryRoom() {
    final roomName = _tempRoomController.text.trim();
    if (roomName.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioRoomScreen(
          roomID: roomName,
          roomTitle: "روم مؤقت: $roomName",
          userName: widget.userName,
          isVerifiedAdmin: widget.isVerifiedAdmin,
          currentCoins: coins,
          currentKarma: karma,
          onUserDataUpdated: (newCoins, newKarma) {
            setState(() {
              coins = newCoins;
              karma = newKarma;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text("$coins", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF1E222D),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: widget.isVerifiedAdmin ? Colors.amber : Colors.purple,
                          child: Text(
                            widget.userName[0].toUpperCase(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(widget.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                if (widget.isVerifiedAdmin) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.check_circle, color: Colors.amber, size: 20),
                                ]
                              ],
                            ),
                            Text(widget.userEmail, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text("Lv. $userLevel", style: const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text("نقاط الكاريزما", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text("✨ $karma", style: const TextStyle(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("النجوم (1000/⭐)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text("⭐ $starsCount", style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E222D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: hasPermanentRoom ? Colors.amber : Colors.grey.shade800),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("👑 روم الملكية الدائم للأبد", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                  const SizedBox(height: 8),
                  Text(
                    hasPermanentRoom ? "لديك روم دائم خاص بك ومحفوظ في حسابك للأبد." : "امتلك روم دائم للأبد في حسابك بـ 6666 عملة فقط.",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  hasPermanentRoom
                      ? ElevatedButton.icon(
                          icon: const Icon(Icons.star, color: Colors.black),
                          label: const Text('دخول الروم الدائم (مجاني)', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 45)),
                          onPressed: _openPermanentRoom,
                        )
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_cart, color: Colors.black),
                          label: const Text('شراء روم دائم للأبد (6666 عملة)', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 45)),
                          onPressed: _buyPermanentRoom,
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E222D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("⏳ فتح روم مؤقت (مجاني)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.cyan)),
                  const SizedBox(height: 8),
                  const Text("روم مؤقت يختفي تماماً فور خروجك منه.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tempRoomController,
                    decoration: const InputDecoration(
                      labelText: 'اسم الروم المؤقت',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.meeting_room, color: Colors.black),
                    label: const Text('دخول روم مؤقت مجاني', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, minimumSize: const Size(double.infinity, 45)),
                    onPressed: _openTemporaryRoom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
//  3. شاشة الروم الصوتية عبر ZegoCloud
// =============================================================
class AudioRoomScreen extends StatefulWidget {
  final String roomID;
  final String roomTitle;
  final String userName;
  final bool isVerifiedAdmin;
  final int currentCoins;
  final int currentKarma;
  final Function(int newCoins, int newKarma) onUserDataUpdated;

  const AudioRoomScreen({
    super.key,
    required this.roomID,
    required this.roomTitle,
    required this.userName,
    required this.isVerifiedAdmin,
    required this.currentCoins,
    required this.currentKarma,
    required this.onUserDataUpdated,
  });

  @override
  State<AudioRoomScreen> createState() => _AudioRoomScreenState();
}

class _AudioRoomScreenState extends State<AudioRoomScreen> {
  late int myCoins;
  late int myKarma;

  @override
  void initState() {
    super.initState();
    myCoins = widget.currentCoins;
    myKarma = widget.currentKarma;
  }

  void _sendGift(GiftItem gift) {
    if (myCoins < gift.priceInCoins && !widget.isVerifiedAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رصيد العملات غير كافٍ!')),
      );
      return;
    }

    setState(() {
      if (!widget.isVerifiedAdmin) {
        myCoins -= gift.priceInCoins;
      }
      myKarma += gift.karmaValue;
    });

    widget.onUserDataUpdated(myCoins, myKarma);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.purple,
        content: Text('🎁 أرسلت ${gift.name} ${gift.icon} (+${gift.karmaValue} كاريزما)'),
      ),
    );
  }

  void _openAdminDistributePanel() {
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.amber),
                SizedBox(width: 8),
                Text("لوحة توزيع العملات الإدارية (Lymon)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'عدد العملات المراد إضافتها',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final amount = int.tryParse(amountController.text) ?? 0;
                if (amount > 0) {
                  setState(() {
                    myCoins += amount;
                  });
                  widget.onUserDataUpdated(myCoins, myKarma);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم إضافة $amount عملة بنجاح!')),
                  );
                }
              },
              child: const Text('طباعة وتوزيع الآن', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }

  void _openGiftsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222D),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 380,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "متجر الهدايا (كل 5 عملات = 1 كاريزما)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: allGifts.length,
                itemBuilder: (context, index) {
                  final gift = allGifts[index];
                  return GestureDetector(
                    onTap: () => _sendGift(gift),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(gift.icon, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(gift.name, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.monetization_on, size: 10, color: Colors.amber),
                              Text(" ${gift.priceInCoins}", style: const TextStyle(fontSize: 10, color: Colors.amber)),
                            ],
                          )
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
    // تمييز اسم الأدمن بالصح الأصفر تلقائياً داخل الروم
    final String displayName = widget.isVerifiedAdmin ? "${widget.userName} 🟡" : widget.userName;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomTitle),
        actions: [
          if (widget.isVerifiedAdmin)
            IconButton(
              icon: const Icon(Icons.add_moderator, color: Colors.amber),
              onPressed: _openAdminDistributePanel,
            ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.amber),
            onPressed: _openGiftsMenu,
          ),
        ],
      ),
      body: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: zegoAppID,
        appSign: zegoAppSign,
        userID: widget.userName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_'),
        userName: displayName,
        roomID: widget.roomID,
        config: ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
          ..takeSeatIndexWhenJoining = 0
          ..hostSeatIndexes = [0],
      ),
    );
  }
}
