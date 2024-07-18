import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/hod/SemHod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectYear extends StatelessWidget {
  const SelectYear({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    Column(children: [
      Container(height: MediaQuery.of(context).size.height*0.7,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(future: Provider.of<Hodprovider>(context,listen: false).fetchYear(), builder: (context, snapshot) {
        if(snapshot.hasError)
        {
          return Center(child: Text(snapshot.error.toString()),);
        }
        if(snapshot.hasData)
        {
           return ListView.builder(itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
              return Padding(padding: EdgeInsets.all(8),
              child: GestureDetector(onTap: ()
              {
                 Provider.of<Hodprovider>(context,listen: false).selectedYear=documentSnapshot["year"];
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const HodSem(),));
              },
              child: ListTile(title: Text(documentSnapshot["year"]),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
              ),);
           },
           itemCount: snapshot.data!.size,);
        }
        return Center(child: CircularProgressIndicator(),);
      },
      )
      ,)
    ],));
  }
}