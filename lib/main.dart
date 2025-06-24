import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulusalbarter/sifremiunuttum.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'appDrawer.dart';
import 'dashboard.dart';
import 'firebase_options.dart';
import 'kayit.dart';
import 'languageProvider.dart';

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

  runApp( ChangeNotifierProvider<LanguageProvider>(
    create: (_) => LanguageProvider(),
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: languageProvider.currentLocale,
          // Eğer `flutter_localizations` eklenecekse buraya delegates de eklenir.
          home: const SplashScreen(), // Ana ekranınız
        );
      },
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';

  Future<void> handleLogin() async {
    setState(() {
      error = '';
    });

    try {
      final credential = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;
      if (user != null) {
        await user.reload();
        final refreshedUser = auth.FirebaseAuth.instance.currentUser;

        if (refreshedUser == null) {
          setState(() {
            error = LanguageProvider.translate(context, 'userNotFound');
          });
          return;
        }

        final doc = await FirebaseFirestore.instance
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
              error = LanguageProvider.translate(context, 'notApproved');
            });
          }
        } else {
          await auth.FirebaseAuth.instance.signOut();
          setState(() {
            error = LanguageProvider.translate(context, 'userDataNotFound');
          });
        }
      }
    } on auth.FirebaseAuthException catch (_) {
      setState(() {
        error = LanguageProvider.translate(context, 'loginFailed');
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: AppDrawer(parentContext: context),
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: LanguageProvider.translate(context, 'openMenu'),
          ),
        ),
      ),
      body: Stack(
        children: [
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
                  color: Colors.white.withOpacity(0.80),
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
                    Text(
                      LanguageProvider.translate(context, 'login'),
                      style: const TextStyle(
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
                        labelText: LanguageProvider.translate(context, 'email'),
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
                        labelText: LanguageProvider.translate(context, 'password'),
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
                        child: Text(error, style: const TextStyle(color: Colors.red)),
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
                        backgroundColor: const Color(0xFFE1BA04),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text(LanguageProvider.translate(context, 'login')),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const KayitEkrani()),
                            );
                          },
                          child: Text(
                            LanguageProvider.translate(context, 'register'),
                            style: const TextStyle(
                              color: Color(0xFFB8860B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SifremiUnuttumScreen()),
                            );
                          },
                          child: Text(
                            LanguageProvider.translate(context, 'forgotPassword'),
                            style: const TextStyle(
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
