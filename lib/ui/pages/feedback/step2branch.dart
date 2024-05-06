import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/ui/pages/feedback/step3sem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class selectBranch extends StatefulWidget {

   selectBranch({super.key,});

  @override
  State<selectBranch> createState() => _selectBranchState();
}

class _selectBranchState extends State<selectBranch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("select branch"),),
      body: FutureBuilder<QuerySnapshot>(future: Provider.of<CreateForm>(context).fetchBranch(), builder: (context, snapshot) {
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
              child: GestureDetector(onTap: () {  
               setState(() {
                  Provider.of<CreateForm>(context,listen: false).selectedBranc =documentSnapshot["branch"];
               });
               Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const SlectSem(),));
              },
                child: ListTile(title: Text(documentSnapshot["branch"]),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),),),
            ) ;
          },);
        }
        return const Center(child: CircularProgressIndicator(),);
      },),
    );
  }
}