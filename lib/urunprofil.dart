import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ulusalbarter/urunekle.dart';
import 'package:video_player/video_player.dart';

class UrunProfil extends StatefulWidget {
  final String id;

  const UrunProfil({Key? key, required this.id}) : super(key: key);

  @override
  State<UrunProfil> createState() => _UrunProfilState();
}

class _UrunProfilState extends State<UrunProfil> {
  DocumentSnapshot<Map<String, dynamic>>? product;
  User? currentUser;
  bool isAdmin = false; // senin mevcut admin kontrolün
  bool canEdit = false;
  bool hasOffer = false; // kullanıcının teklif verip vermediği
  String? offerId;       // var olan teklifin id'si
  String userName = 'Ad Soyad'; // kullanıcı adı, veritabanından çekilmeli
  int? currentIndex;
  VideoPlayerController? _videoController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchProduct();
  }

  void checkUserOffer() async {
    final productId = product!.data()?['isim'];
    final userId = currentUser?.uid; // oturum açan kullanıcı id'si

    if (productId != null) {
      final offerQuery = await _firestore
          .collection('offers')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (offerQuery.docs.isNotEmpty) {
        setState(() {
          hasOffer = true;
          offerId = offerQuery.docs.first.id;
        });
      } else {
        setState(() {
          hasOffer = false;
          offerId = null;
        });
      }
    }
  }

  Future<void> showOfferDialog() async {
    final productId = product!.data()?['isim'];
    final userId = currentUser?.uid; // gerçek kullanıcı id
    final TextEditingController amountController = TextEditingController();

    String selectedCurrency = '₺';
    final List<String> currencies = ['₺', '\$', '€'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Teklif Ver',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Miktar',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow.shade700, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: (value) {
                      // Sadece rakamları al (nokta hariç, onu biz ekleyeceğiz)
                      String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

                      // Eğer boşsa direk controller'a yazıp çık
                      if (digitsOnly.isEmpty) {
                        amountController.text = '';
                        amountController.selection = TextSelection.collapsed(offset: 0);
                        return;
                      }

                      // Ters çevir (sağdan sola gruplamak için)
                      String reversed = digitsOnly.split('').reversed.join('');

                      // Üçlü gruplar yap
                      List<String> chunks = [];
                      for (int i = 0; i < reversed.length; i += 3) {
                        int end = (i + 3 > reversed.length) ? reversed.length : i + 3;
                        chunks.add(reversed.substring(i, end));
                      }

                      // Noktaları koy ve tekrar ters çevir
                      String formatted = chunks.join('.').split('').reversed.join('');

                      // Güncellemeden önce cursor pozisyonunu ayarla
                      final oldSelection = amountController.selection;
                      amountController.text = formatted;
                      int newOffset = formatted.length - (value.length - oldSelection.baseOffset);
                      if (newOffset < 0) newOffset = 0;
                      if (newOffset > formatted.length) newOffset = formatted.length;

                      amountController.selection = TextSelection.collapsed(offset: newOffset);
                    },

                  ),
                  SizedBox(height: 20),

                  // Birim seçimi kutusu
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.yellow.shade700, width: 2),
                      color: Colors.yellow.shade50,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCurrency,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.yellow.shade700),
                        dropdownColor: Colors.yellow.shade50,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        items: currencies
                            .map((cur) => DropdownMenuItem(
                          value: cur,
                          child: Row(
                            children: [
                              Icon(
                                cur == '₺'
                                    ? Icons.currency_lira
                                    : cur == '\$'
                                    ? Icons.attach_money
                                    : Icons.euro,
                                color: Colors.yellow.shade700,
                              ),
                              SizedBox(width: 8),
                              Text(cur),
                            ],
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedCurrency = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade600,
                textStyle: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                // Noktaları kaldır, sadece rakamları al
                String rawAmount = amountController.text.replaceAll('.', '');

                final amount = double.tryParse(rawAmount);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Geçerli bir miktar girin'))
                  );
                  return;
                }

                if (productId == null || userId!.isEmpty) return;

                // Firestore'a teklif ekle
                await _firestore.collection('offers').add({
                  'productId': productId,
                  'userId': userId,
                  'userName': userName,
                  'amount': amount,
                  'currency': selectedCurrency,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                setState(() {
                  hasOffer = true;
                });

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Teklif başarıyla gönderildi'))
                );
              },

              child: Text('Teklif Ver', style: TextStyle(color: Colors.black),),
            ),
          ],
        );

      },
    );
  }

  Future<void> withdrawOffer() async {
    if (offerId == null) return;

    await _firestore.collection('offers').doc(offerId).delete();

    setState(() {
      hasOffer = false;
      offerId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teklif geri çekildi')));
  }

  Future<void> fetchUser() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        currentUser = user;
        final userSnap =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();
        if (userSnap.exists && userSnap.data()?['role'] == 'admin') {
          setState(() => isAdmin = true);
        }
        userName = userSnap.data()?['ad'] + ' ' + userSnap.data()?['soyad'];
      }
    });
  }

  Future<void> fetchProduct() async {
    final doc =
        await FirebaseFirestore.instance
            .collection("products")
            .doc(widget.id)
            .get();

    if (doc.exists) {
      setState(() {
        product = doc;
        canEdit = currentUser?.uid == doc.data()?['userId'];
      });
    }
    checkUserOffer(); // Ürün yüklendikten sonra çağır
  }

  void openModal(int index) {
    setState(() {
      currentIndex = index;
      final url = product?.data()?['ekGorselUrl'][index];
      if (url != null && url.endsWith('.mp4')) {
        _videoController = VideoPlayerController.network(url)
          ..initialize().then((_) {
            setState(() {});
            _videoController?.play();
          });
      }
    });
  }

  void closeModal() {
    setState(() {
      currentIndex = null;
      _videoController?.pause();
      _videoController = null;
    });
  }

  void goPrev() {
    if (currentIndex != null && currentIndex! > 0) {
      openModal(currentIndex! - 1);
    }
  }

  void goNext() {
    final length = product?.data()?['ekGorselUrl']?.length ?? 0;
    if (currentIndex != null && currentIndex! < length - 1) {
      openModal(currentIndex! + 1);
    }
  }

  Future<void> handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Ürünü Sil"),
            content: Text("Bu ürünü silmek istediğinize emin misiniz?"),
            actions: [
              TextButton(
                child: Text("İptal"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text("Sil"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.id)
          .delete();
      Navigator.pop(context); // geri dön
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final data = product!.data()!;
    final aciklamalar = List<String>.from(data['aciklamalar'] ?? []);
    final ekGorseller = List<String>.from(data['ekGorselUrl'] ?? []);
    final fiyat = data['fiyat'];

    return Scaffold(
      backgroundColor: Colors.yellow.shade600,
      appBar: AppBar(
        title: Text('Ürün Detayları'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.yellow.shade800,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Center(  // Burada Center ekledik
              child: Text(
                'İlan Numarası: ${data['id'] ?? ''}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade600, // yellow-500 benzeri
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${data['isim'] ?? ''}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Ana içerik burada devam ediyor (ana görsel, fiyat, açıklamalar vs)
                GestureDetector(
                  onTap: () => openModal(-1),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data['anaGorselUrl']),
                        fit: BoxFit.contain,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                if (fiyat != null)
                  (isAdmin || canEdit)
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            RegExp(r'\d\s*(₺|\$|€)$')
                                .hasMatch(fiyat.toString().trim())
                                ? fiyat.toString().trim()
                                : '$fiyat ₺',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final productData = product!.data();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UrunEkleScreen(existingProduct: productData),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                        ),
                        child:
                        Text("Düzenle", style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: handleDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text("Sil", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                      : Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            RegExp(r'\d\s*(₺|\$|€)$')
                                .hasMatch(fiyat.toString().trim())
                                ? fiyat.toString().trim()
                                : '$fiyat ₺',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (hasOffer) {
                              // Teklifi geri çek
                              withdrawOffer();
                            } else {
                              // Teklif ver dialogu aç
                              showOfferDialog();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            hasOffer ? Colors.grey : Colors.green,
                          ),
                          child: Text(
                            hasOffer ? 'Teklifi Geri Çek' : 'Teklif Ver',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ürün Detayları",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...aciklamalar.map((desc) => Text("• $desc")),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                if (ekGorseller.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Diğer Medya",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(ekGorseller.length, (i) {
                          final url = ekGorseller[i];
                          return GestureDetector(
                            onTap: () => openModal(i),
                            child: Container(
                              width: 100,
                              height: 100,
                              child: url.endsWith('.mp4')
                                  ? Icon(Icons.videocam, size: 48)
                                  : Image.network(url, fit: BoxFit.cover),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Modal kısmı aynı kalabilir...
          if (currentIndex != null)
            Stack(
              children: [
                GestureDetector(
                  onTap: closeModal,
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: ekGorseller[currentIndex!].endsWith('.mp4')
                          ? (_videoController?.value.isInitialized ?? false)
                          ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                          : CircularProgressIndicator()
                          : Image.network(
                        ekGorseller[currentIndex!],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: MediaQuery.of(context).size.height / 2,
                  child: IconButton(
                    onPressed: goPrev,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: MediaQuery.of(context).size.height / 2,
                  child: IconButton(
                    onPressed: goNext,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    onPressed: closeModal,
                    icon: Icon(Icons.close, color: Colors.white, size: 36),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
