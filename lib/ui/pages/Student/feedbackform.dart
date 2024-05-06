import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Feedbackform extends StatefulWidget {
  const Feedbackform({Key? key});

  @override
  State<Feedbackform> createState() => _FeedbackformState();
}

class _FeedbackformState extends State<Feedbackform> {
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    log("message");
    Provider.of<StudentProvider>(context,listen: false).feedbackRecode();
    return Scaffold(
      appBar: AppBar(title: FutureBuilder<DocumentSnapshot>(future: Provider.of<StudentProvider>(context,listen: false).fetchCurrentFaculty(), builder: (context, snapshot) {
        if(snapshot.hasData)
        {
          Map<String,dynamic>data=snapshot.data!.data() as Map<String,dynamic> ;
          return Text("Faculty : ${data["name"].toString()}");
        }
        else{
            return CircularProgressIndicator();

        }
      },),),
      body: Column(
        children: [
          
         loading==false? Expanded(
            child:
             FutureBuilder<QuerySnapshot>(
              future: Provider.of<StudentProvider>(context, listen: false).fetchFeedback(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                      
                    
                      // List<String>data2=data.keys.toList();
                      // log(data2.toString());
                      
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: ()
                          { 
                            
                           
                                Map<String,dynamic>data3=documentSnapshot.data() as Map<String,dynamic>;
                              Map<String,dynamic>data=documentSnapshot.data() as Map<String,dynamic>;
                              data.remove("qstn");
                              data.remove("total");
                             List<String>data2=data.keys.toList();
                             log(data2.toString());
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(content: Container(height: 200,width: 200,
                                  
                                  child:
                                   ListView.builder(itemCount: data2.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(onTap: ()async
                                        {
                                          Navigator.of(context).pop();
                                         int? changesMinus;
                                         if (Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]==null) {
                                           changesMinus=0;
                                         }
                                         else
                                         {
                                         changesMinus =data3[ Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]];

                                           Provider.of<StudentProvider>(context,listen: false).qstnList[documentSnapshot["qstn"]]==documentSnapshot["qstn"]?
                                          data3[ Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]]=changesMinus!-1:
                                          log("messsgddgtff");
                                         }
                                         
                                          int changes=data3[data2[index]];
                                          int total=data3["total"];
                                          log(changes.toString());
                                         
                                          data3[data2[index]]=changes+1;
                                            Provider.of<StudentProvider>(context,listen: false).qstnList[documentSnapshot["qstn"]]!=documentSnapshot["qstn"]? data3["total"]=
                                         total+1
                                         :log("alredy total added");
                                          log(data3.toString());
                                         Map<String,dynamic>data4={};
                                          data4["qstn"]=documentSnapshot["qstn"];
                                          data4["value"]=data2[index];
                                        await  Provider.of<StudentProvider>(context,listen: false).updateForm(documentSnapshot["qstn"].toString(), data3,data4);
                                         setState(() {
                                           loading=true;
                                         });
                                         Timer(Duration(seconds: 2), () { 
                                          setState(() {
                                            loading=false;
                                          });
                                         });
                                         
                                        },
                                          child: ListTile(title: Text(data2[index].toString()),
                                          tileColor:Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]==data2[index]?
                                          Colors.blue[200]:Colors.grey[300]
                                          ,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                          )),
                                      );
                                    
                                  },),
                                  ),);
                              },
                              );
                          
                          },
                          child: ListTile(
                            title: Text(documentSnapshot["qstn"],style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700),),
                            tileColor:Provider.of<StudentProvider>(context,listen: false).qstnList[documentSnapshot["qstn"]]==documentSnapshot["qstn"]?
                                           Colors.blue[200]:Colors.grey[300],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),),
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ):CircularProgressIndicator(),
          Container(width: MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height*0.05 ,
          color: Colors.white,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(height: 30,width: 30,decoration: BoxDecoration(color: Colors.grey[300],borderRadius: BorderRadius.circular(10)),),
              Text(" Not submitted     "),
              Container(height: 30,width: 30,decoration: BoxDecoration(color: Colors.blue[200],borderRadius: BorderRadius.circular(10)),),
              Text(" submitted")
            ],)
          ),
        ],
      ),
    );
  }
}
