import 'package:flutter/material.dart';
import 'package:renalizapp/features/shared/shared.dart';
import 'package:renalizapp/features/test/presentation/screens/patient_form.dart';

class TestScreen extends StatefulWidget {
  static const String name = 'test_screen';

  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int selectedIndex = 1;

  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          if (wideScreen)
            DisappearingNavigationDrawer(
              selectedIndex: selectedIndex,
              backgroundColor: colorScheme.tertiaryContainer,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¡Haz culminado tu test!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Image.asset('assets/renalizapp_icon.png', width: 300),
                Center(
                  child: Text(
                    '¿Deseas formar parte de la \n comunidad?',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientForm()),
                    );
                  },
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: wideScreen
          ? null
          : DisappearingBottomNavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
    );
  }
}
