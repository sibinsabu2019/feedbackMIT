import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/ui/pages/feedback/addsubject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SlectSem extends StatefulWidget {
  const SlectSem({super.key});

  @override
  State<SlectSem> createState() => _SlectSemState();
}

class _SlectSemState extends State<SlectSem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Select Sem"),),
    body: FutureBuilder<QuerySnapshot>(future: Provider.of<CreateForm>(context,listen: false).fetchsem(), builder: (context, snapshot) {
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
             child: GestureDetector(onTap: ()
             {
              setState(() {
                Provider.of<CreateForm>(context,listen: false).selectedSem=documentSnapshot["sem"];
              });
              
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSub(),));
             },
              child: ListTile(title: Text(documentSnapshot["sem"]),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),)),
           );
           


         },);
    }
    return const Center(child: CircularProgressIndicator(),);

    },),
    
    );
  }
}