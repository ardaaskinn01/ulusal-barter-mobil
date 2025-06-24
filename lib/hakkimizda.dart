import 'package:flutter/material.dart';

import 'appDrawer.dart';
import 'languageProvider.dart';

class HakkimizdaPage extends StatelessWidget {
  const HakkimizdaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String t(String key) => LanguageProvider.translate(context, key);
    return Scaffold(
      drawer: AppDrawer(parentContext: context),
      appBar: AppBar(
        backgroundColor: Colors.yellow[700], // Şeffaf yapabilirsin
        elevation: 0,
        title: Text(t('aboutUs')),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg29.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.65),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Ana içerik scrollable olsun diye SingleChildScrollView
          SafeArea(
            child: Column(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Başlık
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.yellow, width: 4),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(t('aboutUs'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        Text(t('about1'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 12),
                        Text(t('about2'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 12),
                        Text(t('about3'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 12),
                        Text(t('about4'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 12),
                        Text(t('about5'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 12),
                        Text(t('about6'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 8),
                        Text(t('about7'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 8),
                        Text(t('about8'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 8),
                        Text(t('about9'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 8),
                        Text(t('about10'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 8),
                        Text(t('about11'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 8),
                        Text(t('about12'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),
                        const SizedBox(height: 8),
                        Text(t('about13'), style: const TextStyle(color: Colors
                            .white, height: 1.6)),

                        const SizedBox(height: 40),

                        // Kartlar (Misyon ve Vizyon)
                        Column(
                          children: [
                            Card(
                              color: const Color.fromRGBO(31, 41, 55, 0.8),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(24)),
                                side: BorderSide(
                                    color: Color(0xFFFFD600), width: 4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LanguageProvider.translate(
                                          context, 'about14'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      LanguageProvider.translate(
                                          context, 'about15'),
                                      style: const TextStyle(
                                          color: Colors.white, height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Card(
                              color: const Color.fromRGBO(31, 41, 55, 0.8),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(24)),
                                side: BorderSide(
                                    color: Color(0xFFFFD600), width: 4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LanguageProvider.translate(
                                          context, 'about16'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      LanguageProvider.translate(
                                          context, 'about17'),
                                      style: const TextStyle(
                                          color: Colors.white, height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 60),

                        // Yönetim Kurulu
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 48, horizontal: 24),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFD600), Color(0xFFFDB813)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Başkan
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                width: 280,
                                child: Column(
                                  children: [
                                    Text(
                                      "Özkan ŞİMŞEK",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Color(0xFFFDB813),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      t('about18'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 48),

                              Wrap(
                                spacing: 24,
                                runSpacing: 16,
                                alignment: WrapAlignment.center,
                                children: [
                                  yonetimKuruluUyeCard(
                                      context, "Hasan ULAŞZADE", 'about19'),
                                  yonetimKuruluUyeCard(
                                      context, "Selim ANIŞ", 'about20'),
                                ],
                              ),

                              const SizedBox(height: 48),

                              // Koordinatörler (3 sütunlu Wrap)
                              Wrap(
                                spacing: 24,
                                runSpacing: 16,
                                alignment: WrapAlignment.center,
                                children: [
                                  yonetimKuruluUyeCard(
                                      context, "Cengiz ŞİMŞEK", 'about21'),
                                  yonetimKuruluUyeCard(
                                      context, "Hüseyin ULAŞZADE", 'about22'),
                                  yonetimKuruluUyeCard(
                                      context, "Burak KOÇAK", 'about23'),
                                  yonetimKuruluUyeCard(
                                      context, "Mehmet KARABAĞ", 'about24'),
                                  yonetimKuruluUyeCard(
                                      context, "Hüseyin GÜRER", 'about24'),
                                  yonetimKuruluUyeCard(
                                      context, "Beyza Nur KOŞAR", 'about25'),
                                  yonetimKuruluUyeCard(
                                      context, "Kerim ÇAKMAK", 'about26'),
                                  yonetimKuruluUyeCard(
                                      context, "Yunus GÖREL", 'about27'),
                                  yonetimKuruluUyeCard(
                                      context, "İbrahim KAHRAMAN", 'about27'),
                                  yonetimKuruluUyeCard(
                                      context, "Büşra KOLUKISA", 'about28'),
                                ],
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Yönetim Kurulu Üye kartı oluşturucu fonksiyon
  Widget yonetimKuruluUyeCard(BuildContext context, String name,
      String titleKey) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFFFDB813),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            LanguageProvider.translate(context, titleKey),
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
