import 'package:flutter/material.dart';

import 'appDrawer.dart';

class HakkimizdaPage extends StatelessWidget {
  const HakkimizdaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(parentContext: context),
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Şeffaf yapabilirsin
          elevation: 0,
          title: const Text('Hakkımızda'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Başlık
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.yellow, width: 4),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 8),
                          child: const Text(
                            'Hakkımızda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Metin içerikleri (paragraflar)
                        const Text(
                          "ULUSAL Barter A.Ş. dünyada yaygın olarak kullanılan barter sisteminin, ülkemizin ticari faaliyetlerine yeni bir soluk getirmesi amacıyla kurulmuştur.",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          "Güçlü sermaye ve akılcı ticaret anlayışıyla, ekonomiğe katkısıyla kurumsal yapısının yanı sıra, profesyonel ekibi ile işini sahiplenen, sorunları çözme konusunda yaratıcılığını kullanan, akılcı çözümler üreten, ULUSAL Barter A.Ş. gelişmekte olan sektörün en güçlü temsilcisidir.",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          "Her yıl başarısını katlayarak arttıran ULUSAL Barter A.Ş. ülkenin önde gelen büyük holdingleri ile birçok ortak projede yer almış; hizmet politikası ile yer almış olduğu işlerden olumlu referanslar almıştır. Kazandığı olumlu referansların gücü ile portföyünü zenginleştiren ULUSAL Barter A.Ş. 5000 aşkın üye sayısına ulaşmıştır.",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          "Gün geçtikçe artmaya devam eden üye sayısının ve stratejik ortaklarının desteğiyle elde ettiği başarıları, ülkemizde gelişmekte olan barter sektörünün, yenilikçi, vizyoner ve kazançlı bir ticaret sistemi olarak tanınmasına katkıda bulunmaktadır.",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          "Katma değerli dış Ticaret projeleri geliştirirken;",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          "✓ ULUSAL Barter A.Ş. misyon, vizyon ve stratejisi ile hareket ederek, Ram iç ve Dış Ticaret olarak her türlü dışve iç ticaret operasyonunu ilgili tarafların ihtiyaç ve beklentilerini karşılayarak yapmayı,",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "✓ Müşteri odaklı stratejisi ile en iyi hizmeti ve kusursuz hizmet sunmayı hedeflerken; iş ahlakı ve güvenilir duruşundan ödün vermemeyi,",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "✓ 26 yıllık dış ve iç ticaret sektör tecrübesi, bilgi birikimi ve uzman ekibi ile sektöre öncü olmayı ve sektör standartları belirleyecek adımlar atarak gelişmeyi,",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "✓ Ülke ekonomisine katkı sağlayacak ihracat faaliyetlerinde, kurumlara sağlayacağı finansal hizmetler ile en verimli ve optimum çözümler sunmayı,",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "✓ Kusursuz hizmet misyonunu ile çalışanlarını ve etkileşim içinde olduğu ilgili taraflarını da kalite yolculuğunda birlikte yanında taşımayı ve sürekli geliştirmeyi,",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "✓ Ulusal ve/veya uluslararası mevzuatlara uyum yükümlülüklerini yerine getirirken; çevreci yaklaşımlar ve sosyal sorumluluk projelerine de imza atarak ilgili tarafları ve çalışanlarının bilinç seviyesini artırmayı,",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "✓ Teknolojik gelişmeleri takip ederek, inovatif yaklaşımlar ile operasyon ve hizmet kalitesini sürekli dijitalleştirmeyi,",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "✓ Zor olanı başarmak ve hedeflerine ulaşmak için tüm bu faaliyetleri yürütürken bilgi birikimi ve sektör deneyimlerini kalite yönetim sistemi ile kurumsal hafızaya alarak, gelecek nesillere aktarmayı ve sistemi sürekli geliştirerek sürdürmeyi taahhüt eder.",
                          style: TextStyle(color: Colors.white, height: 1.6),
                        ),

                        const SizedBox(height: 40),

                        // Kartlar (Misyon ve Vizyon)
                        Column(
                          children: const [
                            Card(
                              color: Color.fromRGBO(31, 41, 55, 0.8), // bg-gray-800/80
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(24)),
                                side: BorderSide(color: Color(0xFFFFD600), width: 4), // yellow border
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Misyonumuz ve Değerlerimiz",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Ülkemizin ticaret ve yatırımlar açısından çekim merkezi ve yaşam kalitesini sürekli artıran bir ülke haline getirmek, kaynakları etkin bir şekilde kullanarak geliştirdiği yenilikçi ve özgün projeler ile üyelerinin ticari faaliyetlerini kolaylaştırmak, iş dünyası ve topluma sürdürülebilir hizmetler sunmak.",
                                      style: TextStyle(color: Colors.white, height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            Card(
                              color: Color.fromRGBO(31, 41, 55, 0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(24)),
                                side: BorderSide(color: Color(0xFFFFD600), width: 4),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Geleceğe Yönelik Vizyonumuz",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Sürdürülebilir kalkınma amaçları doğrultusunda üyelerinin sektörel gelişim ve dönüşüm süreçlerine rehberlik eden, paydaşlarıyla birlikte değer yaratan, yaşam, ticaret ve yatırımda ülkemizin rol model Barter şirketi olmak.",
                                      style: TextStyle(color: Colors.white, height: 1.5),
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
                          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFD600), Color(0xFFFDB813)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Yönetim Kurulu Başlığı
                              const Text(
                                "YÖNETİM KURULU",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Başkan
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                width: 280,
                                child: Column(
                                  children: const [
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
                                      "Yönetim Kurulu Başkanı",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Yönetim Kurulu Üyeleri (3 sütun görünümü için Wrap)
                              Wrap(
                                spacing: 24,
                                runSpacing: 16,
                                alignment: WrapAlignment.center,
                                children: [
                                  yonetimKuruluUyeCard("Prof. Dr. Rıdvan KANAT", "Yönetim Kurulu Üyesi"),
                                  yonetimKuruluUyeCard("Dr. Arif TAŞ", "Yönetim Kurulu Üyesi"),
                                  yonetimKuruluUyeCard("Burhanettin ŞAFAK", "Yönetim Kurulu Üyesi"),
                                  yonetimKuruluUyeCard("Sedat KILIÇ", "Yönetim Kurulu Üyesi"),
                                  yonetimKuruluUyeCard("Sedat ŞAHİN", "Yönetim Kurulu Üyesi"),
                                  yonetimKuruluUyeCard("İsmet SARIKAYA", "Yönetim Kurulu Üyesi"),
                                ],
                              ),

                              const SizedBox(height: 48),

                              // Koordinatörler Başlığı
                              const Text(
                                "KOORDİNATÖRLER",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Koordinatörler (3 sütunlu Wrap)
                              Wrap(
                                spacing: 24,
                                runSpacing: 16,
                                alignment: WrapAlignment.center,
                                children: [
                                  yonetimKuruluUyeCard("Cengiz ŞİMŞEK", "Pazarlama Koordinatörü"),
                                  yonetimKuruluUyeCard("Hüseyin ULAŞZADE", "Medya Tanıtım Koordinatörü"),
                                  yonetimKuruluUyeCard("Burak KOÇAK", "Bilgi İşlem Koordinatörü"),
                                  yonetimKuruluUyeCard("Mehmet KARABAĞ", "Müşteri Koordinatörü"),
                                  yonetimKuruluUyeCard("Hüseyin GÜRER", "Müşteri Koordinatörü"),
                                  yonetimKuruluUyeCard("Beyza Nur KOŞAR", "Hukuk Koordinatörü"),
                                  yonetimKuruluUyeCard("Kerim ÇAKMAK", "Muhasebe Koordinatörü"),
                                  yonetimKuruluUyeCard("Yunus GÖREL", "Emlak Koordinatörü"),
                                  yonetimKuruluUyeCard("İbrahim KAHRAMAN", "Emlak Koordinatörü"),
                                  yonetimKuruluUyeCard("Büşra KOLUKISA", "Müşteri Temsilcisi"),
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
  Widget yonetimKuruluUyeCard(String name, String title) {
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
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
