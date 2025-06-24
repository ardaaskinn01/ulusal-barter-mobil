import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'languageProvider.dart';
import 'bakiyegecmisi.dart'; // geçmiş ekranınız varsa

class Bakiye extends StatelessWidget {
  const Bakiye({Key? key}) : super(key: key);

  static const Color goldColor = Color(0xFFFFD700);

  void _showBakiyeDialog({
    required BuildContext context,
    required String userId,
    required num mevcutBakiye,
    required bool isAdding,
  }) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final title = isAdding
        ? LanguageProvider.translate(context, 'addBalance')
        : LanguageProvider.translate(context, 'removeBalance');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(title, style: const TextStyle(color: goldColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsSeparatorFormatter(),
                ],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: LanguageProvider.translate(context, 'amount'),
                  hintStyle: const TextStyle(color: Colors.white60),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: LanguageProvider.translate(context, 'description'),
                  hintStyle: const TextStyle(color: Colors.white60),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                LanguageProvider.translate(context, 'cancel'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final input = amountController.text.trim().replaceAll('.', '');
                final num? miktar = num.tryParse(input);
                final aciklama = descriptionController.text.trim();

                if (miktar == null || miktar <= 0 || aciklama.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(LanguageProvider.translate(context, 'invalidInput'))),
                  );
                  return;
                }

                num yeniBakiye = isAdding
                    ? mevcutBakiye + miktar
                    : (mevcutBakiye - miktar >= 0 ? mevcutBakiye - miktar : mevcutBakiye);

                if (!isAdding && mevcutBakiye - miktar < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(LanguageProvider.translate(context, 'belowZeroError'))),
                  );
                  return;
                }

                final now = DateTime.now();
                final firestore = FirebaseFirestore.instance;

                await firestore.collection('users').doc(userId).update({'bakiye': yeniBakiye});

                await firestore
                    .collection('users')
                    .doc(userId)
                    .collection('bakiye_gecmisi')
                    .add({
                  'miktar': miktar,
                  'aciklama': aciklama,
                  'islemTuru': isAdding ? 'ekle' : 'çıkar',
                  'tarih': now,
                });

                Navigator.pop(context);
              },
              child: Text(LanguageProvider.translate(
                context,
                isAdding ? 'add' : 'remove',
              )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.grey.shade900;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(LanguageProvider.translate(context, 'balanceTracking')),
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'user')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(LanguageProvider.translate(context, 'errorOccurred')),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(LanguageProvider.translate(context, 'noUsersFound')),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final ad = data['ad'] ?? '';
              final soyad = data['soyad'] ?? '';
              final bakiye = (data['bakiye'] ?? 0) as num;
              final userId = docs[index].id;

              return Card(
                color: Colors.black,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: goldColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$ad $soyad',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${LanguageProvider.translate(context, 'balance')}: ₺${bakiye.toStringAsFixed(2)}',
                        style: const TextStyle(color: goldColor),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () => _showBakiyeDialog(
                              context: context,
                              userId: userId,
                              mevcutBakiye: bakiye,
                              isAdding: true,
                            ),
                            child: Text(LanguageProvider.translate(context, 'add')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goldColor,
                              foregroundColor: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _showBakiyeDialog(
                              context: context,
                              userId: userId,
                              mevcutBakiye: bakiye,
                              isAdding: false,
                            ),
                            child: Text(LanguageProvider.translate(context, 'remove')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BakiyeGecmisiScreen(userId: userId),
                                ),
                              );
                            },
                            child: Text(LanguageProvider.translate(context, 'history')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll('.', '');
    if (rawText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Sayı formatlama
    final number = int.parse(rawText);
    final formatted = _formatWithDots(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatWithDots(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return buffer.toString().split('').reversed.join();
  }
}
