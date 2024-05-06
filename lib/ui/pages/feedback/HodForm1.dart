


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HodFeedback1 extends StatefulWidget {
  const HodFeedback1({super.key});

  @override
  State<HodFeedback1> createState() => _HodFeedback1State();
}

class _HodFeedback1State extends State<HodFeedback1> {
    List<TextEditingController> _FieldsControllers = [TextEditingController()];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.teal,
        bottom: const  TabBar(tabs:[Text("add fields"),Text("View Fields")] ),
        ),
         
         body: TabBarView(children: [Container(margin: EdgeInsets.all(10),
      
        child: SingleChildScrollView(
          child: Column(
                children: [
                  // Display existing text fields
                  ..._FieldsControllers.asMap().entries.map((entry) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: entry.value,
                            decoration: InputDecoration(
                              labelText: 'Field ${entry.key + 1}',
                            ),
                          ),
                        ),
                        IconButton(
  icon: Icon(Icons.delete),
  onPressed: () {
    setState(() {
      List<TextEditingController> tempControllers = List.from(_FieldsControllers);
      tempControllers.removeAt(entry.key);
      _FieldsControllers = tempControllers;
    });
  },
),

                      ],
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  // Button to add more text fields
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _FieldsControllers .add(TextEditingController());
                      });
                    },
                    child: Text('Add more Fields'),
                  ),
                  ElevatedButton(onPressed: ()
                  {
                      
                      Provider.of<AdminProvider>(context,listen: false).AddForm(_FieldsControllers
                            .map((controller) => controller.text)
                            .toList());
                             setState(() {
                    _FieldsControllers.forEach((controller) => controller.clear());
                   });
      
                  }, child: Text("Add to database"))
                ],
              ),
        ),
      ),
      Container(child:  FutureBuilder<QuerySnapshot>(future: Provider.of<AdminProvider>(context,listen: false).fetchHodFeedback(), builder: (context, snapshot) {
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
                // Provider.of<CreateForm>(context,listen: false).selectedSem=documentSnapshot["sem"];
              });
              
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSub(),));
             },
              child: ListTile(title: Text(documentSnapshot["qstn"]),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)),
           );
           


         },);
    }
    return const Center(child: CircularProgressIndicator(),);

    },),)
      ],) ),
      
    );
  }
}