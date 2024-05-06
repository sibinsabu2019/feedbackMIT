import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertBuilder extends StatefulWidget {
  String? data;
  Future<QuerySnapshot< Object?>>? future;
   AlertBuilder({
    super.key,required this.data,
    required this.future
  });

  @override
  State<AlertBuilder> createState() => _AlertBuilderState();
}

class _AlertBuilderState extends State<AlertBuilder> {
  List<String>demo=[];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [Container(height: 600,width: 600,
      child: FutureBuilder<QuerySnapshot>(future: widget.future, builder: (context, snapshot) {
      if(snapshot.hasError)
      {
        return Center(child: Text(snapshot.error.toString()),);
        
      }
      if(snapshot.hasData)
      {
        return ListView.builder(itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
            Map<String,dynamic>data2=documentSnapshot.data() as Map<String,dynamic>;
           
            return GestureDetector(
              onTap: ()
              {
                Provider.of<StudentProvider>(context,listen: false).subjectList.clear();
                 for(int i=1;i<data2.length;i++)
                {
                  Provider.of<StudentProvider>(context,listen: false).subjectList.add(documentSnapshot["subject$i"]);
                  log(snapshot.data!.size.toString());
                log(  documentSnapshot["subject$i"].toString());
                }
               setState(() {
                  Provider.of<StudentProvider>(context,listen: false).Selectsem=documentSnapshot[widget.data!];
               });
               
                Navigator.pop(context);
                

              },
              
              child: ListTile(title: Text(documentSnapshot[widget.data!]),));
          
        },);
        }

      return const Center(child: CircularProgressIndicator(),);
    },),)],
    );
  }
}