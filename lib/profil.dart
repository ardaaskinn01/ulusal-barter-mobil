import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appDrawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _telefonController = TextEditingController();
  final _adresController = TextEditingController();
  final _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        _adController.text = data['ad'] ?? '';
        _soyadController.text = data['soyad'] ?? '';
        _telefonController.text = data['telefon'] ?? '';
        _adresController.text = data['adres'] ?? '';
        _emailController.text = data['email'] ?? '';
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'ad': _adController.text.trim(),
        'soyad': _soyadController.text.trim(),
        'telefon': _telefonController.text.trim(),
        'adres': _adresController.text.trim(),
        'email': _emailController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilgiler güncellendi')),
      );

      setState(() {
        _isEditMode = false;
      });
    }
  }

  Widget _buildProfileField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Card(
      color: Colors.blueGrey.shade900, // Koyu arka plan
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey.shade700), // İnce kenarlık
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Color(0xFFFFD700), // Altın rengi yazı
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            icon: Icon(icon, color: const Color(0xFFFFD700)), // Altın renk ikon
            labelText: label,
            labelStyle: const TextStyle(
              color: Color(0xFFFFD700), // Altın renk label
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
            // İstersen odaklanınca altın renk alt çizgi ekleyebiliriz:
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFD700)),
            ),
          ),
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(parentContext: context),
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: Colors.blueGrey.shade200,
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditMode) {
                if (_formKey.currentState!.validate()) {
                  _updateUserData();
                }
              } else {
                setState(() {
                  _isEditMode = true;
                });
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                '${_adController.text} ${_soyadController.text}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              _buildProfileField(
                label: 'Ad',
                icon: Icons.person,
                controller: _adController,
                enabled: _isEditMode,
              ),
              _buildProfileField(
                label: 'Soyad',
                icon: Icons.person_outline,
                controller: _soyadController,
                enabled: _isEditMode,
              ),
              _buildProfileField(
                label: 'Telefon',
                icon: Icons.phone,
                controller: _telefonController,
                keyboardType: TextInputType.phone,
                enabled: _isEditMode,
              ),
              _buildProfileField(
                label: 'Adres',
                icon: Icons.home,
                controller: _adresController,
                maxLines: 2,
                enabled: _isEditMode,
              ),
              _buildProfileField(
                label: 'Email',
                icon: Icons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: _isEditMode,
              ),

              if (_isEditMode) const SizedBox(height: 24),

              if (_isEditMode)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateUserData();
                      }
                    },
                    label: const Text(
                      'Kaydet',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}