import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ulusalbarter/urunprofil.dart'; // NumberFormat için ekle

class OffersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OffersPage({Key? key}) : super(key: key);

  Future<void> _goToProductPage(BuildContext context, String productId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UrunProfil(id: productId),
      ),
    );
  }

  String formatAmount(dynamic amount) {
    if (amount == null) return '';
    final formatter = NumberFormat('#,##0', 'tr_TR');
    // Flutter'da binlik ayraç varsayılan olarak nokta olur TR locale'de
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final goldColor = Color(0xFFFFC107); // Altın sarısı

    return Scaffold(
      appBar: AppBar(
        backgroundColor: goldColor,
        title: Text(
          'Teklifler',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('offers')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(color: goldColor));

          final offers = snapshot.data?.docs ?? [];

          if (offers.isEmpty) {
            return Center(
              child: Text(
                'Henüz teklif yok',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: offers.length,
            separatorBuilder: (_, __) => Divider(color: goldColor.withOpacity(0.5)),
            itemBuilder: (context, index) {
              final offer = offers[index];
              final data = offer.data()! as Map<String, dynamic>;

              final amount = data['amount'] ?? 0;
              final currency = data['currency'] ?? '';
              final userName = data['userName'] ?? 'Bilinmeyen';
              final productId = data['productId'] ?? '';

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: goldColor.withOpacity(0.4),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  title: Text(
                    '${formatAmount(amount)} $currency',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Teklif veren: $userName',
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        productId,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18, color: goldColor),
                  onTap: () => _goToProductPage(context, productId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
