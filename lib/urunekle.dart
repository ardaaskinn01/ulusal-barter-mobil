import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UrunEkleScreen extends StatefulWidget {
  final Map<String, dynamic>? existingProduct;

  UrunEkleScreen({this.existingProduct});

  @override
  _UrunEkleScreenState createState() => _UrunEkleScreenState();
}

class _UrunEkleScreenState extends State<UrunEkleScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<File> _newExtraMedia = [];
  List<String> _existingExtraMediaUrls = [];

  File? _mainImage;
  List<File> _extraMedia = [];
  List<TextEditingController> _descriptionControllers = [
    TextEditingController()
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> requestPermissions() async {
    await [
      Permission.photos,
      Permission.storage,
    ].request();
  }

  Future<void> _pickMainImage() async {
    await requestPermissions(); // izinleri iste

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _mainImage = File(picked.path);
      });
    }
  }


  Future<void> _pickExtraImages() async {
    await requestPermissions();

    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _newExtraMedia.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _pickExtraVideo() async {
    await requestPermissions();

    final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _newExtraMedia.add(File(pickedVideo.path));
      });
    }
  }

  Future<String> uploadToSupabase(File file, String path) async {
    final supabase = Supabase.instance.client;
    final fileBytes = await file.readAsBytes();

    final response = await supabase.storage
        .from('products') // Bucket adın
        .uploadBinary(path, fileBytes, fileOptions: FileOptions(upsert: true));

    final publicUrl = supabase.storage.from('products').getPublicUrl(path);
    return publicUrl;
  }

  Future<void> saveToFirebase({
    required String name,
    required String price,
    required String mainImageUrl,
    required List<String> extraMediaUrls,
    required List<String> descriptions,
    String? id,
    Timestamp? createdAt,
    String? oldName, // eski isim, varsa
  }) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Giriş yapılmamış.");

    final timestamp = createdAt ?? Timestamp.now();
    final docId = name; // Doküman id'si name olacak (senin istediğin gibi)

    // Eğer edit moddaysak ve name değişmişse eski dokümanı sil
    if (oldName != null && oldName != name) {
      await firestore.collection("products").doc(oldName).delete();
    }

    await firestore.collection("products").doc(docId).set({
      "id": id ?? generateIdFromDate(timestamp), // id eski ise eski id kullanılır
      "isim": name,
      "fiyat": price,
      "anaGorselUrl": mainImageUrl,
      "ekGorselUrl": extraMediaUrls,
      "aciklamalar": descriptions,
      "userId": user.uid,
      "createdAt": timestamp,
    });
  }

  void _addDescription() {
    setState(() {
      _descriptionControllers.add(TextEditingController());
    });
  }

  void _removeDescription() {
    if (_descriptionControllers.length > 1) {
      setState(() {
        _descriptionControllers.removeLast();
      });
    }
  }

  void _submitForm() async {
    String name = _productNameController.text.trim();
    String price = _priceController.text.trim();

    // Edit modundaysa ve ana görsel yoksa hata verme
    bool isEditMode = widget.existingProduct != null;

    if (name.isEmpty || price.isEmpty || (!isEditMode && _mainImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen ürün ismi, fiyat ve ana görsel ekleyin.")),
      );
      return;
    }

    List<String> descriptions = _descriptionControllers.map((e) => e.text.trim()).toList();
    final safeName = name.replaceAll(RegExp(r'[^\w\s]+'), "_");

    try {
      String mainUrl;

      if (_mainImage != null) {
        // Yeni ana görsel seçilmişse upload et
        mainUrl = await uploadToSupabase(_mainImage!, "$safeName/main.jpg");
      } else {
        // Edit modunda ana görsel değiştirilmediyse, var olan url'yi kullan
        mainUrl = widget.existingProduct?['anaGorselUrl'] ?? '';
      }

      List<String> extraUrls = List.from(_existingExtraMediaUrls); // önceki görselleri tut
      for (int i = 0; i < _newExtraMedia.length; i++) {
        final ext = _newExtraMedia[i].path.split('.').last;
        final path = "$safeName/extra_${extraUrls.length + i}.$ext";
        final url = await uploadToSupabase(_newExtraMedia[i], path);
        extraUrls.add(url);
      }

      await saveToFirebase(
        name: name,
        price: price,
        mainImageUrl: mainUrl,
        extraMediaUrls: extraUrls,
        descriptions: descriptions,
        id: widget.existingProduct?['id'], // eski id varsa koru
        createdAt: widget.existingProduct?['createdAt'], // eski createdAt koru
        oldName: widget.existingProduct?['isim'], // eski isim, name değiştiyse eskiyi silsin diye
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ürün kaydedildi.")));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  String generateIdFromDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString().substring(2);
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');

    return '$day$month$year$hour$minute';
  }

  @override
  void initState() {
    super.initState();

    final product = widget.existingProduct;
    if (product != null) {
      _productNameController.text = product['isim'] ?? '';
      _priceController.text = product['fiyat'] ?? '';

      for (var desc in (product['aciklamalar'] ?? [])) {
        _descriptionControllers.add(TextEditingController(text: desc));
      }

      if (_descriptionControllers.isNotEmpty && _descriptionControllers.first.text == "") {
        _descriptionControllers.removeAt(0);
      }

      _existingExtraMediaUrls = List<String>.from(product['ekGorselUrl'] ?? []);
      for (var url in _existingExtraMediaUrls) {
        _extraMedia.add(File('')); // Dummy file, sadece sayıyı korumak için
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      appBar: AppBar(
        title: Text("Ürün Ekle"),
        backgroundColor: Colors.yellow[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ürün İsmi
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: "Ürün İsmi",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // Fiyat
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Fiyat",
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),

            // Ana Görsel
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickMainImage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text("Ana Görsel Seç"),
                ),
                SizedBox(width: 10),
                if (_mainImage != null) Text("Seçildi: ${_mainImage!.path.split('/').last}"),
              ],
            ),
            SizedBox(height: 12),

            // Ek Medya
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickExtraImages,
                  child: Text("Ek Fotoğraf Seç", style: TextStyle(color: Colors.black),),
                ),

                ElevatedButton(
                  onPressed: _pickExtraVideo,
                  child: Text("Ek Video Seç", style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Açıklamalar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ürün Açıklamaları:"),
                ..._descriptionControllers.asMap().entries.map(
                      (entry) {
                    int i = entry.key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: "Açıklama ${i + 1}",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _addDescription,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text("Açıklama Ekle"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _removeDescription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Açıklama Sil"),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),

            // Kaydet Butonu
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Ürünü Kaydet", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
