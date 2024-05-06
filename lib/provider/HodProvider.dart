import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Hodprovider extends ChangeNotifier
{
String? selectedYear;
String? uid;
String? selectSubject;
bool? barchart;
 DocumentSnapshot? documentSnapshot;
 List<String>feedbackList=[];
 String? Department;
void clearData()
{
  Department=null;
  selectedYear=null;
  uid=null;
  selectSubject=null;
  barchart=null;
  documentSnapshot=null;
  feedbackList.clear();

}
Future<DocumentSnapshot>fetchCurrentHod()async
{
  User? user= FirebaseAuth.instance.currentUser;
  DocumentSnapshot documentSnapshot=await  FirebaseFirestore.instance.collection("HOD").doc(user!.uid).get();
  Department= documentSnapshot["branch"];
  notifyListeners();
  return documentSnapshot;
}

Future<QuerySnapshot>fetchFacultys()async
{
  
  QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection("Faculty").where("branch",isEqualTo:Department). get();
 return querySnapshot;
}
Future<QuerySnapshot>fetchYear()async
   {
      QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("feedback").get(); 
      return  querySnapshot;  
   }

   Future<QuerySnapshot>fetchSubject()async
   {
          QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("Faculty").doc(uid.toString()).collection(selectedYear.toString()). get(); 

return querySnapshot;
   }
   Future<QuerySnapshot>fetchBarchart()async
   {
       QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection(selectedYear.toString()).doc(selectSubject.toString()).collection(selectSubject.toString()).get();
   return querySnapshot;
   }
   
     Future<QuerySnapshot>fetchFacultyform()async
   {
       QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("HodForm").get();
   return querySnapshot;
   }
   Future<void>SubmitForm(String qstn,int value )async
   {
    log("working");
    log(uid.toString());
    Map<String,dynamic>data={"year":selectedYear};
    Map<String,dynamic>data2={"qstn":qstn,"value":value};
try{
         await FirebaseFirestore.instance.collection("Faculty").doc(uid).collection("Form").doc(selectedYear).set(data);
        await FirebaseFirestore.instance.collection("Faculty").doc(uid).collection("Form").doc(selectedYear).collection("Form").doc(qstn).set(data2);

}on FirebaseException catch(ex)
{
  log(ex.message.toString());
}  
   }

Future<void>selected()async
{
  feedbackList.clear();
  QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("Faculty").doc(uid).collection("Form").doc(selectedYear).collection("Form").get();

 for(int i=0;i<querySnapshot.size;i++)
{
 DocumentSnapshot  documentSnapshot=querySnapshot.docs[i];
 feedbackList.add(documentSnapshot["qstn"]);
}
}
// principal provider ********   ////////////

Future<QuerySnapshot>fetchRatingYear()async
{
return await FirebaseFirestore.instance.collection("Faculty").doc(uid).collection("Form").get(); 
}

Future<QuerySnapshot>fetchRatingHod()async
{
return await FirebaseFirestore.instance.collection("Faculty").doc(uid).collection("Form").doc(selectedYear).collection("Form").get();
}
Future<QuerySnapshot>fetchFacultysForPrincipal()async
{
  
  QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection("Faculty").get();
 return querySnapshot;
}

}