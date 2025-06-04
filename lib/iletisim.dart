import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'appDrawer.dart';

class Iletisim extends StatefulWidget {
  @override
  _IletisimState createState() => _IletisimState();
}

class _IletisimState extends State<Iletisim> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İletişim'),
        backgroundColor: Colors.yellow[700],
      ),
      drawer: AppDrawer(parentContext: context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg19.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.65),
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 900,
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    48, // AppBar yüksekliği ve padding düşülür
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'İLETİŞİM',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bizimle iletişime geçmekten çekinmeyin.',
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                  ),
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.yellow[700]!, width: 4),
                      boxShadow: [
                      BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                      )],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İletişim Bilgileri',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[700],
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.yellow[700], size: 30),
                          title: Text('ulusalbarter@gmail.com',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('E-Mail'),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.yellow[700], size: 30),
                          title: Text('0232 600 25 25',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('Telefon'),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on, color: Colors.yellow[700], size: 30),
                          title: Text(
                            'Mansuroğlu Mah. 283/1 Sk. No:2 GSK Plaza K:1 D:201 Bayraklı/İzmir',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Adres'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24), // Alt boşluk ekledim
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}