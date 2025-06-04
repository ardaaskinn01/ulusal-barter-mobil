import 'package:flutter/material.dart';
import 'package:ulusalbarter/profil.dart';

import 'barter.dart';
import 'dashboard.dart';
import 'hakkimizda.dart';
import 'iletisim.dart';

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
            ListTile(
              leading: Icon(Icons.home, color: Colors.yellow[500]),
              title: Text('İlanlar', style: TextStyle(color: Colors.yellow[500])),
              onTap: () {
                Navigator.pop(parentContext); // Drawer'ı kapat
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
    );
  }
}