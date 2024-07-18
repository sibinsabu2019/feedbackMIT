import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/ui/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:provider/provider.dart';

class feedbackAmin extends StatefulWidget {
  const feedbackAmin({Key? key});

  @override
  State<feedbackAmin> createState() => _feedbackAminState();
}

class _feedbackAminState extends State<feedbackAmin> {
  int? selectedYear;
  int? selectToyear;
  int currentStep = 0;
  bool match=false;

  List<int> years =
      List.generate(50, (index) => (DateTime.now().year - 4) + index);
  List<TextEditingController> _branchControllers = [TextEditingController()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      Provider.of<CreateForm>(context,listen: false).fetchyear();
    Provider.of<CreateForm>(context,listen: false).FetchDep();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Year'),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 1) {
            setState(() {
              currentStep += 1;
              
            });
           
           
          
              
            
          } else {
            String? year;
            setState(() {
              year="${selectedYear.toString()}-${selectToyear}";
            });
           if(selectToyear!=null && selectedYear!=null)
           
              {
                log(" year is not  null ");
                for(int i=0;i<Provider.of<CreateForm>(context,listen: false).yearList.length;i++)
                {
                  if(Provider.of<CreateForm>(context,listen: false).yearList[i]==year)
                  {
                    setState(() {
                      match=true;
                    });
                    log("Year matched");
                  }
                  
                }
                if(match==true)
                {
                   CustomSnackbar.ErrorSnackbar(context, "This Batch is alredy found in Database ");
                }
                else{
                     Provider.of<CreateForm>(context, listen: false)
                  .addBranchesToFirestore(
                    
                      selectedYear.toString(),
                      selectToyear.toString());
                      CustomSnackbar.success(context, "Batch & Department Created");
                      Navigator.of(context).pop();
                }
               
              }
              else{
                CustomSnackbar.ErrorSnackbar(context, "Year is not selected");
              }
            
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              match=false;
              currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: const Text("Select batch"),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<int>(
                      hint: const Text('Select Year'),
                      value: selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue;
                          log(selectedYear.toString());
                        });
                      },
                      items: years.map((int year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text('$year'),
                        );
                      }).toList(),
                    ),
                    const Text("  to   "),
                    DropdownButton<int>(
                      hint: const Text('Select Year'),
                      value: selectToyear,
                      onChanged: (newValue) {
                        setState(() {
                          selectToyear = newValue;
                          log(selectToyear.toString());
                        });
                      },
                      items: years.map((int year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text('$year'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text("Branches"),
            content: Column(
              children: [
                // Display existing text fields
                // ..._branchControllers.asMap().entries.map((entry) {
                //   return Row(
                //     children: [
                //       Expanded(
                //         child: TextFormField(
                //           controller: entry.value,
                //           decoration: InputDecoration(
                //             labelText: 'Branch ${entry.key + 1}',
                //           ),
                //         ),
                //       ),
                //       IconButton(
                //         icon: Icon(Icons.delete),
                //         onPressed: () {
                //           setState(() {
                //             _branchControllers.removeAt(entry.key);
                //           });
                //         },
                //       ),
                //     ],
                //   );
                // }).toList(),
                // SizedBox(height: 20),
                // // Button to add more text fields
                ElevatedButton(
                  onPressed: () {
                    // setState(() {
                    //   _branchControllers.add(TextEditingController());
                    // });

                    showDialog(context: context, builder: (context) => AlertDialog(content: SizedBox(
                      height: MediaQuery.of(context).size.height*0.6,
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child:ListView.builder(itemCount:Provider.of<CreateForm>(context,listen: false).subjectList.length ,
                            itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(title: Text(Provider.of<CreateForm>(context,listen: false).subjectList[index].toString()),tileColor: Colors.grey[200],),
                            );
                          },)
                        )
                      ],),
                    ),
                    ),
                    );
                  
                  },
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  child: Text('Show Departments'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
