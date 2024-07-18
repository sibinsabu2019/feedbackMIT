import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/facultyProvider.dart';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

class FacReport extends StatelessWidget {
  const FacReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.grey[300],  title: Text(Provider.of<facultyProvider>(context,listen: false).selectedsubject.toString()),),

      body: Column(
        children: [
          Container(height: MediaQuery.of(context).size.height*0.8,
          width: MediaQuery.of(context).size.width,
            child:
            
            FutureBuilder<QuerySnapshot>(future:
            Provider.of<Hodprovider>(context,listen: false).barchart==true?
            Provider.of<Hodprovider>(context,listen: false).fetchBarchart():
            Provider.of<facultyProvider>(context).fetchBarchart() , builder: (context, snapshot) {
            if(snapshot.hasError)
            {
               return Center(child: Text(snapshot.error.toString()),);
          
            }
            if(snapshot.hasData)
            {
              
              return  ListView.builder(itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
                Map<String,dynamic>database=documentSnapshot.data() as Map<String,dynamic>;
                database.remove("qstn");
                database.remove("total");
                Map<String,double>demo={};
                database.forEach((key, value) { 
                  if(value is num)
                  {
                    demo[key]=value.toDouble();
                  }
                  else{
                    log("not num");
                  }

                });

                
          
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                    color: Colors.grey[100],
                    child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( documentSnapshot["qstn"],style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100),),
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("No of students Responded: ${documentSnapshot["total"]}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.teal),),
                        )
                      ],
                    ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.size,);
            }
            return Center(child: CircularProgressIndicator(),);
          },),)
        ],
      ),
    );
  }
}