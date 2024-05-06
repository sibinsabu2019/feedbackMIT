import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMoreFields extends StatefulWidget {
  const AddMoreFields({super.key});

  @override
  State<AddMoreFields> createState() => _AddMoreFieldsState();
}

class _AddMoreFieldsState extends State<AddMoreFields> {
  TextEditingController FieldsControllers = TextEditingController();
  List<TextEditingController> _ParameterControllers = [TextEditingController()];
  int CurrentStep = 0;
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            bottom:
                const TabBar(tabs: [Text("add fields"), Text("View Fields")]),
          ),
          body: TabBarView(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Stepper(
                    currentStep: CurrentStep,
                    onStepContinue: () {
                      if (CurrentStep < 1) {
                         if(FieldsControllers.text.isEmpty)
                        {
                            CustomSnackbar.ErrorSnackbar(context, "Fill the field");
                        }else{
                             setState(() {
                          CurrentStep += 1;
                        });
                        }
                       
                      }
                      else{
                     
                                            
                               Provider.of<AdminProvider>(context,
                                            listen: false)
                                        .AddmoreFields(FieldsControllers.text,_ParameterControllers.map(
                                        (controller) => controller.text)
                                        .toList());
                                        setState(() {
                                      _ParameterControllers.forEach(
                                          (controller) => controller.clear());
                                    });
                                    Navigator.pop(context);
                                           
                                  
                      }
                    },
                    onStepCancel: () {
                      if (CurrentStep > 0) {
                        setState(() {
                          CurrentStep -= 1;
                        });
                      }
                    },
                    steps: [
                      Step(
                        title: Text("Add more Fiels"),
                        content: Column(
                          children: [
                            // Display existing text fields
                           Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: FieldsControllers,
                                      decoration: InputDecoration(
                                        labelText: 'FeedbackField',
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            
                            
                          ],
                        ),
                      ),
                      Step(
                          title: const Text("Add parameters"),
                          content: Column(
                            children: [
                              // Display existing text fields
                              ..._ParameterControllers.asMap()
                                  .entries
                                  .map((entry) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: entry.value,
                                        decoration: InputDecoration(
                                          labelText: 'parameter ${entry.key + 1}',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          List<TextEditingController>
                                              tempControllers =
                                              List.from(_ParameterControllers);
                                          tempControllers.removeAt(entry.key);
                                          _ParameterControllers =
                                              tempControllers;
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
                                    _ParameterControllers.add(
                                        TextEditingController());
                                  });
                                },
                                child: Text('Add more parameters'),
                              ),
                              // ElevatedButton(
                              //     onPressed: () {
                              //       
                              //     },
                              //     child: Text("Add to database"))
                            ],
                          ))
                    ]),
              ),
              Container(
                child: FutureBuilder<QuerySnapshot>(
                  future: Provider.of<AdminProvider>(context, listen: false)
                      .fetchFeedback(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                              Map<String,dynamic>dataa=documentSnapshot.data() as Map<String,dynamic>;
                              dataa.remove("qstn");
                              dataa.remove("total");
                              List<dynamic>fields=dataa.keys.toList();
                            
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                 showDialog(context: context, builder: (context) {
                                   return AlertDialog(content: Container(child: ListView.builder(itemCount: fields.length,
                                    itemBuilder: (context, index) {
                                     return Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: ListTile(title: Text(fields[index],),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),),
                                     );
                                   },),),);
                                 },);
                                },
                                child: ListTile(
                                  title: Text(documentSnapshot["qstn"]),
                                  tileColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                )),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
