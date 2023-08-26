import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/home/presentation/screens/screens.dart';
import 'package:renalizapp/features/test/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/test', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/test',
    name: TestScreen.name,
    builder: (context, state) => const TestScreen(),
  )
]);
