import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_balcoder_firebasecourse/ui/home_page.dart';

main() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAnkeGuTDM347o8cFZ3-tAb_EAu-PeT5aA",
          authDomain: "cursofirebase-balcoder.firebaseapp.com",
          projectId: "cursofirebase-balcoder",
          storageBucket: "cursofirebase-balcoder.appspot.com",
          messagingSenderId: "98866720545",
          appId: "1:98866720545:web:cfba0f54c5f94df9379860",
          measurementId: "G-XNM65XQ796"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
