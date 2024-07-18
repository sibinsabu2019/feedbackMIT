import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class AdminProvider extends ChangeNotifier {
  User? user;
   String? searchResult;
   String? selectedRole;
   String? selectedYearStudents;
   String? selectedBranchStudents;
   List<String>DepartmentList=[];
   String? Error;
  
  void clearData()
  { 
    searchResult=null;
    selectedRole=null;
    selectedBranchStudents=null;
    selectedYearStudents=null;
    DepartmentList.clear();
     Error=null;

  } 
   
  
  Future<bool> signinCredentials(String email, String password,String name,String branch) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email.toLowerCase(), password: password);
      log("success");
      user = await FirebaseAuth.instance.currentUser;
      notifyListeners();

      log("the current User${user!.email.toString()}");
      log("the current emailis$email");
      Map<String, dynamic>? data;
      if (user!.email == email.toLowerCase()) {
       
        log("message");
       if(selectedRole=="Principal")
       {
           data = {"email": email.toLowerCase(),"name":name,"id":user!.uid};
           notifyListeners();
       }
       else{
         data = {"email": email.toLowerCase(),"name":name,"id":user!.uid,"branch":branch};
       }
       
        try {
          await FirebaseFirestore.instance
              .collection(selectedRole!)
              .doc(user!.uid)
              .set(data);
          FirebaseAuth.instance.signOut();

        await  FirebaseAuth.instance.signInWithEmailAndPassword(email: "mitadmin@gmail.com", password: "123456");
        } on FirebaseException catch (ex) {
          log(ex.code);
        }
      
      }
        return true;
    } on FirebaseAuthException catch (ex) {
      
      log(ex.message!.toUpperCase());
      Error=ex.code;
      return false;
    }
  }
  

  Future<void> findHod(String hodEmail,String password) async {
    log("hod finding....");

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HOD')
          .where('email', isEqualTo: hodEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        searchResult = 'HOD found!';
        notifyListeners();
        try{
          FirebaseAuth.instance.signInWithEmailAndPassword(email: hodEmail, password: password);
        }on FirebaseAuthException catch(ex)
        {
          log(ex.code);
        }


      } else {
        searchResult = 'HOD not found!';
        notifyListeners();
      }
    } catch (e) {
      searchResult = 'Error occurred: $e';
      notifyListeners();
    }
    log(searchResult.toString());
  }
   Future<void> findfaculty(String facultyMail,String password) async {
    log("faculty finding....");

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Faculty')
          .where('email', isEqualTo: facultyMail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        searchResult = 'Faculty found!';
        notifyListeners();
        try{
          FirebaseAuth.instance.signInWithEmailAndPassword(email: facultyMail, password: password);
        }on FirebaseAuthException catch(ex)
        {
          log(ex.code);
        }


      } else {
        searchResult = 'Faculty not found!';
        notifyListeners();
      }
    } catch (e) {
      searchResult = 'Error occurred: $e';
      notifyListeners();
    }
    log(searchResult.toString());
  }
  Future<void> findPrincipal(String facultyMail,String password) async {
    log("Principal finding....");

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Principal')
          .where('email', isEqualTo: facultyMail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        searchResult = 'principal found!';
        notifyListeners();
        try{
          FirebaseAuth.instance.signInWithEmailAndPassword(email: facultyMail, password: password);
        }on FirebaseAuthException catch(ex)
        {
          log(ex.code);
        }


      } else {
        searchResult = 'principal not found!';
        notifyListeners();
      }
    } catch (e) {
      searchResult = 'Error occurred: $e';
      notifyListeners();
    }
    log(searchResult.toString());
  }
  Future<void> findAdmin(String adminmail,String password) async {
    log("Admin finding....");

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: adminmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        searchResult = 'admin found!';
        notifyListeners();
        try{
          FirebaseAuth.instance.signInWithEmailAndPassword(email: adminmail, password: password);
        }on FirebaseAuthException catch(ex)
        {
          log(ex.code);
        }


      } else {
        searchResult = 'admin not found!';
        notifyListeners();
      }
    } catch (e) {
      searchResult = 'Error occurred: $e';
      notifyListeners();
    }
    log(searchResult.toString());
  }
  Future<void> AddForm(List<String> Form) async {
  try {
    for (int i = 0; i < Form.length; i++) {
      Map<String, dynamic> data = {
        "qstn": Form[i],
        "value": 0,
      };
      await FirebaseFirestore.instance
          .collection("HodForm")
          .doc(Form[i])
          .set(data);
      print("Document updated: ${Form[i]}");
    }
  } on FirebaseException catch (ex) {
    print("Firestore Error: ${ex.message}");
  }
}


Future<QuerySnapshot>fetchHodFeedback()async{
  return  await FirebaseFirestore.instance.collection("HodForm").get();
}
Future<QuerySnapshot>fetchFeedback()async{
  return  await FirebaseFirestore.instance.collection("fields").get();
}
   Future<void>FetchDepartment()async
   {
    log("enter to the departmet list");
    DepartmentList.clear();
  QuerySnapshot querySnapshot=  await FirebaseFirestore.instance.collection("Department").get();
   for(int i=0;i<querySnapshot.size;i++)
   {
    DocumentSnapshot documentSnapshot=querySnapshot.docs[i];
     DepartmentList.add(documentSnapshot["branch"]);
   }
    log(DepartmentList.toString());

   }

void AddmoreFields(String fields,List<String>parameters) async
{
  parameters.removeWhere((element) => element.isEmpty);
  Map<String,dynamic>data={};
  data["qstn"]=fields;
 data["total"]=0;
for(int i=0;i<parameters.length;i++)
{
data[parameters[i]]=0;
await FirebaseFirestore.instance.collection("fields").doc(fields).set(data);
}

}

}
