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
  bool isAdmin = false;
  bool canEdit = false;
  int? currentIndex;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchProduct();
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

                if (data['fiyat'] != null)
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
                                .hasMatch(data['fiyat'].toString().trim())
                                ? data['fiyat'].toString().trim()
                                : '${data['fiyat']} ₺',
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
                          final productData = product!.data(); // burada veriyi alıyoruz
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UrunEkleScreen(existingProduct: productData),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                        ),
                        child: Text("Düzenle", style: TextStyle(color: Colors.white)),
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
                      : Center(  // Eğer butonlar yoksa ortada göster
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        RegExp(r'\d\s*(₺|\$|€)$')
                            .hasMatch(data['fiyat'].toString().trim())
                            ? data['fiyat'].toString().trim()
                            : '${data['fiyat']} ₺',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                SizedBox(height: 24),

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
