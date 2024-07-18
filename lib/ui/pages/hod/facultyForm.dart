import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/ui/pages/hod/FacultyForm2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FacultyForm extends StatefulWidget {
  FacultyForm({super.key});

  @override
  State<FacultyForm> createState() => _FacultyFormState();
}

class _FacultyFormState extends State<FacultyForm> {
  TextEditingController year = TextEditingController();

  int currentStep=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stepper(currentStep: currentStep,
        onStepContinue: () {
         if(currentStep<1)
         {
          setState(() {
            currentStep+=1;
          });
         }
         else{
          log("message");
          Provider.of<Hodprovider>(context,listen: false).selectedYear=year.text.trim();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   FacultyForm2(),));
         }
      },
      onStepCancel: ()
      {
        if(currentStep>0)
        {
          setState(() {
              currentStep-=1;
          });
        
        }
      },
        steps: [
        Step(
            title:const Text("Enter Academic year"),
            content: TextField(
              controller: year,
            )),
            Step(title: Text("select faculty"), content: ElevatedButton(onPressed: ()
            {
                showDialog(context: context, builder:(context) {
                  return AlertDialog(content: Container(height: MediaQuery.of(context).size.height*0.6,
                  width: MediaQuery.of(context).size.height*0.6,
                    child:FutureBuilder<QuerySnapshot>(future:  Provider.of<Hodprovider>(context).fetchFacultys(), builder: (context, snapshot) {
            if(snapshot.hasError)
            {
              return Center(child: Text(snapshot.error.toString()),);
            }
            if(snapshot.hasData)
            {
              return ListView.builder(itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
                 
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(onTap: ()
                    {
                      Provider.of<Hodprovider>(context,listen: false).uid=documentSnapshot["id"];
                      Navigator.of(context).pop();
                    },
                      child: ListTile(subtitle: Text(documentSnapshot["name"]),tileColor: Colors.teal,)),
                  );
              },
              itemCount: snapshot.data!.size,);
            }
            return Center(child: CircularProgressIndicator(),);
          },),),);
                },);
            },style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
             child:const  Text("select Faculty")))
      ]),
    );
  }
}
