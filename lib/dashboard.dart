import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ulusalbarter/teklifler.dart';
import 'package:ulusalbarter/urunekle.dart';
import 'package:ulusalbarter/urunprofil.dart';

import 'appDrawer.dart';
import 'bakiye.dart';
import 'bakiyegecmisi.dart';
import 'main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formatCurrency = NumberFormat.decimalPattern('tr_TR');

  bool loading = true;
  final TextEditingController _locationController = TextEditingController();

  // Arama yapılan konumu tutar
  String searchLocation = '';

  // Tüm ürün türlerinin listesi (örnek değerlerle)
  List<String> productTypes = [
    "Arsa",
    "Arazi",
    "Otel",
    "Hizmet",
    "Çiftlik",
    "Daire",
    "Villa",
    "Santral",
    "Restaurant",
    "Bahçe",
    "Tarla",
    "Parsel",
    "Tesis",
    "Zeytinlik",
    "Fabrika",
    "Beyaz Eşya",
    "Ofis",
    "Ev",
    "Malikane",
    "Tatil Köyü",
    "Taksi",
    "Tekstil",
    "Peyzaj",
    "Sera",
    "Estetik",
  ];

  // Seçili ürün türleri
  Set<String> selectedTypes = {};
  bool showFilterMobile = false;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> pendingRequests = [];
  List<Map<String, dynamic>> filteredProducts = [];

  void applyFilters() {
    setState(() {
      filteredProducts =
          products.where((product) {
            final productName =
                (product['isim'] ?? '').toString().toLowerCase();
            final location = searchLocation.toLowerCase();

            // Konum: ya konum alanında eşleşecek ya da ürün ismi konum içerecek
            final locationMatch =
                searchLocation.isEmpty ||
                (product['konum'] != null &&
                    product['konum'].toString().toLowerCase().contains(
                      location,
                    )) ||
                productName.contains(location);

            // Tür: ya seçili türlerden biriyle eşleşecek ya da isimde geçecek
            final typeMatch =
                selectedTypes.isEmpty ||
                (product['tur'] != null &&
                    selectedTypes.contains(product['tur'])) ||
                selectedTypes.any(
                  (type) => productName.contains(type.toLowerCase()),
                );

            return locationMatch && typeMatch;
          }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    await fetchUserData();
    await fetchProducts();
    await fetchPendingRequests();
    setState(() {
      loading = false;
    });
  }

  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        userData = doc.data();
      }
    }
  }

  Future<void> fetchProducts() async {
    final snapshot =
        await _firestore
            .collection('products')
            .orderBy('createdAt', descending: true)
            .get();

    products =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    applyFilters(); // filtreli listeyi de güncelle
  }

  Future<void> fetchPendingRequests() async {
    final snapshot = await _firestore.collection('users').get();
    pendingRequests =
        snapshot.docs
            .where(
              (doc) =>
                  doc.data().containsKey('isAccept') &&
                  doc['isAccept'] == false,
            )
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
  }

  Future<void> approveUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({'isAccept': true});
    await fetchPendingRequests();
    setState(() {});
  }

  Widget buildFilterPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Konum Ara",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: "Şehir, ilçe...",
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchLocation = value;
            });
            applyFilters();
          },
        ),
        const SizedBox(height: 16),
        const Text(
          "Tür",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Column(
          children:
              productTypes.map((type) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(type),
                  value: selectedTypes.contains(type),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedTypes.add(type);
                      } else {
                        selectedTypes.remove(type);
                      }
                    });
                    applyFilters();
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/newbg02.png',
                  width: 150, // istediğin boyut
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'İçerik Yükleniyor...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
        : Scaffold(
          backgroundColor: const Color(0xFFFFF9C4),
          drawer: AppDrawer(parentContext: context),

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(160),
            child: AppBar(
              backgroundColor: Colors.yellow[700],
              elevation: 0,
              automaticallyImplyLeading:
                  false, // Manuel menü düğmesi kullanıyoruz
              leading: Builder(
                builder:
                    (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: 'Menüyü Aç',
                    ),
              ),
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Text(
                        'Hoşgeldiniz, ${userData?['ad'] ?? ''} ${userData?['soyad'] ?? ''}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Text(
                        '${products.length} ürün listeleniyor',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (userData?['role'] == 'admin')
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCompactButton(
                              label: 'Bakiye Takip',
                              color: Colors.red[900]!,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Bakiye()),
                                );
                              },
                            ),
                            SizedBox(width: 8),
                            _buildCompactButton(
                              label: 'Ürün Ekle',
                              color: Colors.red[700]!,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UrunEkleScreen()),
                                );
                              },
                            ),
                            SizedBox(width: 8),
                            _buildCompactButton(
                              label: 'İstekler',
                              color: Colors.red[500]!,
                              trailing: pendingRequests.isNotEmpty
                                  ? CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white,
                                child: Text(
                                  '${pendingRequests.length}',
                                  style: const TextStyle(fontSize: 12, color: Colors.red),
                                ),
                              )
                                  : null,
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  builder: (_) => buildPendingRequestSheet(),
                                );
                              },
                            ),
                            SizedBox(width: 8),
                            _buildCompactButton(
                              label: 'Teklifler',
                              color: Colors.red[400]!,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => OffersPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildCompactButton(
                              label: 'Filtre',
                              color: Colors.red[200]!,
                              onPressed: () {
                                setState(() {
                                  showFilterMobile = true;
                                });
                              },
                            ),
                          ],
                        ),

                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // İlk satır: Barter Bakiyesi
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 8),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Barter Bakiyesi: ${NumberFormat.decimalPattern('tr_TR').format(userData?['bakiye'] ?? 0)} ₺',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // İkinci satır: Hesap Geçmişi ve Filtre butonları
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(72, 42),
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BakiyeGecmisiScreen(
                                          userId: userData?['uid'],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.history, size: 21),
                                  label: const Text(
                                    'Hesap Geçmişi',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildCompactButton(
                                label: 'Filtre',
                                color: Colors.red[200]!,
                                onPressed: () {
                                  setState(() {
                                    showFilterMobile = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    products.isEmpty
                        ? const Center(child: Text("Hiç ürün bulunamadı."))
                        : GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.7,
                              ),
                          itemBuilder: (_, index) {
                            final product = filteredProducts[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              UrunProfil(id: product['isim']),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          color: Colors.grey[200],
                                          child:
                                              product['anaGorselUrl'] != null
                                                  ? Image.network(
                                                    product['anaGorselUrl'],
                                                    fit: BoxFit.contain,
                                                  )
                                                  : const Icon(
                                                    Icons.image_not_supported,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['isim'] ?? 'Ürün İsimsiz',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  product['fiyat'] != null
                                                      ? (RegExp(
                                                            r'\d\s*(₺|\$|€)$',
                                                          ).hasMatch(
                                                            product['fiyat']
                                                                .toString()
                                                                .trim(),
                                                          )
                                                          ? product['fiyat']
                                                          : '${product['fiyat']} ₺')
                                                      : '',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => UrunProfil(
                                                              id: product['id'],
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors
                                                              .deepPurple
                                                              .shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'Detay',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.deepPurple,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
              if (showFilterMobile)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.5,
                    ), // Arka planın opaklığı
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 300, // panel genişliği
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showFilterMobile = false;
                                  });
                                },
                                child: const Text("Kapat"),
                              ),
                              const SizedBox(height: 16),
                              buildFilterPanel(), // JS’deki FilterPanel bileşeni gibi
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
  }

  Widget buildPendingRequestSheet() {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder:
          (_, controller) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Onay Bekleyen Kullanıcılar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child:
                      pendingRequests.isEmpty
                          ? const Center(
                            child: Text("Onay bekleyen kullanıcı yok."),
                          )
                          : ListView.builder(
                            controller: controller,
                            itemCount: pendingRequests.length,
                            itemBuilder: (_, index) {
                              final user = pendingRequests[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text('${user['ad']} ${user['soyad']}'),
                                  subtitle: Text(user['adres'] ?? 'Adres yok'),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    tooltip: "Onayla",
                                    onPressed: () async {
                                      await approveUser(user['id']);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
    );
  }
}

Widget _buildRedButton({
  required String label,
  required VoidCallback onPressed,
  Color color = Colors.red, // Varsayılan renk
  Widget? trailing,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        if (trailing != null) ...[const SizedBox(width: 6), trailing],
      ],
    ),
  );
}

Widget _buildCompactButton({
  required String label,
  required Color color,
  required VoidCallback onPressed,
  Widget? trailing,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      minimumSize: Size(0, 48), // Yükseklik biraz arttı, rahat olsun diye
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
    onPressed: onPressed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        if (trailing != null) ...[
          SizedBox(height: 4),
          trailing,
        ],
      ],
    ),
  );
}
