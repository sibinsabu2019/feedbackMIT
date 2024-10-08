import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/Faculty/FacReport.dart';
import 'package:feedback/ui/pages/Faculty/barchart.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FacultySub extends StatelessWidget {
  const FacultySub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Your Subjects"),),
      body: Column(children: [Container(
      width: MediaQuery.of(context).size.width,
      height: 500,

      child: FutureBuilder(future:Provider.of<facultyProvider>(context,listen: false).facultySubject() , builder: (context, snapshot) {
        if(snapshot.hasError)
        {
          return Center(child: Text(snapshot.error.toString()),);
        }
        if(snapshot.hasData)
        {
             return  ListView.builder(itemBuilder: (context, index) {
               DocumentSnapshot documentSnapshot= snapshot.data!.docs[index];
          return   Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(onTap: ()
            {
                Provider.of<facultyProvider>(context,listen: false).selectedsubject=documentSnapshot["subject"];
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const  FacReport(),));
            },
              child: ListTile(title: Text(documentSnapshot["subject"]),tileColor: Colors.grey[300],)),
          );

             },itemCount: snapshot.data!.size,);
        }
        return Center(child: CircularProgressIndicator(),);
      },),
    )],),);
  }
}