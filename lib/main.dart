

import 'package:feedback/firebase_options.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/provider/facultyProvider.dart';

import 'package:feedback/ui/pages/splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uid =const Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AdminProvider>(
        create: (context) => AdminProvider(),
      ),
      ChangeNotifierProvider<CreateForm>(
        create: (context) => CreateForm(),
      ),
      ChangeNotifierProvider<StudentProvider>(create:  (context) => StudentProvider(),
      ),
      ChangeNotifierProvider<facultyProvider>(create: (context) => facultyProvider(),),
      ChangeNotifierProvider<Hodprovider>(create:(context) => Hodprovider(),)
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});
  

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const splash(),
    );
  }


 
}
