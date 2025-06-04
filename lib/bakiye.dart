import 'package:flutter/material.dart';

class Bakiye extends StatelessWidget {
  const Bakiye({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bakiye Takip'),
      ),
      body: const Center(
        child: Text('Bakiye takip sayfası (şimdilik boş)'),
      ),
    );
  }
}
