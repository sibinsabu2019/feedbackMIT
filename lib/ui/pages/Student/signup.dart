import 'dart:developer';


import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/ui/widgets/AddCredentials.dart';
import 'package:feedback/ui/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
 const
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String selectedBatch="Select batch";

  String selectedBranch="Select branch";
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  int currentStep = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StudentProvider>(context, listen: false).fetchyear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Stepper(
          currentStep: currentStep,
          onStepContinue: () async {
            if (currentStep < 1) {
              if(currentStep==0)
              {
                if(selectedBatch!="Select batch")
                {
                  setState(() {
                currentStep += 1;
                log("goto 1st");

                log(Provider.of<StudentProvider>(context, listen: false)
                    .SELECTBATCH
                    .toString());
              });
                }
                else{
                  CustomSnackbar.ErrorSnackbar(context, "Batch is not Selected");
                }
              }
            }
             else {
              Provider.of<StudentProvider>(context,listen: false).SelectedRole="student";

             if(selectedBranch!="Select branch")
             {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const AddCredentials(),));
             }
             else{
              CustomSnackbar.ErrorSnackbar(context, "Branch is not selected");
             }
             
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() {
                currentStep -= 1;
              });
            }
          },
          steps: [
           
            Step(
                title: const Text("Select your Batch "),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                Container(
                                  height: 400,
                                  width: 400,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              selectedBatch =
                                                  Provider.of<StudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .SELECTBATCH[index];
                                                      
                                                     
                                                      Provider.of<StudentProvider>(context,listen: false).Batch=selectedBatch;
                                            });
                                            await Provider.of<StudentProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchBranch(selectedBatch!);
                                                Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            tileColor: Colors.teal,
                                            title: Text(
                                                Provider.of<StudentProvider>(
                                                        context,
                                                        listen: false)
                                                    .SELECTBATCH[index]),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: Provider.of<StudentProvider>(
                                            context,
                                            listen: false)
                                        .SELECTBATCH
                                        .length,
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9))),
                      child:  Text(selectedBatch),
                    ),
                    
                        
                  ],
                )),
            Step(
                title: const Text("Select your Branch"),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {

                       showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                Container(
                                  height: 400,
                                  width: 400,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              selectedBranch =
                                                  Provider.of<StudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .SELECTBRANCH[index];
                                                      Provider.of<StudentProvider>(context,listen: false).Branch=selectedBranch;
                                            });
                                           
                                                Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            tileColor: Colors.teal,
                                            title: Text(
                                                Provider.of<StudentProvider>(
                                                        context,
                                                        listen: false)
                                                    .SELECTBRANCH[index]),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: Provider.of<StudentProvider>(
                                            context,
                                            listen: false)
                                        .SELECTBRANCH
                                        .length,
                                  ),
                                )
                              ],
                            );
                          },
                        );


                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9))),
                      child:  Text(selectedBranch),
                    ),
                       
                  ],
                ))
          ]),
    );
  }
}
