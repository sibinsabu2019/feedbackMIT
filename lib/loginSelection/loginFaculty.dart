import 'dart:async';
import 'dart:developer';

import 'package:feedback/ui/pages/Faculty/facultyHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/ui/widgets/snackbar.dart';

class LoginControllerFaculty {
  static Future<void> loginFaculty(BuildContext context, String selectedRole, TextEditingController emailController, TextEditingController passwordController) async {
   
    

     
      await Provider.of<AdminProvider>(context, listen: false)
          .findfaculty (emailController.text.trim(), passwordController.text.trim());

      log("message for the hod${Provider.of<AdminProvider>(context, listen: false).searchResult}");
      Timer(const Duration(seconds: 2), () {
        if (Provider.of<AdminProvider>(context, listen: false).searchResult == "Faculty found!" && FirebaseAuth.instance.currentUser == null) {
          CustomSnackbar.ErrorSnackbar(context, "your password is incorrect");
         
        } else if (FirebaseAuth.instance.currentUser == null) {
          
          CustomSnackbar.ErrorSnackbar(context, "Not Find this mail in faculty section");
        } else {
          if (FirebaseAuth.instance.currentUser!.email == emailController.text.trim()) {
            CustomSnackbar.success(context, "log in success");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FacultyHome()));
          
          }
        }
      });
    }
  }

