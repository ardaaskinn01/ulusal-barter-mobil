import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SifremiUnuttumScreen extends StatefulWidget {
  const SifremiUnuttumScreen({super.key});

  @override
  State<SifremiUnuttumScreen> createState() => _SifremiUnuttumScreenState();
}

class _SifremiUnuttumScreenState extends State<SifremiUnuttumScreen> {
  final emailController = TextEditingController();
  String infoMessage = '';
  String errorMessage = '';
  bool loading = false;

  Future<void> handleResetPassword() async {
    setState(() {
      loading = true;
      errorMessage = '';
      infoMessage = '';
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      setState(() {
        infoMessage =
        "Şifre sıfırlama bağlantısı mail adresinize gönderildi. Lütfen mailinizi kontrol edin.";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Bir hata oluştu. Lütfen mail adresinizi kontrol edin.";
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi ve karartma
          SizedBox.expand(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.55),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/bg22.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
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
                    const Text(
                      'Şifremi Unuttum',
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
                        labelText: 'E-posta adresiniz',
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xFFFFD700), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),

                    const SizedBox(height: 16),

                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (infoMessage.isNotEmpty)
                      Text(
                        infoMessage,
                        style: const TextStyle(color: Colors.green),
                      ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed:
                      loading || emailController.text.trim().isEmpty
                          ? null
                          : handleResetPassword,
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
                      child: Text(
                          loading ? 'Gönderiliyor...' : 'Şifre Sıfırlama Bağlantısı Gönder'),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Geri Dön',
                        style: TextStyle(
                          color: Color(0xFFB8860B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
