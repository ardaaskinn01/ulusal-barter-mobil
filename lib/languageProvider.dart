import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('tr');

  final Map<String, Map<String, dynamic>> _localizedStrings = {
    'tr': {
      'language': 'Dil',
      'turkish': 'Türkçe',
      'english': 'İngilizce',
      'german': 'Almanca',
      'balanceTracking': 'Bakiye Takip',
      'balance': 'Bakiye',
      'addBalance': 'Bakiye Ekle',
      'removeBalance': 'Bakiye Çıkar',
      'amount': 'Miktar',
      'description': 'Açıklama',
      'cancel': 'İptal',
      'add': 'Ekle',
      'remove': 'Çıkar',
      'history': 'Geçmiş',
      'invalidInput': 'Geçerli bir miktar ve açıklama girin',
      'belowZeroError': 'Bakiye sıfırın altına inemez!',
      'noUsersFound': 'Kayıtlı kullanıcı bulunamadı',
      'errorOccurred': 'Hata oluştu',
      'noTransactionHistory': 'İşlem geçmişi bulunamadı.', // Türkçe
      'months': [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
      'listings': 'İlanlar',
      'profile': 'Profil',
      'about': 'Hakkımızda',
      'barter': 'Barter Sistemi',
      'contact': 'İletişim',
      'logout': 'Çıkış Yap',
      'deleteAccount': 'Hesabımı Sil',
      'barterSystem': 'Barter Sistemi',
      'aboutUs': 'Hakkımızda',
      'about1':
      "ULUSAL Barter A.Ş. dünyada yaygın olarak kullanılan barter sisteminin, ülkemizin ticari faaliyetlerine yeni bir soluk getirmesi amacıyla kurulmuştur.",
      'about2':
      "Güçlü sermaye ve akılcı ticaret anlayışıyla, ekonomiğe katkısıyla kurumsal yapısının yanı sıra, profesyonel ekibi ile işini sahiplenen, sorunları çözme konusunda yaratıcılığını kullanan, akılcı çözümler üreten, ULUSAL Barter A.Ş. gelişmekte olan sektörün en güçlü temsilcisidir.",
      'about3':
      "Her yıl başarısını katlayarak arttıran ULUSAL Barter A.Ş. ülkenin önde gelen büyük holdingleri ile birçok ortak projede yer almış; hizmet politikası ile yer almış olduğu işlerden olumlu referanslar almıştır. Kazandığı olumlu referansların gücü ile portföyünü zenginleştiren ULUSAL Barter A.Ş. 5000 aşkın üye sayısına ulaşmıştır.",
      'about4':
      "Gün geçtikçe artmaya devam eden üye sayısının ve stratejik ortaklarının desteğiyle elde ettiği başarıları, ülkemizde gelişmekte olan barter sektörünün, yenilikçi, vizyoner ve kazançlı bir ticaret sistemi olarak tanınmasına katkıda bulunmaktadır.",
      'about5': "Katma değerli dış Ticaret projeleri geliştirirken;",
      'about6':
      "✓ ULUSAL Barter A.Ş. misyon, vizyon ve stratejisi ile hareket ederek, Ram iç ve Dış Ticaret olarak her türlü dışve iç ticaret operasyonunu ilgili tarafların ihtiyaç ve beklentilerini karşılayarak yapmayı,",
      'about7':
      "✓ Müşteri odaklı stratejisi ile en iyi hizmeti ve kusursuz hizmet sunmayı hedeflerken; iş ahlakı ve güvenilir duruşundan ödün vermemeyi,",
      'about8':
      "✓ 26 yıllık dış ve iç ticaret sektör tecrübesi, bilgi birikimi ve uzman ekibi ile sektöre öncü olmayı ve sektör standartları belirleyecek adımlar atarak gelişmeyi,",
      'about9':
      "✓ Ülke ekonomisine katkı sağlayacak ihracat faaliyetlerinde, kurumlara sağlayacağı finansal hizmetler ile en verimli ve optimum çözümler sunmayı,",
      'about10':
      "✓ Kusursuz hizmet misyonunu ile çalışanlarını ve etkileşim içinde olduğu ilgili taraflarını da kalite yolculuğunda birlikte yanında taşımayı ve sürekli geliştirmeyi,",
      'about11':
      "✓ Ulusal ve/veya uluslararası mevzuatlara uyum yükümlülüklerini yerine getirirken; çevreci yaklaşımlar ve sosyal sorumluluk projelerine de imza atarak ilgili tarafları ve çalışanlarının bilinç seviyesini artırmayı,",
      'about12':
      "✓ Teknolojik gelişmeleri takip ederek, inovatif yaklaşımlar ile operasyon ve hizmet kalitesini sürekli dijitalleştirmeyi,",
      'about13':
      "✓ Zor olanı başarmak ve hedeflerine ulaşmak için tüm bu faaliyetleri yürütürken bilgi birikimi ve sektör deneyimlerini kalite yönetim sistemi ile kurumsal hafızaya alarak, gelecek nesillere aktarmayı ve sistemi sürekli geliştirerek sürdürmeyi taahhüt eder.",
      'about14': "Misyonumuz ve Değerlerimiz",
      'about15':
      "Ülkemizin ticaret ve yatırımlar açısından çekim merkezi ve yaşam kalitesini sürekli artıran bir ülke haline getirmek, kaynakları etkin bir şekilde kullanarak geliştirdiği yenilikçi ve özgün projeler ile üyelerinin ticari faaliyetlerini kolaylaştırmak, iş dünyası ve topluma sürdürülebilir hizmetler sunmak.",
      'about16': "Geleceğe Yönelik Vizyonumuz",
      'about17':
      "Sürdürülebilir kalkınma amaçları doğrultusunda üyelerinin sektörel gelişim ve dönüşüm süreçlerine rehberlik eden, paydaşlarıyla birlikte değer yaratan, yaşam, ticaret ve yatırımda ülkemizin rol model Barter şirketi olmak.",
      'about18': "Yönetim Kurulu Başkanı",
      'about19': "Yönetim Kurulu Başkan Vekili",
      'about20': "Yönetim Kurulu Üyesi",
      'about21': "Pazarlama Koordinatörü",
      'about22': "Medya Tanıtım Koordinatörü",
      'about23': "Bilgi İşlem Koordinatörü",
      'about24': "Müşteri Koordinatörü",
      'about25': "Hukuk Koordinatörü",
      'about26': "Muhasebe Koordinatörü",
      'about27': "Emlak Koordinatörü",
      'about28': "Müşteri Temsilcisi",
      'contactSubtitle': 'Bizimle iletişime geçmekten çekinmeyin.',
      'contactInfo': 'İletişim Bilgileri',
      'email': 'E-Mail',
      'phone': 'Telefon',
      'address': 'Adres',
      'register': 'Kayıt Ol',
      'firstName': 'Ad',
      'lastName': 'Soyad',
      'password': 'Şifre',
      'genericError': 'Bir hata oluştu.',
      'login': 'Giriş Yap',
      'forgotPassword': 'Şifremi Unuttum',
      'loginFailed': 'Giriş başarısız. Bilgilerinizi kontrol edin.',
      'userNotFound': 'Kullanıcı bulunamadı veya hesabınız silinmiş.',
      'notApproved': 'Hesabınız henüz yönetici tarafından onaylanmadı.',
      'userDataNotFound': 'Kullanıcı bilgileri bulunamadı.',
      'openMenu': 'Menüyü Aç',
      'myProfile': 'Profilim',
      'save': 'Kaydet',
      'edit': 'Düzenle',
      'updated': 'Bilgiler güncellendi',
      'emailLabel': 'E-posta adresiniz',
      'sendResetLink': 'Şifre Sıfırlama Bağlantısı Gönder',
      'sending': 'Gönderiliyor...',
      'goBack': 'Geri Dön',
      'resetLinkSent':
      'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.',
      'resetError': 'Bir hata oluştu. Lütfen e-posta adresinizi kontrol edin.',
      'offers': 'Teklifler',
      'offeredBy': 'Teklif veren',
      'noOffersYet': 'Henüz teklif yok',
      'unknownUser': 'Bilinmeyen',
      'addProduct': 'Ürün Ekle',
      'productName': 'Ürün Adı',
      'price': 'Fiyat',
      'selectMainImage': 'Ana Görsel Seç',
      'addExtraImages': 'Ek Görsel Ekle',
      'addVideo': 'Video Ekle',
      'addDesc': 'Açıklama Ekle',
      'removeDesc': 'Açıklamayı Sil',
      'saveProduct': 'Ürünü Kaydet',
      'fillRequiredFields': 'Lütfen ürün ismi, fiyat ve ana görsel ekleyin.',
      'productSaved': 'Ürün başarıyla kaydedildi.',
      'favoriteAdded': 'Favorilere eklendi',
      'favoriteRemoved': 'Favorilerden çıkarıldı',
      'offerExists': 'Teklif zaten mevcut',
      'productSold': 'Satıldı',
      'makeOffer': 'Teklif Ver',
      'withdrawOffer': 'Teklifi Geri Çek',
      'addFavorite': 'Favorilere Ekle',
      'removeFavorite': 'Favorilerden Çıkar',
      'invalidAmount': 'Geçerli bir miktar girin',
      'successfull': 'Teklif başarıyla gönderildi',
      'withdrawnOffer': 'Teklifi Geri Çekildi',
      'markAsSold': 'Satıldı İşaretle',
      'unMarkSold': 'İşareti Kaldır',
      'confirmMarkAsSold':
      'Bu ürünü gerçekten satıldı olarak işaretlemek istiyor musunuz?',
      'confirmRemoveSoldMark':
      'Bu ürünün satıldı işaretini kaldırmak istiyor musunuz?',
      'yes': 'Evet',
      'deleteProduct': 'Ürünü Sil',
      'confirmDeleteProduct': 'Bu ürünü silmek istediğinize emin misiniz?',
      'delete': 'Sil',
      'productDetails': 'Ürün Detayları',
      'listingNumber': 'İlan Numarası: ',
      'loginToSeePrice': 'Fiyatı görmek için giriş yapın',
      'otherMedia': 'Diğer Medya',
      'productTypes': [
        "Arsa", "Arazi", "Otel", "Hizmet", "Çiftlik",
        "Daire", "Villa", "Santral", "Restaurant", "Bahçe",
        "Tarla", "Parsel", "Tesis", "Zeytinlik", "Fabrika",
        "Beyaz Eşya", "Ofis", "Ev", "Malikane", "Tatil Köyü",
        "Taksi", "Tekstil", "Peyzaj", "Sera", "Estetik",
      ],
      'searchLocation': 'Konum Ara',
      'hintLocation': 'Şehir, ilçe...',
      'type': 'Tür',
      'status': 'Durum',
      'all': 'Tümü',
      'sold': 'Satılanlar',
      'unsold': 'Satılmayanlar',
      'loadingContent': 'İçerik Yükleniyor...',
      'welcomeUser': 'Hoşgeldiniz',
      'productCount': 'ürün listeleniyor',
      'requests': 'İstekler',
      'filter': 'Filtre',
      'accountHistory': 'Hesap Geçmişi',
      'favorites': 'Favoriler',
      'noFavoritesFound': 'Favorilere eklenmiş ilan bulunamadı.',
      'close': 'Kapat',
      'myFavoriteAds': 'Favori İlanlarım',
      'ad': 'İlan',
      'myFavorites': 'Favorilerim',
      'noProductsFound': 'Hiç ürün bulunamadı.',
      'unnamedProduct': 'Ürün İsimsiz',
      'detail': 'Detay',
      'swapCompleted': 'TAKAS GERÇEKLEŞTİRİLMİŞTİR',
      'pinned': 'Üste sabitlendi',
      'unpinned': 'Sıralamaya geri alındı',
      'pin': 'Sabitle',
      'unpin': 'Kaldır',
      'noPendingUsers': 'Onay bekleyen kullanıcı yok.',
      'pendingUsers': 'Onay Bekleyen Kullanıcılar',
    },
    'en': {
      'language': 'Language',
      'turkish': 'Turkish',
      'english': 'English',
      'german': 'German',
      'balanceTracking': 'Balance Tracking',
      'balance': 'Balance',
      'addBalance': 'Add Balance',
      'removeBalance': 'Remove Balance',
      'amount': 'Amount',
      'description': 'Description',
      'cancel': 'Cancel',
      'add': 'Add',
      'remove': 'Remove',
      'history': 'History',
      'invalidInput': 'Enter a valid amount and description',
      'belowZeroError': 'Balance cannot go below zero!',
      'noUsersFound': 'No users found',
      'errorOccurred': 'An error occurred',
      'noTransactionHistory': 'No transaction history found.',
      'months': [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
      'listings': 'Listings',
      'profile': 'Profile',
      'about': 'About Us',
      'barter': 'Barter System',
      'contact': 'Contact',
      'logout': 'Logout',
      'deleteAccount': 'Delete Account',
      'barterSystem': 'Barter System',
      'aboutUs': 'About Us',
      'about1':
      "ULUSAL Barter Inc. was established with the aim of bringing a new breath to the commercial activities of our country with the barter system, which is widely used in the world.",
      'about2':
      "With its strong capital and rational trade approach, its contribution to the economy, as well as its corporate structure, its professional team, which takes ownership of its work, uses its creativity in solving problems, and produces rational solutions, ULUSAL Barter Inc. is the strongest representative of the developing sector.",
      'about3':
      "Increasing its success every year, ULUSAL Barter Inc. has taken part in many joint projects with the leading large holdings of the country; with its service policy, it has received positive references from the works it has taken part in. Enriching its portfolio with the power of the positive references it has gained, ULUSAL Barter Inc. has reached over 5000 members.",
      'about4':
      "The success it has achieved with the support of its increasing number of members and strategic partners contributes to the recognition of the developing barter sector in our country as an innovative, visionary and profitable trade system.",
      'about5': "While developing value-added foreign trade projects;",
      'about6':
      "✓ Acting with the mission, vision and strategy of ULUSAL Barter A.Ş., to carry out all kinds of foreign and domestic trade operations as Ram Domestic and Foreign Trade by meeting the needs and expectations of the relevant parties,",
      'about7':
      "✓ While aiming to provide the best and perfect service with its customer-focused strategy; not to compromise on business ethics and reliable stance,",
      'about8':
      "✓ To be a pioneer in the sector with its 26 years of experience in the foreign and domestic trade sector, its knowledge and expert team, and to develop by taking steps that will set sector standards,",
      'about9':
      "✓ To provide the most efficient and optimum solutions to institutions through financial services in export activities that will contribute to the country's economy,",
      'about10':
      "✓ Carrying along its employees and stakeholders in its quality journey with its flawless service mission and continuously improving,",
      'about11':
      "✓ While fulfilling the compliance obligations with national and/or international regulations; also increasing the awareness of stakeholders and employees by signing environmentally friendly approaches and social responsibility projects,",
      'about12':
      "✓ Continuously digitalizing the quality of operations and services by following technological developments and using innovative approaches,",
      'about13':
      "✓ Undertaking to achieve the difficult and reach its goals by transferring the knowledge and sector experience accumulated through all these activities to corporate memory with the quality management system and ensuring continuity by constantly improving the system.",
      'about14': "Our Mission and Values",
      'about15':
      "To make our country a center of attraction for trade and investments and continuously improve the quality of life, to facilitate the commercial activities of its members with innovative and original projects developed by using resources effectively, and to offer sustainable services to the business world and society.",
      'about16': "Our Vision for the Future",
      'about17':
      "To become Turkey’s role model barter company in life, trade, and investment by guiding its members in their sectoral development and transformation processes in line with the goals of sustainable development and creating value together with its stakeholders.",
      'about18': "Chairman of the Board",
      'about19': "Vice Chairman of the Board",
      'about20': "Board Member",
      'about21': "Marketing Coordinator",
      'about22': "Media Promotion Coordinator",
      'about23': "IT Coordinator",
      'about24': "Customer Coordinator",
      'about25': "Legal Coordinator",
      'about26': "Accounting Coordinator",
      'about27': "Real Estate Coordinator",
      'about28': "Customer Representative",
      'contactSubtitle': 'Feel free to get in touch with us.',
      'contactInfo': 'Contact Information',
      'email': 'E-Mail',
      'phone': 'Phone',
      'address': 'Address',
      'register': 'Register',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'password': 'Password',
      'genericError': 'An error occurred.',
      'login': 'Login',
      'forgotPassword': 'Forgot Password',
      'loginFailed': 'Login failed. Please check your credentials.',
      'userNotFound': 'User not found or account has been deleted.',
      'notApproved': 'Your account is not yet approved by the admin.',
      'userDataNotFound': 'User data not found.',
      'openMenu': 'Open Menu',
      'myProfile': 'My Profile',
      'save': 'Save',
      'edit': 'Edit',
      'updated': 'Information updated',
      'emailLabel': 'Your email address',
      'sendResetLink': 'Send Password Reset Link',
      'sending': 'Sending...',
      'goBack': 'Go Back',
      'resetLinkSent': 'Password reset link has been sent to your email.',
      'resetError': 'An error occurred. Please check your email address.',
      'offers': 'Offers',
      'offeredBy': 'Offered by',
      'noOffersYet': 'No offers yet',
      'unknownUser': 'Unknown',
      'addProduct': 'Add Product',
      'productName': 'Product Name',
      'price': 'Price',
      'selectMainImage': 'Select Main Image',
      'addExtraImages': 'Add Extra Images',
      'addVideo': 'Add Video',
      'addDesc': 'Add Description',
      'removeDesc': 'Remove Description',
      'saveProduct': 'Save Product',
      'fillRequiredFields': 'Please enter product name, price and image.',
      'productSaved': 'Product saved successfully.',
      'favoriteAdded': 'Added to favorites',
      'favoriteRemoved': 'Removed from favorites',
      'offerExists': 'Offer already exists',
      'productSold': 'Sold',
      'makeOffer': 'Make Offer',
      'withdrawOffer': 'Withdraw Offer',
      'addFavorite': 'Add to Favorites',
      'removeFavorite': 'Remove from Favorites',
      'invalidAmount': 'Enter a valid amount',
      'successfull': 'Offer sent successfully',
      'withdrawnOffer': 'The offer was withdrawn',
      'markAsSold': 'Mark as Sold',
      'unmarkSold': 'Unmark Sold',
      'confirmMarkAsSold': 'Do you really want to mark this product as sold?',
      'confirmRemoveSoldMark':
      'Do you want to remove the sold mark from this product?',
      'yes': 'Yes',
      'deleteProduct': 'Delete Product',
      'confirmDeleteProduct': 'Are you sure you want to delete this product?',
      'delete': 'Delete',
      'productDetails': 'Product Details',
      'listingNumber': 'Listing Number: ',
      'loginToSeePrice': 'Login to see the price',
      'otherMedia': 'Other Media',
      'productTypes': [
        "Land",
        "Field",
        "Hotel",
        "Service",
        "Farm",
        "Apartment",
        "Villa",
        "Power Plant",
        "Restaurant",
        "Garden",
        "Farmland",
        "Plot",
        "Facility",
        "Olive Grove",
        "Factory",
        "White Goods",
        "Office",
        "House",
        "Mansion",
        "Holiday Village",
        "Taxi",
        "Textile",
        "Landscape",
        "Greenhouse",
        "Aesthetics",
      ],
      'searchLocation': 'Search Location',
      'hintLocation': 'City, district...',
      'type': 'Type',
      'status': 'Status',
      'all': 'All',
      'sold': 'Sold',
      'unsold': 'Unsold',
      'loadingContent': 'Loading content...',
      'welcomeUser': 'Welcome',
      'productCount': 'products listed',
      'requests': 'Requests',
      'filter': 'Filter',
      'accountHistory': 'Account History',
      'favorites': 'Favorites',
      'noFavoritesFound': 'No favorite ads found.',
      'close': 'Close',
      'myFavoriteAds': 'My Favorite Ads',
      'ad': 'Ad',
      'myFavorites': 'My Favorites',
      'noProductsFound': 'No products found.',
      'unnamedProduct': 'Unnamed Product',
      'detail': 'Detail',
      'swapCompleted': 'BARTER COMPLETED',
      'pinned': 'Pinned to top',
      'unpinned': 'Returned to sorting',
      'pin': 'Pin',
      'unpin': 'Unpin',
      'noPendingUsers': 'No pending users.',
      'pendingUsers': 'Pending Users',
    },
    'de': {
      'language': 'Sprache',
      'turkish': 'Türkisch',
      'english': 'Englisch',
      'german': 'Deutsch',
      'balanceTracking': 'Kontostand-Überwachung',
      'balance': 'Kontostand',
      'addBalance': 'Guthaben hinzufügen',
      'removeBalance': 'Guthaben entfernen',
      'amount': 'Betrag',
      'description': 'Beschreibung',
      'cancel': 'Abbrechen',
      'add': 'Hinzufügen',
      'remove': 'Entfernen',
      'history': 'Verlauf',
      'invalidInput':
      'Geben Sie einen gültigen Betrag und eine Beschreibung ein',
      'belowZeroError': 'Kontostand kann nicht negativ sein!',
      'noUsersFound': 'Keine Benutzer gefunden',
      'errorOccurred': 'Ein Fehler ist aufgetreten',
      'noTransactionHistory': 'Keine Transaktionshistorie gefunden.',
      'months': [
        'Januar',
        'Februar',
        'März',
        'April',
        'Mai',
        'Juni',
        'Juli',
        'August',
        'September',
        'Oktober',
        'November',
        'Dezember',
      ],
      'listings': 'Anzeigen',
      'profile': 'Profil',
      'about': 'Über uns',
      'barter': 'Tauschsystem',
      'contact': 'Kontakt',
      'logout': 'Abmelden',
      'deleteAccount': 'Konto löschen',
      'barterSystem': 'Tauschsystem',
      'aboutUs': 'Über uns',
      'about1':
      "ULUSAL Barter Inc. wurde mit dem Ziel gegründet, den Handelsaktivitäten unseres Landes mit dem weltweit weit verbreiteten Tauschsystem neuen Schwung zu verleihen.",
      'about2':
      "Mit seinem starken Kapital und rationalen Handelsansatz, seinem Beitrag zur Wirtschaft sowie seiner Unternehmensstruktur und seinem professionellen Team, das Verantwortung für seine Arbeit übernimmt, seine Kreativität bei der Lösung von Problemen einsetzt und rationale Lösungen hervorbringt, ist ULUSAL Barter Inc. der stärkste Vertreter des Entwicklungssektors.",
      'about3':
      "ULUSAL Barter Inc. steigert seinen Erfolg jedes Jahr und hat an vielen gemeinsamen Projekten mit den führenden Großkonzernen des Landes teilgenommen. Dank seiner Servicepolitik hat das Unternehmen für die Arbeiten, an denen es beteiligt war, positive Referenzen erhalten. Dank der positiven Referenzen, die es erhalten hat, konnte ULUSAL Barter Inc. sein Portfolio erweitern und hat mittlerweile über 5.000 Mitglieder.",
      'about4':
      "Der mit der Unterstützung der wachsenden Zahl an Mitgliedern und strategischen Partnern erzielte Erfolg trägt zur Anerkennung des sich entwickelnden Tauschsektors in unserem Land als innovatives, visionäres und profitables Handelssystem bei.",
      'about5': "Bei der Entwicklung wertschöpfender Außenhandelsprojekte;",
      'about6':
      "✓ Handeln im Sinne der Mission, Vision und Strategie von ULUSAL Barter A.Ş., alle Arten von Außen- und Inlandshandelsgeschäften als Ram Domestic and Foreign Trade durchzuführen und dabei die Bedürfnisse und Erwartungen der jeweiligen Parteien zu erfüllen,",
      'about7':
      "✓ Mit dem Ziel, mit seiner kundenorientierten Strategie den besten und perfekten Service zu bieten, ohne Kompromisse bei der Geschäftsethik und der zuverlässigen Haltung einzugehen,",
      'about8':
      "✓ Mit seiner 26-jährigen Erfahrung im Außen- und Binnenhandel, seinem Wissen und seinem Expertenteam ein Pionier in der Branche zu sein und sich durch Schritte weiterzuentwickeln, die Branchenstandards setzen,",
      'about9':
      "✓ Bereitstellung der effizientesten und optimalen Lösungen für Institutionen durch Finanzdienstleistungen im Exportbereich, die zur Wirtschaft des Landes beitragen,",
      'about10':
      "✓ Die Mitarbeiter und interessierten Parteien auf dem Weg zur Qualität mitzunehmen und kontinuierlich zu verbessern – mit der Mission eines fehlerfreien Service,",
      'about11':
      "✓ Während der Einhaltung nationaler und/oder internationaler Vorschriften auch durch umweltfreundliche Ansätze und soziale Projekte das Bewusstsein der Beteiligten und Mitarbeiter zu stärken,",
      'about12':
      "✓ Durch Verfolgung technologischer Entwicklungen und innovative Ansätze die Qualität von Betrieb und Dienstleistung kontinuierlich zu digitalisieren,",
      'about13':
      "✓ Beim Erreichen anspruchsvoller Ziele das gesammelte Wissen und die Branchenerfahrung in das Unternehmensgedächtnis aufzunehmen und durch ständige Weiterentwicklung fortzuführen.",
      'about14': "Unsere Mission und Werte",
      'about15':
      "Unser Land zu einem Anziehungspunkt für Handel und Investitionen zu machen, die Lebensqualität stetig zu verbessern, die Handelsaktivitäten seiner Mitglieder durch effektiven Ressourceneinsatz und innovative Projekte zu erleichtern und nachhaltige Dienstleistungen für Wirtschaft und Gesellschaft zu bieten.",
      'about16': "Unsere Vision für die Zukunft",
      'about17':
      "Ein Vorbild-Barterunternehmen unseres Landes in Leben, Handel und Investitionen zu sein, das seine Mitglieder bei der branchenspezifischen Entwicklung begleitet und gemeinsam mit den Stakeholdern Werte schafft – im Einklang mit den Zielen nachhaltiger Entwicklung.",
      'about18': "Vorsitzender des Vorstands",
      'about19': "Stellvertretender Vorsitzender des Vorstands",
      'about20': "Vorstandsmitglied",
      'about21': "Marketing-Koordinator",
      'about22': "Medien- und Werbungskoordinator",
      'about23': "IT-Koordinator",
      'about24': "Kundenkoordinator",
      'about25': "Rechtskoordinator",
      'about26': "Buchhaltungskoordinator",
      'about27': "Immobilienkoordinator",
      'about28': "Kundenbetreuer",
      'contactSubtitle': 'Zögern Sie nicht, uns zu kontaktieren.',
      'contactInfo': 'Kontaktinformationen',
      'email': 'E-Mail',
      'phone': 'Telefon',
      'address': 'Adresse',
      'register': 'Registrieren',
      'firstName': 'Vorname',
      'lastName': 'Nachname',
      'password': 'Passwort',
      'genericError': 'Ein Fehler ist aufgetreten.',
      'login': 'Anmelden',
      'forgotPassword': 'Passwort vergessen',
      'loginFailed': 'Anmeldung fehlgeschlagen. Bitte prüfen Sie Ihre Daten.',
      'userNotFound': 'Benutzer nicht gefunden oder Konto wurde gelöscht.',
      'notApproved': 'Ihr Konto wurde noch nicht vom Administrator genehmigt.',
      'userDataNotFound': 'Benutzerdaten wurden nicht gefunden.',
      'openMenu': 'Menü öffnen',
      'myProfile': 'Mein Profil',
      'save': 'Speichern',
      'edit': 'Bearbeiten',
      'updated': 'Informationen wurden aktualisiert',
      'emailLabel': 'Ihre E-Mail-Adresse',
      'sendResetLink': 'Passwort-Reset-Link senden',
      'sending': 'Wird gesendet...',
      'goBack': 'Zurück',
      'resetLinkSent': 'Passwort-Reset-Link wurde an Ihre E-Mail gesendet.',
      'resetError':
      'Ein Fehler ist aufgetreten. Bitte überprüfen Sie Ihre E-Mail-Adresse.',
      'offers': 'Angebote',
      'offeredBy': 'Angeboten von',
      'noOffersYet': 'Noch keine Angebote',
      'unknownUser': 'Unbekannt',
      'addProduct': 'Produkt hinzufügen',
      'productName': 'Produktname',
      'price': 'Preis',
      'selectMainImage': 'Hauptbild auswählen',
      'addExtraImages': 'Weitere Bilder hinzufügen',
      'addVideo': 'Video hinzufügen',
      'addDesc': 'Beschreibung hinzufügen',
      'removeDesc': 'Beschreibung entfernen',
      'saveProduct': 'Produkt speichern',
      'fillRequiredFields': 'Bitte Produktname, Preis und Bild eingeben.',
      'productSaved': 'Produkt erfolgreich gespeichert.',
      'favoriteAdded': 'Zu Favoriten hinzugefügt',
      'favoriteRemoved': 'Aus Favoriten entfernt',
      'offerExists': 'Angebot existiert bereits',
      'productSold': 'Verkauft',
      'makeOffer': 'Angebot machen',
      'withdrawOffer': 'Angebot zurückziehen',
      'addFavorite': 'Zu Favoriten hinzufügen',
      'removeFavorite': 'Aus Favoriten entfernen',
      'invalidAmount': 'Geben Sie einen gültigen Betrag',
      'successfull': 'Angebot erfolgreich versendet',
      'withdrawnOffer': 'Das Angebot wurde zurückgezogen',
      'markAsSold': 'Verkauft Markieren',
      'unmarkSold': 'Markier Entfernen',
      'confirmMarkAsSold':
      'Möchten Sie dieses Produkt wirklich als verkauft markieren?',
      'confirmRemoveSoldMark':
      'Möchten Sie die Verkauft-Markierung von diesem Produkt entfernen?',
      'yes': 'Ja',
      'deleteProduct': 'Produkt löschen',
      'confirmDeleteProduct':
      'Sind Sie sicher, dass Sie dieses Produkt löschen möchten?',
      'delete': 'Löschen',
      'productDetails': 'Produktdetails',
      'listingNumber': 'Anzeigenummer: ',
      'loginToSeePrice': 'Melden Sie sich an, um den Preis zu sehen',
      'otherMedia': 'Weitere Medien',
      'productTypes': [
        "Grundstück",
        "Feld",
        "Hotel",
        "Dienstleistung",
        "Bauernhof",
        "Wohnung",
        "Villa",
        "Kraftwerk",
        "Restaurant",
        "Garten",
        "Ackerland",
        "Parzelle",
        "Anlage",
        "Olivenhain",
        "Fabrik",
        "Weiße Ware",
        "Büro",
        "Haus",
        "Herrenhaus",
        "Ferienanlage",
        "Taxi",
        "Textil",
        "Landschaftsbau",
        "Gewächshaus",
        "Ästhetik",
      ],
      'searchLocation': 'Standort suchen',
      'hintLocation': 'Stadt, Bezirk...',
      'type': 'Typ',
      'status': 'Status',
      'all': 'Alle',
      'sold': 'Verkauft',
      'unsold': 'Nicht verkauft',
      'loadingContent': 'Inhalt wird geladen...',
      'welcomeUser': 'Willkommen',
      'productCount': 'Produkte aufgelistet',
      'requests': 'Anfragen',
      'filter': 'Filter',
      'accountHistory': 'Kontoverlauf',
      'favorites': 'Favoriten',
      'noFavoritesFound': 'Keine favorisierten Anzeigen gefunden.',
      'close': 'Schließen',
      'myFavoriteAds': 'Meine Favoritenanzeigen',
      'ad': 'Anzeige',
      'myFavorites': 'Meine Favoriten',
      'noProductsFound': 'Keine Produkte gefunden.',
      'unnamedProduct': 'Unbenanntes Produkt',
      'detail': 'Details',
      'swapCompleted': 'TAUSCH ABGESCHLOSSEN',
      'pinned': 'Oben angeheftet',
      'unpinned': 'Zurück zur Sortierung',
      'pin': 'Anheften',
      'unpin': 'Lösen',
      'noPendingUsers': 'Keine Benutzer zur Genehmigung.',
      'pendingUsers': 'Benutzer zur Genehmigung',

    },
  };

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage(); // Uygulama başladığında dil bilgisini yükle
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode') ?? 'tr';
    _currentLocale = Locale(langCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  static String translate(BuildContext context, String key) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return provider._localizedStrings[provider
            ._currentLocale
            .languageCode]?[key] ??
        key;
  }

  static List<String> getMonths(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    final months =
        provider._localizedStrings[provider
            ._currentLocale
            .languageCode]?['months'];
    if (months is List<String>) return months;
    return []; // fallback boş liste
  }

  List<String> get productTypes {
    final list = _localizedStrings[_currentLocale.languageCode]?['productTypes'];
    print("Current locale: $_currentLocale");
    print("Product types for locale: $list");
    if (list is List<String>) return List<String>.from(list);
    return getProductTypesTR();
  }

  static List<String> getProductTypesTR() {
    return [
      "Arsa", "Arazi", "Otel", "Hizmet", "Çiftlik",
      "Daire", "Villa", "Santral", "Restaurant", "Bahçe",
      "Tarla", "Parsel", "Tesis", "Zeytinlik", "Fabrika",
      "Beyaz Eşya", "Ofis", "Ev", "Malikane", "Tatil Köyü",
      "Taksi", "Tekstil", "Peyzaj", "Sera", "Estetik",
    ];
  }

  static List<String> getProductTypesLocalized(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    final localized = provider._localizedStrings[provider._currentLocale.languageCode]?['productTypes'];

    if (localized == null) {
      print("Localized productTypes is null for language: ${provider._currentLocale.languageCode}");
    } else if (localized is! List<String>) {
      print("Localized productTypes is NOT List<String>: $localized");
    }

    if (localized is List<String>) return localized;

    return getProductTypesTR(); // fallback Türkçe
  }
}
