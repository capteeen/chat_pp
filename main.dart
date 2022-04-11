import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:chat_app/screens/HomePage/HomepageHelpers.dart';
import 'package:chat_app/screens/feed/Feed.dart';
import 'package:chat_app/screens/feed/feedHelpers.dart';
import 'package:chat_app/screens/landingpage/landinUtils.dart';
import 'package:chat_app/screens/Chatroom/Chatroom.dart';
import 'package:chat_app/screens/Chatroom/chatroomHelpers.dart';
import 'package:chat_app/screens/messege/GroupMessageHelpers.dart';
import 'package:chat_app/screens/profile/profileHelpers.dart';

import 'package:chat_app/services/FirebaseOperations.dart';
import 'package:chat_app/utils/uploadPost.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/landingpage/landingHelpers.dart';
import 'package:chat_app/screens/landingpage/landingServices.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/constans/Constantcolors.dart';
import 'screens/splashscreen/splashScreen.dart';
import 'package:chat_app/services/Authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/utils/uploadPost.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        canvasColor: Colors.transparent,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    ;
    return MultiProvider(
      child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: constantColors.blueColor,
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent)),
      providers: [
        ChangeNotifierProvider(
          create: (_) => EmailValidator(),
        ),
        ChangeNotifierProvider(
          create: (_) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadPost(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingUtils(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomepageHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseOperations(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatroomHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => GroupMessageHelpers(),
        ),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(
          create: (_) => GroupMessageHelpers(),
        ),
      ],
    );
  }
}
