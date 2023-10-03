import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';

class PlacesScreen extends StatelessWidget {
  /// Creates a RootScreen
  const PlacesScreen({required this.subPath, Key? key}) : super(key: key);

  /// The label

  /// The path to the detail page
  final String subPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Estoy en Places',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () => context.go(subPath),
              child: const Text('Moverse a ruta hija'),
            ),
          ],
        ),
      ),
    );
  }
}
