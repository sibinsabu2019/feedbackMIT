import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/Faculty/barchart.dart';
import 'package:feedback/ui/pages/hod/Report.dart';
import 'package:flutter/cupertino.dart';





import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SelectSubject extends StatelessWidget {
  const SelectSubject({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.grey[400]
        
        ),
        child: Center(child:  GestureDetector(
          onTap: ()
          {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Report(),));
          },
          child: Text("view report",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),))),
      ),appBar: AppBar(title: const  Text("subjects"),),
      body: Column(children: [
        
       Expanded(
         child: FutureBuilder<DocumentSnapshot>(future:Provider.of<Hodprovider>(context,listen: false).FetchSubjects() , builder: (context, snapshot) {
          if(snapshot.hasError)
          {
            return Center(child: Text(snapshot.error.toString()),);
          }
          if(snapshot.hasData)
          {
            Map<String,dynamic>data=snapshot.data!.data() as Map<String,dynamic>;
            log(data.toString());
               return  ListView.builder(itemCount: data.length-1,
                itemBuilder: (context, index) {
                 
                //  print(data["subject${[index+1]}"]);
               return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(onTap: ()
              {
                log(
                  data["subject${index+1}"].toString()
                );
                
                Provider.of<Hodprovider>(context,listen: false).barchart=true;
                  Provider.of<Hodprovider>(context,listen: false).selectSubject=data["subject${index+1}"];
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const  Barchart(),));
                  Provider.of<facultyProvider>(context,listen: false).selectedsubject=data["subject${index+1}"];
                 
              },
                child:
              
                 ListTile(title: Text(data["subject${index+1}"].toString()),tileColor: Colors.grey[200],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)),
            );
         
               },);
          }
          return const Center(child: CircularProgressIndicator(),);
               },),
       ),
   ] ),);
  }
}