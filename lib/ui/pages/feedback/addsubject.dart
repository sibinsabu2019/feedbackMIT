import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/ui/widgets/CreateSubjects.dart';
import 'package:feedback/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSub extends StatefulWidget {
  const AddSub({super.key});

  @override
  State<AddSub> createState() => _AddSubState();
}

class _AddSubState extends State<AddSub> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child:Scaffold(
      appBar: AppBar(bottom:const TabBar(tabs: [Text("Create subject"),Text("View subject")]),),
     body: TabBarView(children: [
createsubject(),
Column(
  children: [

    Expanded(
      child: FutureBuilder<DocumentSnapshot>(future: Provider.of<CreateForm>(context,listen: false).fetchsubjcts(), builder: (context, snapshot) {
        if(snapshot.hasError)
        {
          return Center(child: Text(snapshot.error.toString()),);
      
        }
        if(snapshot.hasData)
        {
         
         log(snapshot.data!["sem"]);
           Map<String,dynamic>data= snapshot.data!.data() as Map<String,dynamic>;
           log(data.length.toString());
           return ListView.builder(itemCount: data.length-1,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(trailing: GestureDetector(onTap: ()
                {
                  showDialog(context: context, builder: (BuildContext context)
                  {
                      return AlertDialog(
                        actions: [const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child:  Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Select Faculty",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)],),
                        ),
                          Container(height:MediaQuery.of(context).size.height*0.7,width: MediaQuery.of(context).size.width*0.9,
                        child: FutureBuilder<QuerySnapshot>(future:Provider.of<CreateForm>(context,listen: false).fetchFaculty() , builder: (context, snapshot) {

                          if(snapshot.hasError)
                          {
                            return Center(child: Text(snapshot.error.toString()),);
                          }
                          if(snapshot.hasData)
                          {
                            
                            return ListView.builder(itemCount: snapshot.data!.size,
                              itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(onTap: ()async
                                {
                                  
                                   Provider.of<CreateForm>(context,listen: false).selectedFaculty=documentSnapshot["name"].toString();

                                await  Provider.of<CreateForm>(context,listen: false).addSubandfaculty();
                                  
                                  CustomSnackbar.success(context, "selected faculty is ${documentSnapshot["name"]}");
                                  Navigator.pop(context);
                                },
                                  child: ListTile(title: Text(documentSnapshot["name"].toString()),subtitle: Text(documentSnapshot["branch"].toString()),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)),
                              );
                              
                            },);
                          }
                          return const Center(child: CircularProgressIndicator(),);

                          
                        },),)],
                      );
                  });
                  log(snapshot.data!["subject${index+1}"]);
                  Provider.of<CreateForm>(context,listen: false).selectedsubject=snapshot.data!["subject${index+1}"];
                },
                  child: const Text("add faculty",style: TextStyle(fontSize: 13),)),
                  tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  title: Text(snapshot.data!["subject${index+1}"])),
              );
             
           },);
        }
        return const CircularProgressIndicator();
      },),
    )
  ],
)

     ]),
   
    )
    
    );
  }
}

