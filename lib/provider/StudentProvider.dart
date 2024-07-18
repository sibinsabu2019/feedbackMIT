import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  DocumentSnapshot? documentSnapshot;
  List<String> SELECTBATCH = [];
  List<String> SELECTBRANCH = [];
  String? Batch;
  String? Branch;
  String? SelectedRole;
  String? selectedsubject;
  List<String> subjectList = [];
  String? FormSubject;
  Map<String, dynamic> qstnList = {};
  String? Error;
  String Selectsem = "Select Sem";
  String? currentFaculty;

  void clearData() {
    currentFaculty = null;
    Error = null;
    SELECTBATCH.clear();
    SELECTBRANCH.clear();
    Batch = null;
    Branch = null;
    SelectedRole = null;
    selectedsubject = null;
    subjectList.clear();
    FormSubject = null;
    qstnList.clear();
    notifyListeners();
  }

  Future<void> fetchyear() async {
    SELECTBATCH.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("feedback").get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
      log(documentSnapshot["year"]);
      SELECTBATCH.add(documentSnapshot["year"]);

      notifyListeners();
    }
  }

  Future<void> fetchBranch(String selectedYear) async {
    SELECTBRANCH.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("feedback")
        .doc(selectedYear)
        .collection("Branch")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
      log(documentSnapshot["branch"]);
      SELECTBRANCH.add(documentSnapshot["branch"]);

      notifyListeners();
    }
  }

  Future<bool> CreateStudent({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      log("messageeeeeessssss");
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Map<String, dynamic> data = {
          "name": name,
          "email": email,
          "batch": Batch,
          "branch": Branch,
        };

        await FirebaseFirestore.instance
            .collection("student")
            .doc(user.uid)
            .set(data)
            .then((value) => log("successs"));
      }
      return true;
    } on FirebaseAuthException catch (ex) {
      log(ex.code);
      Error = ex.code;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log("sign in success");
      return true;
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
      Error = ex.code.toString();
      notifyListeners();
      return false;
    }
  }

  Future<DocumentSnapshot> fetchStudent() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("student")
        .doc(user!.uid)
        .get();
    return documentSnapshot;
  }

  Future<QuerySnapshot> fetchSem() async {
    QuerySnapshot? querySnapshot;
    log("dataaaaatat");
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection("feedback")
          .doc(Batch)
          .collection("Branch")
          .doc(Branch)
          .collection("sem")
          .get();
    } on FirebaseException catch (ex) {
      log(ex.code);
    }
    return querySnapshot!;
  }

  Future<QuerySnapshot> fetchFeedback() async {
    
    // notifyListeners();
   
        
        
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("fields").get();



    return querySnapshot;
  }
  Future<Map>fetchOldFeedback(String qustn)async
  {
   documentSnapshot=  await FirebaseFirestore.instance
        .collection(Batch.toString())
        .doc(FormSubject.toString())
        .collection(FormSubject.toString()).doc(qustn)
        .get();
        Map<String,dynamic>demo=documentSnapshot!.data() as Map<String,dynamic>;
        return demo;
        // log(demo.toString());
        
  }

  Future<DocumentSnapshot> fetchCurrentFaculty() async {
    DocumentSnapshot Snapshot = await FirebaseFirestore.instance
        .collection(Batch.toString())
        .doc(FormSubject.toString())
        .get();
    return Snapshot;
  }

  Future<void> updateForm(String qstn, Map<String, dynamic> data3,Map<String,dynamic>demo2
      ) async {
    await FirebaseFirestore.instance
        .collection(Batch.toString())
        .doc(FormSubject.toString())
        .collection(FormSubject.toString())
        .doc(qstn)
        .update(data3);
    await FirebaseFirestore.instance
        .collection("student")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FormSubject.toString())
        .doc(qstn)
        .set(demo2);
  }

  Future<void> feedbackRecode() async {
    qstnList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("student")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FormSubject.toString())
        .get();
    for (int i = 0; i < querySnapshot.size; i++) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
      log(documentSnapshot["qstn"]);
      qstnList[documentSnapshot["qstn"]] = documentSnapshot["qstn"];
      qstnList["${documentSnapshot["qstn"]}value"] = documentSnapshot["value"];
    }
  }
}
