import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/home/home.dart';
import 'package:renalizapp/features/places/places.dart';
import 'package:renalizapp/features/home/presentation/screens/blog_detail.dart';
import 'package:renalizapp/features/test/presentation/screens/history_page.dart';
import 'package:renalizapp/features/test/presentation/screens/history_page_detail.dart';
import 'package:renalizapp/features/test/presentation/screens/login_screen.dart';
import 'package:renalizapp/features/test/presentation/screens/mentions_screen.dart';
import 'package:renalizapp/features/test/presentation/screens/patient_form.dart';
import 'package:renalizapp/features/test/presentation/screens/perfil_file.dart';
import 'package:renalizapp/features/test/presentation/screens/questions_interface.dart';
import 'package:renalizapp/features/test/test.dart';

import '../../features/shared/widgets/scaffold_with_nested_navigation/scaffold_nested.dart';

//private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorTestKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTest');
final _shellNavigatorHelpCenterKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHelpCenter');
final _shellNavigatorLoginKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellLogin');

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
                  const NoTransitionPage(child: HomeScreen(subPath: '/home')),
              routes: [
                GoRoute(
                  path: 'blog-detail',
                  builder: (context, state) =>
                      BlogDetail(appRouter: GoRouter.of(context)),
                )
              ])
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
                  builder: (context, state) =>
                      PatientForm(appRouter: GoRouter.of(context)),
                ),
                GoRoute(
                  path: 'historial',
                  builder: (context, state) =>
                      HistoryPage(appRouter: GoRouter.of(context)),
                ),
                GoRoute(
                  path: 'quizz',
                  builder: (context, state) =>
                      QuizzPage(appRouter: GoRouter.of(context)),
                ),
                GoRoute(
                    path: 'historial/detalle_historial/:uid',
                    name: "HistoryDetail",
                    builder: (context, state) {
                      final Map<String, String> params = state.pathParameters;
                      return HistoryPageDetail(
                        uid: params['uid'],
                      );
                    }),
              ],
            ),
          ],
        ),

        //helpcenter branch
        StatefulShellBranch(
            navigatorKey: _shellNavigatorHelpCenterKey,
            routes: [
              GoRoute(
                path: '/helpcenters',
                pageBuilder: (context, state) => const NoTransitionPage(
                    child: PlacesScreen(subPath: '/chat/1')),
                routes: [
                  // Agrega una subruta a la rama "helpcenter"
                  GoRoute(
                    path: 'detailCenter/:uid',
                    name: "PlaceDetail",
                    builder: (context, state) {
                      final Map<String, String> params = state.pathParameters;
                      return PlaceDetailScreen(
                        uid: params['uid'],
                      );
                    },
                  ),
                ],
              ),
            ]),
      ]),
  GoRoute(
    path: '/login',
    pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
    routes: [
      // Agrega una subruta a la rama "login"
    ],
  ),
  GoRoute(
    path: '/profile',
    pageBuilder: (context, state) =>
        NoTransitionPage(child: PerfilFile(appRouter: GoRouter.of(context))),
  ),
  GoRoute(
    path: '/mentions',
    pageBuilder: (context, state) => NoTransitionPage(
        child: EquipoPage(
      appRouter: GoRouter.of(context),
    )),
  ),
]);
