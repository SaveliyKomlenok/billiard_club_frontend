import 'package:flutter/material.dart';

class CuePage extends StatelessWidget {
  const CuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cue page'),
      ),
      body: const Center(
        child: Text('This is Cue page'),
      ),
    );
  }
}