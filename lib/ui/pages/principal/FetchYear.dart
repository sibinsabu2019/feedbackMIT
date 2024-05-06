import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/ui/pages/principal/viewHodFeedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearHodRate extends StatelessWidget {
  const YearHodRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      Expanded(
        child: FutureBuilder<QuerySnapshot>(future: Provider.of<Hodprovider>(context,listen: false).fetchRatingYear(), builder: (context, snapshot)  {
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
                        Provider.of<Hodprovider>(context,listen: false).selectedYear=documentSnapshot["year"];
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Hodrating(),));
                      },
                        child: ListTile(subtitle: Text(documentSnapshot["year"]),tileColor: Colors.teal,)),
                    );
                },
                itemCount: snapshot.data!.size,);
              }
              return Center(child: CircularProgressIndicator(),);
            },),
      )
    ],),);
  }
}