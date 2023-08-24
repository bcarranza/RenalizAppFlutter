

import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/home/presentation/screens/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes:[
    
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context,state) => const HomeScreen(),
      )

  ] 
);