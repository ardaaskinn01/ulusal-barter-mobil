import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BakiyeGecmisiScreen extends StatelessWidget {
  final String userId;

  const BakiyeGecmisiScreen({required this.userId, Key? key}) : super(key: key);

  String formatDateTr(DateTime dateTime) {
    const List<String> aylar = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];

    String gun = dateTime.day.toString().padLeft(2, '0');
    String ay = aylar[dateTime.month - 1];
    String yil = dateTime.year.toString();

    String saat = dateTime.hour.toString().padLeft(2, '0');
    String dakika = dateTime.minute.toString().padLeft(2, '0');

    return '$gun $ay $yil - $saat:$dakika';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bakiye Geçmişi'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('bakiye_gecmisi')
            .orderBy('tarih', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'İşlem geçmişi bulunamadı.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final miktar = data['miktar'];
              final aciklama = data['aciklama'] ?? '';
              final islemTuru = data['islemTuru'] ?? 'ekle';
              final tarih = (data['tarih'] as Timestamp).toDate();

              final isEkle = islemTuru == 'ekle';

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: isEkle ? Colors.green.withOpacity(0.4) : Colors.red.withOpacity(0.4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isEkle ? Colors.green[100] : Colors.red[100],
                    child: Icon(
                      isEkle ? Icons.add : Icons.remove,
                      color: isEkle ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    '${isEkle ? '+' : '-'} ₺${miktar.toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isEkle ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aciklama,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDateTr(tarih),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}