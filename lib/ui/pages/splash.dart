import 'dart:async';
import 'dart:developer';

import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/ui/pages/Faculty/facultyHome.dart';
import 'package:feedback/ui/pages/Student/Home.dart';
import 'package:feedback/ui/pages/admin/admin.dart';
import 'package:feedback/ui/pages/hod/Hodpage.dart';
import 'package:feedback/ui/pages/login.dart';
import 'package:feedback/ui/pages/principal/principalHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/Logo.png"),
        )
      ),
    );
  }

  fetchUser(BuildContext context) async {
    log("sssssssss");
    if (FirebaseAuth.instance.currentUser != null) {
      await Provider.of<AdminProvider>(context, listen: false)
          .findAdmin(FirebaseAuth.instance.currentUser!.email.toString(), "");
      if (Provider.of<AdminProvider>(context, listen: false).searchResult ==
          "admin found!") {
        log("admin found");
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Admin(),
          ));
        });
      } else {
        log("admin is nulll");
        await Provider.of<AdminProvider>(context, listen: false)
            .findHod(FirebaseAuth.instance.currentUser!.email.toString(), "");

        if (Provider.of<AdminProvider>(context, listen: false).searchResult ==
            "HOD found!") {
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Hodpage(),
            ));
          });
        } else {
          await Provider.of<AdminProvider>(context, listen: false)
              .findPrincipal(
                  FirebaseAuth.instance.currentUser!.email.toString(), "");

          if (Provider.of<AdminProvider>(context, listen: false).searchResult ==
              "principal found!") {
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const PrincipalHome(),
              ));
            });
          } else {
            await Provider.of<AdminProvider>(context, listen: false)
                .findfaculty(
                    FirebaseAuth.instance.currentUser!.email.toString(), "");

            if (Provider.of<AdminProvider>(context, listen: false)
                    .searchResult ==
                "Faculty found!") {
              Timer(Duration(seconds: 3), () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const FacultyHome(),
                ));
              });
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>const Homescreen(),));
              log("message");
            }
          }
        }
      }
    } else {
      log("signout...");
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      });
    }
  }
}
