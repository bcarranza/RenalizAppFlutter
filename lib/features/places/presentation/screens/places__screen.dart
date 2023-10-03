import 'package:flutter/material.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';

import '../widgets/widgets.dart';

class PlacesScreen extends StatelessWidget {
  /// Creates a RootScreen
  const PlacesScreen({required this.subPath, Key? key}) : super(key: key);

  /// The label

  /// The path to the detail page
  final String subPath;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: PlacesList(),
    );
  }
}
