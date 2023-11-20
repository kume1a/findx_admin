// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/main/main_page.dart';
import '../../pages/sign_in_page.dart';

part 'typed_routes.g.dart';

@TypedGoRoute<SignInRoute>(path: '/signIn')
class SignInRoute extends GoRouteData {
  const SignInRoute();

  @override
  Widget build(_, __) => const SignInPage();
}

@TypedGoRoute<MainRoute>(path: '/')
class MainRoute extends GoRouteData {
  const MainRoute();

  @override
  Widget build(_, __) => const MainPage();
}
