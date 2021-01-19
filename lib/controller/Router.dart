import 'package:flutter/material.dart';
import 'package:login_demo_for_finlite/views/Home.dart';
import 'package:login_demo_for_finlite/views/Login.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (ctx) => Home());
      case 'login':
        return MaterialPageRoute(builder: (ctx) => Login());
    }
  }
}
