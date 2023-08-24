import 'package:flutter/material.dart';
import 'package:renalizapp/features/shared/shared.dart';
class HomeScreen extends StatefulWidget {

  static const String name = 'home_screen';

const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedIndex = 1;


  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;
    return  Scaffold(
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