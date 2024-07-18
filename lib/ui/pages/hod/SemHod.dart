import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/ui/pages/hod/SelectSubject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HodSem extends StatelessWidget {
  const HodSem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const  Text("Select Your Sem!"),),
      body: Column(children: [
        
       Expanded(
         child: FutureBuilder(future:Provider.of<Hodprovider>(context,listen: false).FetchSem() , builder: (context, snapshot) {
          if(snapshot.hasError)
          {
            return Center(child: Text(snapshot.error.toString()),);
          }
          if(snapshot.hasData)
          {
            
               return  ListView.builder(itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                 DocumentSnapshot documentSnapshot= snapshot.data!.docs[index];
                 print(documentSnapshot["sem"]);
               return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(onTap: ()async
              {
                 Provider.of<Hodprovider>(context,listen: false).documentSnapshot=documentSnapshot;
                // compiler design "
                // subject2"data communication "
                Provider.of<Hodprovider>(context,listen: false).barchart=true;
                //   Provider.of<Hodprovider>(context,listen: false).selectSubject=documentSnapshot["subject"];
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>SelectSubject(),));
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const  Barchart(),));

                  // Provider.of<facultyProvider>(context,listen: false).selectedsubject=documentSnapshot["subject"];
                  
                  log(documentSnapshot["sem"]);
              },
                child: ListTile(title: Text(documentSnapshot["sem"]),tileColor: Colors.grey[200],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)),
            );
         
               },);
          }
          return const Center(child: CircularProgressIndicator(),);
               },),
       ),
   ] ),);
  }
}