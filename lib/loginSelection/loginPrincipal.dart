import 'dart:async';
import 'dart:developer';

import 'package:feedback/ui/pages/principal/principalHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feedback/provider/adminProvider.dart';

import 'package:feedback/ui/widgets/snackbar.dart';

class LoginControllerPrincipal {
  static Future<void> loginPrincipal(BuildContext context, String selectedRole, TextEditingController emailController, TextEditingController passwordController) async {
   
    

     
      await Provider.of<AdminProvider>(context, listen: false)
          .findPrincipal (emailController.text.trim(), passwordController.text.trim());

      log("message for the hod${Provider.of<AdminProvider>(context, listen: false).searchResult}");
      Timer(const Duration(seconds: 2), () {
        if (Provider.of<AdminProvider>(context, listen: false).searchResult == "principal found!" && FirebaseAuth.instance.currentUser == null) {
          CustomSnackbar.ErrorSnackbar(context, "your password is incorrect");
         
        } else if (FirebaseAuth.instance.currentUser == null) {
          
          CustomSnackbar.ErrorSnackbar(context, "Not Find this mail in Hod section");
        } else {
          if (FirebaseAuth.instance.currentUser!.email == emailController.text.trim()) {
            CustomSnackbar.success(context, "log in success");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const PrincipalHome ()));
          
          }
        }
      });
    }
  }

