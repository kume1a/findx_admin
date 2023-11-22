// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/main/main_page.dart';
import '../../pages/sign_in_page.dart';
import 'routes.dart';

part 'typed_routes.g.dart';

@TypedGoRoute<MainRoute>(path: Routes.main)
class MainRoute extends GoRouteData {
  const MainRoute();

  @override
  Widget build(_, __) => const MainPage();
}

@TypedGoRoute<SignInRoute>(path: Routes.signIn)
class SignInRoute extends GoRouteData {
  const SignInRoute();

  @override
  Widget build(_, __) => const SignInPage();
}
