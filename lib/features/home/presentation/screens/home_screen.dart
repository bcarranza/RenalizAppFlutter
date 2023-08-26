import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/home/presentation/widgets/main_list.dart';

class HomeScreen extends StatelessWidget {
  /// Creates a RootScreen
  const HomeScreen({ required this.subPath, Key? key})
      : super(key: key);

  /// The label


  /// The path to the detail page
  final String subPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renalizapp'),
      ),
      body: Center(
        child: MainList()
      ),
    );
  }
}