import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'languageProvider.dart';

class UrunEkleScreen extends StatefulWidget {
  final Map<String, dynamic>? existingProduct;

  const UrunEkleScreen({super.key, this.existingProduct});

  @override
  State<UrunEkleScreen> createState() => _UrunEkleScreenState();
}

class _UrunEkleScreenState extends State<UrunEkleScreen> {
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  List<TextEditingController> _descriptionControllers = [TextEditingController()];
  List<File> _newExtraMedia = [];
  List<String> _existingExtraMediaUrls = [];
  File? _mainImage;
  List<File> _extraMedia = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> requestPermissions() async {
    await [Permission.photos, Permission.storage].request();
  }

  Future<void> _pickMainImage() async {
    await requestPermissions();
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
    await supabase.storage.from('products').uploadBinary(path, fileBytes, fileOptions: FileOptions(upsert: true));
    return supabase.storage.from('products').getPublicUrl(path);
  }

  Future<void> sendPushNotification(String name) async {
    final url = Uri.parse('https://onesignal.com/api/v1/notifications');
    final body = {
      "app_id": "d4f432ca-d0cc-4d13-873d-b24b41de5699",
      "included_segments": ["All"],
      "headings": {"en": "Yeni İlan!"},
      "contents": {"en": "Sistemimize yeni bir ilan eklendi! Tıkla ve göz at. $name"},
    };
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": "Basic os_v2_app_2t2dfswqzrgrhbz5wjfudxswtgoodtrsmpbe4znf3nnrmncrg5triwmlmxgbl7ewjhvumikoguv5mvjy5g2n6frlrdtylklan3hnlji"
        },
        body: jsonEncode(body));
    if (response.statusCode != 200) {
      debugPrint("Push error: ${response.body}");
    }
  }

  Future<void> saveToFirebase({
    required String name,
    required String price,
    required String mainImageUrl,
    required List<String> extraMediaUrls,
    required List<String> descriptions,
    String? id,
    Timestamp? createdAt,
    String? oldName,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Not logged in");

    final timestamp = createdAt ?? Timestamp.now();
    final docId = name;

    if (oldName != null && oldName != name) {
      await firestore.collection("products").doc(oldName).delete();
    }

    await firestore.collection("products").doc(docId).set({
      "id": id ?? generateIdFromDate(timestamp),
      "isim": name,
      "fiyat": price,
      "anaGorselUrl": mainImageUrl,
      "ekGorselUrl": extraMediaUrls,
      "aciklamalar": descriptions,
      "userId": user.uid,
      "createdAt": timestamp,
      "sabitle": false,
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
    final lang = LanguageProvider.translate;
    final name = _productNameController.text.trim();
    final price = _priceController.text.trim();
    final isEditMode = widget.existingProduct != null;

    if (name.isEmpty || price.isEmpty || (!isEditMode && _mainImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang(context, 'fillRequiredFields'))),
      );
      return;
    }

    final descriptions = _descriptionControllers.map((e) => e.text.trim()).toList();
    final safeName = name.replaceAll(RegExp(r'[^\w\s]+'), "_");

    try {
      String mainUrl = widget.existingProduct?['anaGorselUrl'] ?? '';
      if (_mainImage != null) {
        mainUrl = await uploadToSupabase(_mainImage!, "$safeName/main.jpg");
      }

      List<String> extraUrls = List.from(_existingExtraMediaUrls);
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
        id: widget.existingProduct?['id'],
        createdAt: widget.existingProduct?['createdAt'],
        oldName: widget.existingProduct?['isim'],
      );

      if (!isEditMode) await sendPushNotification(name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang(context, 'productSaved'))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${LanguageProvider.translate(context, 'errorOccurred')}: $e")),
      );
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
    final tr = LanguageProvider.translate;

    return Scaffold(
      backgroundColor: Colors.yellow[700],
      appBar: AppBar(
        title: Text(tr(context, 'addProduct')),
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
                labelText: tr(context, 'productName'),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Fiyat
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: tr(context, 'price'),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Ana Görsel
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickMainImage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text(tr(context, 'selectMainImage')),
                ),
                const SizedBox(width: 10),
                if (_mainImage != null)
                  Text("${tr(context, 'selectMainImage')}: ${_mainImage!.path.split('/').last}"),
              ],
            ),
            const SizedBox(height: 12),

            // Ek Medya
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickExtraImages,
                  child: Text(tr(context, 'addExtraImages'), style: const TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _pickExtraVideo,
                  child: Text(tr(context, 'addVideo'), style: const TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Açıklamalar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${tr(context, 'description')}:"),
                ..._descriptionControllers.asMap().entries.map(
                      (entry) {
                    int i = entry.key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: "${tr(context, 'description')} ${i + 1}",
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
                      child: Text(tr(context, 'addDesc')),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _removeDescription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(tr(context, 'removeDesc')),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kaydet Butonu
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                tr(context, 'saveProduct'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
