import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulusalbarter/sifremiunuttum.dart';

import 'dashboard.dart';
import 'firebase_options.dart';
import 'kayit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Supabase'i başlatgit init
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
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
  void initState() {
    super.initState();
    // 3 saniye sonra MyHomePage'e geç
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    final user = auth.FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.reload();
        final refreshedUser = auth.FirebaseAuth.instance.currentUser;

        if (refreshedUser == null) {
          setState(() => loading = false);
          return;
        }

        final tokenResult = await refreshedUser.getIdTokenResult();
        if (tokenResult.expirationTime!.isAfter(DateTime.now())) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
          return;
        }
      } catch (e) {
        // Hata oluşursa çıkış yaptır
        await auth.FirebaseAuth.instance.signOut();
      }
    }

    setState(() => loading = false);
  }

  Future<void> handleLogin() async {
    setState(() {
      error = '';
      loading = true;
    });

    try {
      final credential = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
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

        final doc = await FirebaseFirestore.instance.collection("users").doc(refreshedUser.uid).get();

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
