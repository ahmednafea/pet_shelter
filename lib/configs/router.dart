import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart';
import 'package:pet_shelter/core/screens/add_adoption_request_screen.dart';
import 'package:pet_shelter/core/screens/home_screen.dart';
import 'package:pet_shelter/core/screens/splash_screen.dart';
import 'package:pet_shelter/identity/screens/login_view.dart';
import 'package:pet_shelter/identity/screens/signup_screen.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          name: "home",
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: 'login',
          name: "login",
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: 'signup',
          name: "signup",
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),

      ],
    ),
  ],
);