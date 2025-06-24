import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'languageProvider.dart';

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
        infoMessage = LanguageProvider.translate(context, 'resetLinkSent');
      });
    } catch (e) {
      setState(() {
        errorMessage = LanguageProvider.translate(context, 'resetError');
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
                    Text(
                      LanguageProvider.translate(context, 'forgotPassword'),
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
                        labelText: LanguageProvider.translate(context, 'emailLabel'),
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
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
                      onPressed: loading || emailController.text.trim().isEmpty
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
                        loading
                            ? LanguageProvider.translate(context, 'sending')
                            : LanguageProvider.translate(context, 'sendResetLink'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LanguageProvider.translate(context, 'goBack'),
                        style: const TextStyle(
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