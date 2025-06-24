import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulusalbarter/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'barter.dart';
import 'dashboard.dart';
import 'hakkimizda.dart';
import 'iletisim.dart';
import 'languageProvider.dart';
import 'main.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const AppDrawer({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
            if (user == null)
              ListTile(
                leading: const Icon(Icons.login, color: Colors.greenAccent),
                title: Text(
                  LanguageProvider.translate(context, 'login'),
                  style: TextStyle(color: Colors.greenAccent),
                ),
                onTap: () {
                  Navigator.pop(parentContext);
                  Navigator.push(
                    parentContext,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),

            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.yellow[500]),
                    title: Text(
                      LanguageProvider.translate(context, 'listings'),
                      style: TextStyle(color: Colors.yellow[500]),
                    ),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(
                        parentContext,
                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      );
                    },
                  ),
                  if (user != null)
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.yellow[500]),
                      title: Text(
                        LanguageProvider.translate(context, 'profile'),
                        style: TextStyle(color: Colors.yellow[500]),
                      ),
                      onTap: () {
                        Navigator.pop(parentContext);
                        Navigator.push(
                          parentContext,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Colors.yellow[500],
                    ),
                    title: Text(
                      LanguageProvider.translate(context, 'about'),
                      style: TextStyle(color: Colors.yellow[500]),
                    ),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(
                        parentContext,
                        MaterialPageRoute(
                          builder: (_) => const HakkimizdaPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.compare_arrows,
                      color: Colors.yellow[500],
                    ),
                    title: Text(
                      LanguageProvider.translate(context, 'barter'),
                      style: TextStyle(color: Colors.yellow[500]),
                    ),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(
                        parentContext,
                        MaterialPageRoute(builder: (_) => const BarterPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.contact_mail,
                      color: Colors.yellow[500],
                    ),
                    title: Text(
                      LanguageProvider.translate(context, 'contact'),
                      style: TextStyle(color: Colors.yellow[500]),
                    ),
                    onTap: () {
                      Navigator.pop(parentContext);
                      Navigator.push(
                        parentContext,
                        MaterialPageRoute(builder: (_) => Iletisim()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(
                Icons.language,
                color: Colors.lightBlueAccent,
              ),
              title: Text(
                LanguageProvider.translate(context, 'language'),
                style: const TextStyle(color: Colors.lightBlueAccent),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Row(
                          children: [
                            const Icon(
                              Icons.language,
                              color: Colors.lightBlueAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              LanguageProvider.translate(context, 'language'),
                              style: const TextStyle(
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _languageOption(
                              context,
                              languageCode: 'tr',
                              label: LanguageProvider.translate(
                                context,
                                'turkish',
                              ),
                              flag: '🇹🇷',
                            ),
                            const SizedBox(height: 8),
                            _languageOption(
                              context,
                              languageCode: 'en',
                              label: LanguageProvider.translate(
                                context,
                                'english',
                              ),
                              flag: '🇬🇧',
                            ),
                            const SizedBox(height: 8),
                            _languageOption(
                              context,
                              languageCode: 'de',
                              label: LanguageProvider.translate(
                                context,
                                'german',
                              ),
                              flag: '🇩🇪',
                            ),
                          ],
                        ),
                      ),
                );
              },
            ),
            if (user != null) ...[
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  LanguageProvider.translate(context, 'logout'),
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
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
                title: Text(
                  LanguageProvider.translate(context, 'deleteAccount'),
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Hesabı Sil'),
                          content: const Text(
                            'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Vazgeç'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: const Text(
                                'Sil',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                  );

                  if (confirmed == true) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .delete();
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
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(
    BuildContext context, {
    required String languageCode,
    required String label,
    required String flag,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).changeLanguage(languageCode);
        Navigator.of(context).pop();
      },
      icon: Text(flag, style: const TextStyle(fontSize: 20)),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
