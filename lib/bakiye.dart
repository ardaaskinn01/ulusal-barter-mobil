import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Bakiye extends StatelessWidget {
  const Bakiye({Key? key}) : super(key: key);

  static const Color goldColor = Color(0xFFFFD700); // Altın rengi

  void _showBakiyeDialog({
    required BuildContext context,
    required String userId,
    required num mevcutBakiye,
    required bool isAdding,
  }) {
    final TextEditingController controller = TextEditingController();
    final String title = isAdding ? 'Bakiye Ekle' : 'Bakiye Çıkar';

    controller.addListener(() {
      String digitsOnly = controller.text.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.isEmpty) return;

      final number = int.tryParse(digitsOnly);
      if (number == null) return;

      final formatted = NumberFormat.decimalPattern('tr_TR').format(number);

      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(title, style: TextStyle(color: goldColor)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: Colors.white),
            maxLength: 12, // 4 sayı + 1 nokta + en fazla 6 sayı
            decoration: InputDecoration(
              counterStyle: const TextStyle(color: Colors.white60),
              hintText: isAdding ? 'Eklenecek bakiye' : 'Çıkarılacak bakiye',
              hintStyle: const TextStyle(color: Colors.white60),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: goldColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final String input = controller.text.trim().replaceAll('.', ''); // Noktaları kaldır

                final num? miktar = num.tryParse(input);
                if (miktar == null || miktar <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Geçerli bir miktar girin')),
                  );
                  return;
                }

                num yeniBakiye = isAdding
                    ? mevcutBakiye + miktar
                    : (mevcutBakiye - miktar >= 0 ? mevcutBakiye - miktar : mevcutBakiye);

                if (!isAdding && mevcutBakiye - miktar < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bakiye sıfırın altına inemez!')),
                  );
                  return;
                }

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({'bakiye': yeniBakiye});

                Navigator.pop(context);
              },

              child: Text(isAdding ? 'Ekle' : 'Çıkar'),
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
        title: const Text('Bakiye Takip'),
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
            return const Center(child: Text('Hata oluştu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Kayıtlı kullanıcı bulunamadı'));
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
                child: ListTile(
                  title: Text(
                    '$ad $soyad',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Bakiye: ₺${bakiye.toStringAsFixed(2)}',
                    style: const TextStyle(color: goldColor),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _showBakiyeDialog(context: context, userId: userId, mevcutBakiye: bakiye, isAdding: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Ekle'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            _showBakiyeDialog(context: context, userId: userId, mevcutBakiye: bakiye, isAdding: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Çıkar'),
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
