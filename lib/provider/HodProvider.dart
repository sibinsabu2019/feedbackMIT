import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Hodprovider extends ChangeNotifier {
  String? selectedYear;
  String? uid;
  String? selectSubject;
  bool? barchart;
  
  DocumentSnapshot? documentSnapshot;
  List<String> feedbackList = [];
  String? Department;
 double totalper=0;

  void clearData() {
    Department = null;
    selectedYear = null;
    uid = null;
    selectSubject = null;
    barchart = null;
    documentSnapshot = null;
    feedbackList.clear();
  }

  Future<DocumentSnapshot> fetchsubfac() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(selectedYear.toString())
        .doc(selectSubject.toString())
        .get();
    return documentSnapshot;
  }

  Future<DocumentSnapshot> FetchSubjects() async {
    return documentSnapshot!;
  }

  Future<DocumentSnapshot> fetchCurrentHod() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("HOD").doc(user!.uid).get();

    Department = documentSnapshot["branch"];
    notifyListeners();
    return documentSnapshot;
  }

  Future<QuerySnapshot> fetchFacultys() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Faculty")
        .where("branch", isEqualTo: Department)
        .get();
    return querySnapshot;
  }

  Future<QuerySnapshot> fetchYear() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("feedback").get();
    return querySnapshot;
  }

  Future<QuerySnapshot> FetchSem() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("feedback")
        .doc(selectedYear)
        .collection("Branch")
        .doc(Department)
        .collection("sem")
        .get();
    log(" year${selectedYear.toString()}");
    log(" Department${Department.toString()}");
    log("the length of the docs${querySnapshot.size}");
    for (var doc in querySnapshot.docs) {
      log("sem${doc["sem"].toString()}");
    }

    return querySnapshot;
  }

  Future<QuerySnapshot> fetchBarchart() async {
    double sum= 0;
    double avg = 0;
     double total = 0;
     double persum=0;
    log("hhhhhhfgjfytfydtddty");
    log(selectedYear.toString());
    log(selectSubject.toString());
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(selectedYear.toString())
        .doc(selectSubject.toString())
        .collection(selectSubject.toString())
        .get();
    for (int i = 0; i < querySnapshot.size; i++) {
      DocumentSnapshot documentSnapshot = await querySnapshot.docs[i];
      Map<String, dynamic> database =
      documentSnapshot.data() as Map<String, dynamic>;
      
      total = (database["total"] * 4).toDouble(); 
      database.remove("qstn");
    database.remove("total");
    Map<String, double> demo = {};
    database.forEach((key, value) {
      if (value is num) {
        sum += value.toDouble();
        demo[key] = value.toDouble();
      } else {
        log("not num");
      }
    });
    persum += (sum / total) * 100.0;
    

    log("the total sum is ${sum}");
      // log("Total percentage so far: ${(persum).toString()}");
    }
    
    
   
    return querySnapshot;
  }

  Future<QuerySnapshot> fetchFacultyform() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("HodForm").get();
    return querySnapshot;
  }

  Future<void> SubmitForm(String qstn, int value) async {
    log("working");
    log(uid.toString());
    Map<String, dynamic> data = {"year": selectedYear};
    Map<String, dynamic> data2 = {"qstn": qstn, "value": value};
    try {
      await FirebaseFirestore.instance
          .collection("Faculty")
          .doc(uid)
          .collection("Form")
          .doc(selectedYear)
          .set(data);
      await FirebaseFirestore.instance
          .collection("Faculty")
          .doc(uid)
          .collection("Form")
          .doc(selectedYear)
          .collection("Form")
          .doc(qstn)
          .set(data2);
    } on FirebaseException catch (ex) {
      log(ex.message.toString());
    }
  }

  Future<void> selected() async {
    feedbackList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Faculty")
        .doc(uid)
        .collection("Form")
        .doc(selectedYear)
        .collection("Form")
        .get();

    for (int i = 0; i < querySnapshot.size; i++) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
      feedbackList.add(documentSnapshot["qstn"]);
    }
  }
// principal provider ********   ////////////

  Future<QuerySnapshot> fetchRatingYear() async {
    return await FirebaseFirestore.instance
        .collection("Faculty")
        .doc(uid)
        .collection("Form")
        .get();
  }

  Future<QuerySnapshot> fetchRatingHod() async {
    return await FirebaseFirestore.instance
        .collection("Faculty")
        .doc(uid)
        .collection("Form")
        .doc(selectedYear)
        .collection("Form")
        .get();
  }

  Future<QuerySnapshot> fetchFacultysForPrincipal() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Faculty").get();
    return querySnapshot;
  }
}
