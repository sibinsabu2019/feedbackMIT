import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/ui/pages/hod/SelectYear.dart';
import 'package:feedback/ui/pages/principal/FetchYear.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StudentsFeedback extends StatelessWidget {
  const StudentsFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("View Feedbacks"),),
      body: Column(
        children: [
           
          Container(height: MediaQuery.of(context).size.height*0.7,width: MediaQuery.of(context).size.width,
          child: FutureBuilder(future:  Provider.of<Hodprovider>(context).fetchFacultysForPrincipal(), builder: (context, snapshot) {
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
                      Provider.of<Hodprovider>(context,listen: false).uid=documentSnapshot["id"];
                      Provider.of<Hodprovider>(context,listen: false).Department =documentSnapshot["branch"];
                      showDialog(context: context, builder: 
                      (context) => AlertDialog(content: Column(mainAxisSize: MainAxisSize.min, children: [Row(children: [
                        Flexible(flex: 1,
                          child: ElevatedButton(onPressed: ()
                          {
                            Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const SelectYear(),));
                          },
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))) 
                          
                          ,child: Text("Students Feedback")),
                        ),
                         SizedBox(width: 8,),
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(onPressed: ()
                          {
                           Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const YearHodRate (),));
                          },
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))) 
                          
                          ,child: Text(" Hod's Rating")),
                        )
                      ],)],),),
                      );
                        
                    },
                      child: ListTile(title: Text(documentSnapshot["name"]),tileColor: Colors.grey[300],
                      subtitle:Text(documentSnapshot["branch"])   ,
                      
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      )),
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