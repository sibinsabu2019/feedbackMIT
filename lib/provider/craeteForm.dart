import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateForm extends ChangeNotifier {
  String? selectedYear;
  String? selectedBranc;
  String? selectedSem;
  String? selectedsubject;
  String? selectedFaculty;
  List<String> feedbackList = [];
  List<String>subjectList=[];
  List<String>yearList=[];
  List<dynamic>olddataList=[];
  

  List<String> qustnList2 = [
    "Approximate % of classes not engaged by teacher",
    "Whether the teacher  dictates notes only without explanation ",
    "Speed of presentation ",
    "Does the teacher encourage questioning",
    "Behavior of  the teacher ",
    "Sincerity of the teacher"
  ];

  void clearData()
  {
     selectedYear=null;
   selectedBranc=null;
   selectedSem=null;
   selectedsubject=null;
   selectedFaculty=null;
   feedbackList.clear();
  subjectList.clear();
  yearList.clear();
  olddataList.clear();
  }
  void addBranchesToFirestore(
       String selected, String selectedto) async {
    log("page of creating branch....");
    
    Map<String, dynamic> data = {};
    Map<String, dynamic> data2 = {};
    try {
      // Initialize Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a reference to the branches collection

      // Add each branch to Firestore
      for (int i = 0; i < subjectList.length; i++) {
        data['branch'] = subjectList[i];
        await firestore
            .collection("feedback")
            .doc('$selected-$selectedto')
            .collection("Branch")
            .doc(subjectList[i])
            .set(data);
        for (int j = 1; j < 9; j++) {
          data2["sem"] = "s$j";
          await firestore
              .collection("feedback")
              .doc('$selected-$selectedto')
              .collection("Branch")
              .doc(subjectList[i])
              .collection("sem")
              .doc("s$j")
              .set(data2);
        }
      }
      Map<String, dynamic> year = {"year": '$selected-$selectedto'};
      firestore.collection('feedback').doc('$selected-$selectedto').set(year);

      // Print success message
      print('Branches added to Firestore');
    } catch (error) {
      // Print error message
      print('Error adding branches to Firestore: $error');
    }
  }

  Future<QuerySnapshot> fetchBranch() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("feedback")
        .doc(selectedYear)
        .collection("Branch")
        .get();
    notifyListeners();

    return querySnapshot;
  }

  Future<QuerySnapshot> fetchyear() async {
    yearList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("feedback").get();
        for(int i=0;i<querySnapshot.size;i++)
       {
         DocumentSnapshot documentSnapshot=querySnapshot.docs[i];
          log(documentSnapshot["year"]);
          yearList.add(documentSnapshot["year"]);
  }
  log(yearList.toString());
    return querySnapshot;
  }

  Future<QuerySnapshot> fetchsem() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("feedback")
        .doc(selectedYear)
        .collection("Branch")
        .doc(selectedBranc)
        .collection("sem")
        .get();

    return querySnapshot;
  }

  Future<void> addsubjects(List<String> subjects) async {
    olddataList.clear();
    subjects.removeWhere((element) => element.isEmpty);
   
   
    
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("feedback")
        .doc(selectedYear)
        .collection("Branch")
        .doc(selectedBranc)
        .collection("sem")
        .doc(selectedSem)
        .get();
      
    Map<String, dynamic> oldata =
        documentSnapshot.data() as Map<String, dynamic>;

        
        olddataList=oldata.values.toList();
        
    log("length of old data ${oldata.length.toString()}");
    int oldlength = oldata.length;
    if (oldata.length == 1) {
      Map<String, dynamic> data = {};
      for (int i = 0; i < subjects.length; i++) {
         print(i.toString());
        //  if(subjects[i]=="")
        //  {
        //  await  subjects.remove("");
        //  }
        data["subject${i + 1}"] = subjects[i];
      }
      FirebaseFirestore.instance
          .collection("feedback")
          .doc(selectedYear)
          .collection("Branch")
          .doc(selectedBranc)
          .collection("sem")
          .doc(selectedSem)
          .update(data);
    } else {
      subjects.removeWhere((element) => olddataList.contains(element));
      Map<String, dynamic> data = {};
      int j = 0;
      for (int i = oldlength; i < subjects.length + oldlength; i++) {
        data["subject$i"] = subjects[j];
        j = j + 1;
        notifyListeners();
      }

      FirebaseFirestore.instance
          .collection("feedback")
          .doc(selectedYear)
          .collection("Branch")
          .doc(selectedBranc)
          .collection("sem")
          .doc(selectedSem)
          .update(data);
    }
  }

  Future<DocumentSnapshot> fetchsubjcts() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("feedback")
        .doc(selectedYear)
        .collection("Branch")
        .doc(selectedBranc)
        .collection("sem")
        .doc(selectedSem)
        .get();
    return documentSnapshot;
  }

  Future<QuerySnapshot> fetchFaculty() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Faculty").get();
    return querySnapshot;
  }

  Future<void> addSubandfaculty() async {
    try {
      Map<String, dynamic> data = {
        "name": selectedFaculty.toString(),
        "subject": selectedsubject.toString()
      };
      await FirebaseFirestore.instance
          .collection(selectedYear.toString())
          .doc(selectedsubject.toString())
          .set(data);
          

       QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection("fields").get();
       for(int i =0;i<querySnapshot.size;i++)
       {
        Map<String,dynamic>questinList = {};
         DocumentSnapshot documentSnapshot=querySnapshot.docs[i];
         questinList=documentSnapshot.data() as Map<String,dynamic>;
         await FirebaseFirestore.instance
            .collection(selectedYear.toString())
            .doc(selectedsubject.toString())
            .collection(selectedsubject.toString())
            .doc(questinList["qstn"].toString())
            .set(questinList);


       }

      // for (int i = 0; i < qstnList.length; i++) {
      //   data2["qstn"] = qstnList[i];
      //   await FirebaseFirestore.instance
      //       .collection(selectedYear.toString())
      //       .doc(selectedsubject.toString())
      //       .collection(selectedsubject.toString())
      //       .doc(qstnList[i].toString())
      //       .set(data2);
        
      // }
      // Map<String, dynamic> data3 = {};

      // for (int i = 0; i < qustnList2.length; i++) {
        
      //   if (i == 0) {
      //     data3 = {
      //       "Unable to judge": 0,
      //       "More than 25%": 0,
      //       "10-25%": 0,
      //       "less than 10%": 0,
      //       "total": 0
      //     };
      //   }
      //   if (i == 1) {
      //     data3 = {"Unable to judge": 0, "Yes": 0, "No": 0, "total": 0};
      //   }

      //   if (i == 2) {
      //     data3 = {
      //       "Unable to judge": 0,
      //       "Too fast": 0,
      //       "Too slow": 0,
      //       "Just right": 0,
      //       "total": 0
      //     };
      //   }
      //   if (i == 3) {
      //     data3 = {
      //       "Unable to judge": 0,
      //       "No": 0,
      //       "Sometimes": 0,
      //       "Yes": 0,
      //       "total": 0
      //     };
      //   }

      //   if (i == 4) {
      //     data3 = {
      //       "Unable to judge": 0,
      //       "unpleasant": 0,
      //       "indiffrent": 0,
      //       "pleasant": 0,
      //       "total": 0
      //     };
      //   }
      //   if (i == 5) {
      //     data3 = {
      //       "Unable to judge": 0,
      //       "Not sincere": 0,
      //       "Sincere": 0,
      //       "total": 0
      //     };
      //   }
      //   data3["qstn"] = qustnList2[i];
      //    log(data3.toString());

        // await FirebaseFirestore.instance
        //     .collection(selectedYear.toString())
        //     .doc(selectedsubject.toString())
        //     .collection(selectedsubject.toString())
        //     .doc(qustnList2[i].toString())
        //     .set(data3);
        
      // }

     QuerySnapshot Snapshot=await FirebaseFirestore.instance.collection("Faculty").where("name",isEqualTo: selectedFaculty).get();

     if(Snapshot.docs.isNotEmpty)
     {
      DocumentSnapshot documentSnapshot=Snapshot.docs[0];
      log(documentSnapshot["email"]);
      await FirebaseFirestore.instance.collection("Faculty").doc(documentSnapshot["id"]).collection(selectedYear.toString()).doc(selectedsubject).set({"subject":selectedsubject});
     }

    } on FirebaseException catch (ex) {
      log(ex.code);
    }
  }
  Future<void>FetchDep()async
{
  subjectList.clear();
  QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("Department").get();
  for(int i=0;i<querySnapshot.size;i++)
  {
    DocumentSnapshot documentSnapshot=querySnapshot.docs[i];
    log(documentSnapshot["branch"]);
    subjectList.add(documentSnapshot["branch"]);
  }
}


}
