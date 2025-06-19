import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulusalbarter/sifremiunuttum.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'appDrawer.dart';
import 'dashboard.dart';
import 'firebase_options.dart';
import 'kayit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.initialize("d4f432ca-d0cc-4d13-873d-b24b41de5699"); // <-- buraya App ID'yi gir

  OneSignal.Notifications.requestPermission(true);
  // await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: "https://rprxugnzyglgmrsubekc.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwcnh1Z256eWdsZ21yc3ViZWtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgyODY4MzMsImV4cCI6MjA2Mzg2MjgzM30.JLUshxRgPcyvvU_OQsdj-jou8CAlZXBwCJ0Hg-XO9xo",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Splash Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(), // ilk açılışta Splash gösterilecek
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------------- Splash Screen ----------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();

    // build tamamlandıktan sonra yönlendir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengi
      body: Center(
        child: Image.asset(
          'assets/images/newbg02.png',
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

// ---------------- MyHomePage ----------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';
  bool loading = true;

  Future<void> handleLogin() async {
    setState(() {
      error = '';
      loading = true;
    });

    try {
      final credential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = credential.user;

      if (user != null) {
        // Kullanıcı verisini güncelle
        await user.reload();
        final refreshedUser = auth.FirebaseAuth.instance.currentUser;

        if (refreshedUser == null) {
          setState(() {
            error = "Kullanıcı bulunamadı veya hesabınız silinmiş.";
            loading = false;
          });
          return;
        }

        final doc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(refreshedUser.uid)
                .get();

        if (doc.exists) {
          final data = doc.data()!;
          final isAccept = data['isAccept'] ?? true;

          if (isAccept) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else {
            await auth.FirebaseAuth.instance.signOut();
            setState(() {
              error = "Hesabınız henüz yönetici tarafından onaylanmadı.";
              loading = false;
            });
          }
        } else {
          // Firestore'da kullanıcı yoksa çıkış yap
          await auth.FirebaseAuth.instance.signOut();
          setState(() {
            error = "Kullanıcı bilgileri bulunamadı.";
            loading = false;
          });
        }
      }
    } on auth.FirebaseAuthException catch (e) {
      setState(() {
        error = "Giriş başarısız. Bilgilerinizi kontrol edin.";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: AppDrawer(parentContext: context),
      appBar:
        AppBar(
          backgroundColor: Colors.yellow[700],
          elevation: 0,
          automaticallyImplyLeading: false, // Manuel menü düğmesi kullanıyoruz
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: 'Menüyü Aç',
                ),
          ),
        ),
      body: Stack(
        children: [
          // Arka plan resmi ve karartma (blur efekti yerine hafif karartma)
          SizedBox.expand(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.55),
                BlendMode.darken,
              ),
              child: Image.asset('assets/images/bg22.jpg', fit: BoxFit.cover),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.80), // bg-white/60
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Giriş Yap',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-posta',
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFFD700),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFFD700),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),

                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // Gradient yerine direkt renk geçişi efekti veremiyoruz ama yakın ton kullanabiliriz
                        backgroundColor: const Color(0xFFE1BA04),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Giriş Yap'),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KayitEkrani(),
                              ),
                            );
                          },
                          child: const Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              color: Color(
                                0xFFB8860B,
                              ), // daha koyu altın sarısı tonu
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const SifremiUnuttumScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Şifremi Unuttum',
                            style: TextStyle(
                              color: Color(0xFFB8860B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
