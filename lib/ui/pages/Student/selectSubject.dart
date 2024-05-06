import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/ui/pages/Student/feedbackform.dart';
import 'package:feedback/ui/widgets/AlretboxBuilder.dart';
import 'package:feedback/ui/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class subject extends StatefulWidget {
   subject({super.key});

  @override
  State<subject> createState() => _subjectState();
}

class _subjectState extends State<subject> {
  int currentStep=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: Stepper(currentStep: currentStep,
      onStepContinue: () {
      if(currentStep<1)
      {
        if(currentStep==0)
        {
          if(Provider.of<StudentProvider>(context,listen: false).Selectsem=="Select Sem")
          {
            CustomSnackbar.ErrorSnackbar(context, "Sem is not Selected");
          }
          else{
              setState(() {
           currentStep+=1;
         });
          }
        }
         
        
      }
      else{
       Navigator.of(context).push(MaterialPageRoute(builder: (context,) =>const Feedbackform(),));
      }
    },
    onStepCancel: ()
    {
      if(currentStep>0)
      {
        setState(() {
          currentStep-=1;
        });
      }
    },
      steps: [
      Step(title: const Text("Select your sem"), content: ElevatedButton(onPressed: ()
      {

      showDialog(context: context, builder: (context) {
        return  AlertBuilder(future:Provider.of<StudentProvider>(context,listen: false).fetchSem() ,data: "sem",);
      },);

  setState(() {
  Provider.of<StudentProvider>(context,listen: false).Selectsem;
  });
      },style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      
       child: Text(Provider.of<StudentProvider>(context).Selectsem),)),
       Step(title: const Text("Select your Subjects"), content: ElevatedButton(onPressed: ()
       {
           showDialog(context: context, builder: (context) {
             return AlertDialog(actions: [
              Container(height: 500,width: 500,
              child: ListView.builder(itemCount:Provider.of<StudentProvider>(context,listen: false).subjectList.length ,
                itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: ()
                  {
                        Provider.of<StudentProvider>(context,listen: false).FormSubject= Provider.of<StudentProvider>(context,listen: false).subjectList[index];
                            log(Provider.of<StudentProvider>(context,listen: false).subjectList[index]);
                            Navigator.pop(context);
                  },
                child: ListTile(title: Text(Provider.of<StudentProvider>(context,listen: false).subjectList[index]),));
              },),)
             ],); 
           },);
          //  Provider.of<StudentProvider>(context,listen: false).currentFaculty=null;
       },
       style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Text("Select subject")))
    ]),
    
    
    );
  }
}

