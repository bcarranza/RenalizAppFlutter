import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/chat/chat.dart';
import 'package:renalizapp/features/home/home.dart';
import 'package:renalizapp/features/test/presentation/screens/login_screen.dart';
import 'package:renalizapp/features/test/presentation/screens/patient_form.dart';
import 'package:renalizapp/features/test/presentation/screens/perfil_file.dart';
import 'package:renalizapp/features/test/test.dart';

import '../../features/shared/widgets/scaffold_with_nested_navigation/scaffold_nested.dart';

//private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorTestKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTest');
final _shellNavigatorChattKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellChat');

final appRouter =
    GoRouter(initialLocation: '/', navigatorKey: _rootNavigatorKey, routes: [
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        //Home branch
        StatefulShellBranch(navigatorKey: _shellNavigatorHomeKey, routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen(subPath: '/home/1')),
          )
        ]),

        StatefulShellBranch(
          navigatorKey: _shellNavigatorTestKey,
          routes: [
            GoRoute(
              path: '/test',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: TestScreen(
                  subPath: '/test/patient-form',
                ),
              ),
              routes: [
                GoRoute(
                  path: 'patient-form',
                  builder: (context, state) => PatientForm(),
                ),
                GoRoute(
                  path: 'patient-file', // Ruta existente
                  builder: (context, state) => PerfilFile(),
                ),
                GoRoute(
                  path: 'login', // Agrega una nueva ruta para LoginScreen
                  builder: (context, state) => LoginScreen(),
                ),
              ],
            ),
          ],
        ),

        //Chat branch
        StatefulShellBranch(navigatorKey: _shellNavigatorChattKey, routes: [
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatScreen(subPath: '/chat/1')),
          )
        ]),
      ])
]);