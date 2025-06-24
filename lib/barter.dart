import 'package:flutter/material.dart';
import 'appDrawer.dart';
import 'languageProvider.dart';

class BarterPage extends StatefulWidget {
  const BarterPage({super.key});

  @override
  State<BarterPage> createState() => _BarterPageState();
}

class _BarterPageState extends State<BarterPage> {
  final ScrollController _scrollController = ScrollController();


  final List<String> slides = List.generate(12, (i) => 'assets/images/${i + 1}.png');

  void scrollTo(String direction) {
    double scrollAmount = MediaQuery.of(context).size.width < 640 ? 320 : 540;
    _scrollController.animateTo(
      direction == 'up'
          ? _scrollController.offset - scrollAmount
          : _scrollController.offset + scrollAmount,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Menü simgesinin rengini beyaz yapar
        title: Text(LanguageProvider.translate(context, 'barterSystem'),
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: AppDrawer(parentContext: context),
      extendBodyBehindAppBar: true, // AppBar'ı arka plan görselinin üstüne bindirir
      body: Stack(
        children: [
          // Arka plan görseli + overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg15.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),

          // Ana içerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [

                  // Slayt alanı
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: slides.length,
                          padding: const EdgeInsets.only(right: 12),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  slides[index],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: 250,
                                ),
                              ),
                            );
                          },
                        ),

                        Positioned(
                          top: 50,
                          right: -10,
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                                onPressed: () => scrollTo('up'),
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                onPressed: () => scrollTo('down'),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}