import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final isUserLoggedIn = authProvider.currentUser != null;

        return AppBar(
          leading: GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/mentions');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/renalizapp_icon_noText.png',
                width: 32,
                height: 32,
              ),
            ),
          ),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontFamily: "Martian Mono",
              fontSize: isUserLoggedIn ? 22 : 18,
              fontWeight: isUserLoggedIn ? FontWeight.bold : FontWeight.normal,
              fontStyle: isUserLoggedIn ? FontStyle.italic : FontStyle.normal,
              color: isUserLoggedIn ? const Color(0xFF00629D) : Colors.black,
            ),
            child: const Text("RenalizApp"),
          ),
          centerTitle: true,
          actions: [
            if (isUserLoggedIn)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: Row(
                  key: const Key("loggedIn"),
                  children: [
                    IconButton(
                      key: const Key("profileIcon"),
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        GoRouter.of(context).go('/profile');
                      },
                    ),
                    IconButton(
                      key: const Key("logoutIcon"),
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        authProvider.signOut();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ),
            if (!isUserLoggedIn)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: IconButton(
                  key: const Key("loggedOutIcon"),
                  icon: const Icon(Icons.person_outlined),
                  onPressed: () {
                    GoRouter.of(context).go('/profile');
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
