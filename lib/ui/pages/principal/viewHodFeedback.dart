import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hodrating extends StatelessWidget {
  const Hodrating({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Column(children: [Expanded(
      child: FutureBuilder(future: Provider.of<Hodprovider>(context,listen: false).fetchRatingHod(), builder: (context, snapshot) {
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
                          
                        },
                          child: ListTile(subtitle:Text(documentSnapshot["value"].toString()),tileColor: Colors.teal,title: Text(documentSnapshot["qstn"]) )),
                      );
                  },
                  itemCount: snapshot.data!.size,);
                }
                return Center(child: CircularProgressIndicator(),);
              },),
    )],) ,);
  }
}