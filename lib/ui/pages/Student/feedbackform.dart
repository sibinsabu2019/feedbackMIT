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
                      
                  // DocumentSnapshot dta=Provider.of<StudentProvider>(context,listen: false).dta!.docs[index];

                
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: ()
                          { 
                            
                                                
                                                
                                             
                           
                                Map<String,dynamic>data3=documentSnapshot.data() as Map<String,dynamic>;
                              Map<String,dynamic>data=documentSnapshot.data() as Map<String,dynamic>;
                              log(".............");
                               log(".............");
                               print(data);
                                log(".............");
                                 log(".............");
                              data.remove("qstn");
                              data.remove("total");
                            //  List<String>data2=data.keys.toList();
                            //  log(data2.toString());
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(content: Container(height: 200,width: 200,
                                  
                                  child:
                                   ListView.builder(itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final key=data.keys.elementAt(index);
                                          final value=data[key];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(onTap: ()async
                                        {
                                          
                                           Map<String,dynamic>demo={};
                                         demo[key]=data[key];
                                         Map<String,dynamic>demo2={};
                                         demo2["qstn"]=documentSnapshot["qstn"];
                                         demo2["value"]=key;
                                           Map<String,dynamic>olddata= await Provider.of<StudentProvider>(context,listen: false).fetchOldFeedback(demo2["qstn"])as Map<String,dynamic>;
                                           print("....${olddata.toString()}");
                                          // Navigator.of(context).pop();
                                        //  int? changesMinus;
                                         if (Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]==null) {
                                          //  changesMinus=0;
                                          olddata["total"]=olddata["total"]+1;
                                          olddata[key]=olddata[key]+value;
                                        log("not rated");
                                              
                                             await  Provider.of<StudentProvider>(context,listen: false).updateForm(documentSnapshot["qstn"].toString(), olddata,demo2);
                                         }
                                         else{
                                          if(key==Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"])
                                          {

                                          }
                                          else{
                                               olddata[Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]]=olddata[Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]]-data3[Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]];
                                           log("alredy rated${Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]}");

                                          olddata[key]=value;
                                          await  Provider.of<StudentProvider>(context,listen: false).updateForm(documentSnapshot["qstn"].toString(), olddata,demo2);
                                           

                                          }
                                        
                                            
                                         }
                                       
                                        //  else{
                                             
                                        //  }
                                        //  else
                                        //  {
                                        //  changesMinus =data3[ Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]];

                                        //    Provider.of<StudentProvider>(context,listen: false).qstnList[documentSnapshot["qstn"]]==documentSnapshot["qstn"]?
                                        //   data3[ Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]]=changesMinus!-1:
                                        //   log("messsgddgtff");
                                        //  }

                                        
                                        //  print("...${demo.toString()}....");
                                       
                                        Navigator.of(context).pop();
                                         
                                        
                                         setState(() {
                                           loading=true;
                                         });
                                         Timer(Duration(seconds: 2), () { 
                                          setState(() {
                                            loading=false;
                                          });
                                         });
                                         
                                        },
                                          child: ListTile(
                                            title: Text(key.toString()),
                                          tileColor:Provider.of<StudentProvider>(context,listen: false).qstnList["${documentSnapshot["qstn"]}value"]==key?
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
