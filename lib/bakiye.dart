import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(title, style: TextStyle(color: goldColor)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            maxLength: 11, // Maksimum 11 hane
            decoration: InputDecoration(
              counterStyle: const TextStyle(color: Colors.white60),
              hintText: isAdding ? 'Eklenecek bakiye (4-11 hane)' : 'Çıkarılacak bakiye (4-11 hane)',
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
                final String input = controller.text.trim();
                final cleanedInput = input.replaceAll(RegExp(r'[^\d]'), ''); // sadece sayılar kalsın

                if (cleanedInput.length < 4 || cleanedInput.length > 11) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bakiye 4 ile 11 hane arasında olmalıdır')),
                  );
                  return;
                }

                final num? miktar = num.tryParse(cleanedInput);
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
                      // Ekle Butonu
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
                      // Çıkar Butonu
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
