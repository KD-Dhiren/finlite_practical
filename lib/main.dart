import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:login_demo_for_finlite/controller/Router.dart';
import 'package:login_demo_for_finlite/provider/NoValueNotifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoValueNotifier>(
          create: (BuildContext context) {
            return NoValueNotifier();
          },
        ),
        ChangeNotifierProvider<ProgressNotifier>(
          create: (BuildContext context) {
            return ProgressNotifier();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Login',
        onGenerateRoute: Routers.generateRoute,
        initialRoute: 'login',
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Color(0xffC62827),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
