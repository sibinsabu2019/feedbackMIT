import 'dart:async';
import 'dart:developer';

import 'package:feedback/ui/pages/admin/admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/ui/widgets/snackbar.dart';

class LoginControllerAdmin {
  static Future<void> loginAdmin(BuildContext context, String selectedRole, TextEditingController emailController, TextEditingController passwordController) async {
   
    

     
      await Provider.of<AdminProvider>(context, listen: false)
          .findAdmin(emailController.text.trim(), passwordController.text.trim());

      log("message for the admin${Provider.of<AdminProvider>(context, listen: false).searchResult}");
      Timer(const Duration(seconds: 2), () {
        if (Provider.of<AdminProvider>(context, listen: false).searchResult == "admin found!" && FirebaseAuth.instance.currentUser == null) {
          CustomSnackbar.ErrorSnackbar(context, "your password is incorrect");
         
        } else if (FirebaseAuth.instance.currentUser == null) {
          
          CustomSnackbar.ErrorSnackbar(context, "Not Find this mail in admin section");
        } else {
          if (FirebaseAuth.instance.currentUser!.email == emailController.text.trim()) {
            CustomSnackbar.success(context, "log in success");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Admin()));
          
          }
        }
      });
    }
  }

