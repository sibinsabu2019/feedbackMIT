import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class facultyProvider extends ChangeNotifier
{
   String? selectedYear;
   String? selectedsubject;

   void clearData()
   {
    selectedYear=null;
    selectedsubject=null;
   }

   Future<QuerySnapshot>fetchYear()async
   {
      QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("feedback").get(); 
      return  querySnapshot;  
   }

   Future<QuerySnapshot>facultySubject()async
   {
   
     QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection("Faculty").doc(FirebaseAuth.instance.currentUser!.uid).collection(selectedYear!).get();
    return querySnapshot;
   }

   Future<QuerySnapshot>fetchBarchart()async
   {
       QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection(selectedYear.toString()).doc(selectedsubject.toString()).collection(selectedsubject.toString()).get();
   return querySnapshot;
   }
   Future<DocumentSnapshot>fetchFaculty()async
{
  User? user= FirebaseAuth.instance.currentUser;
  DocumentSnapshot documentSnapshot=await  FirebaseFirestore.instance.collection("Faculty").doc(user!.uid).get();
  return documentSnapshot;
}

}