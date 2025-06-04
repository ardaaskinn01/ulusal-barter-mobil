import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final _formKey = GlobalKey<FormState>();

  final adController = TextEditingController();
  final soyadController = TextEditingController();
  final telefonController = TextEditingController();
  final adresController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';
  bool loading = false;

  Future<void> handleRegister() async {
    setState(() {
      error = '';
      loading = true;
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final ad = adController.text.trim();
      final soyad = soyadController.text.trim();
      final telefon = telefonController.text.trim();
      final adres = adresController.text.trim();

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'ad': ad,
          'soyad': soyad,
          'telefon': telefon,
          'adres': adres,
          'email': email,
          'role': 'user',
          'isAccept': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Kayıt başarılı → login ekranına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? 'Bir hata oluştu.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(adController, 'Ad'),
              const SizedBox(height: 10),
              _buildTextField(soyadController, 'Soyad'),
              const SizedBox(height: 10),
              _buildTextField(telefonController, 'Telefon'),
              const SizedBox(height: 10),
              _buildTextField(adresController, 'Adres'),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'E-posta', type: TextInputType.emailAddress),
              const SizedBox(height: 10),
              _buildTextField(passwordController, 'Şifre', isPassword: true),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE1BA04),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}