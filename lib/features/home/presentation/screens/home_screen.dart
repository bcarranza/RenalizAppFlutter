import 'package:flutter/material.dart';
import 'package:renalizapp/features/home/presentation/widgets/main_list.dart';

class HomeScreen extends StatelessWidget {
  /// Creates a RootScreen
  const HomeScreen({required this.subPath, Key? key}) : super(key: key);

  /// The label

  /// The path to the detail page
  final String subPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renalizapp'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(child: MainList()),
    );
  }
}
