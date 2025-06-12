import 'package:flutter/material.dart';
import 'package:ulusalbarter/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'barter.dart';
import 'dashboard.dart';
import 'hakkimizda.dart';
import 'iletisim.dart';
import 'main.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const AppDrawer({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[800],
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/newbg02.png',
                    height: 100,
                    width: 160,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Menü',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.yellow[500]),
                    title: Text('İlanlar', style: TextStyle(color: Colors.yellow[500])),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(parentContext, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.yellow[500]),
                    title: Text('Profil', style: TextStyle(color: Colors.yellow[500])),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(parentContext, MaterialPageRoute(builder: (_) => const ProfilePage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.yellow[500]),
                    title: Text('Hakkımızda', style: TextStyle(color: Colors.yellow[500])),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(parentContext, MaterialPageRoute(builder: (_) => const HakkimizdaPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.compare_arrows, color: Colors.yellow[500]),
                    title: Text('Barter Sistemi', style: TextStyle(color: Colors.yellow[500])),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(parentContext, MaterialPageRoute(builder: (_) => const BarterPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.contact_mail, color: Colors.yellow[500]),
                    title: Text('İletişim', style: TextStyle(color: Colors.yellow[500])),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(parentContext, MaterialPageRoute(builder: (_) => Iletisim()));
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(); // Drawer'ı kapat
                  // Giriş ekranına yönlendir
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(content: Text('Çıkış yapılamadı: $e')),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Hesabımı Sil', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                // Önce kullanıcıdan onay al
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hesabı Sil'),
                    content: const Text('Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
                    actions: [
                      TextButton(
                        child: const Text('Vazgeç'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Sil', style: TextStyle(color: Colors.red)),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  try {
                    // Firestore'dan kullanıcı verisini sil
                    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

                    // Firebase Auth üzerinden kullanıcıyı sil
                    await user.delete();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text('Hesap silinemedi: $e')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}