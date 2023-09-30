import 'package:flutter/material.dart';
import 'package:renalizapp/features/home/presentation/widgets/main_list.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.subPath, Key? key}) : super(key: key);

  final String subPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(child: MainList()),
    );
  }
}
