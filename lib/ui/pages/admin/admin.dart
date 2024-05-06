import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/feedback/AddMoreFields.dart';
import 'package:feedback/ui/pages/feedback/HodForm1.dart';
import 'package:feedback/ui/pages/feedback/adminCreateBranch.dart';
import 'package:feedback/ui/pages/feedback/step1year.dart';
import 'package:feedback/ui/pages/login.dart';
import 'package:feedback/ui/widgets/AddCredentials.dart';
import 'package:feedback/ui/widgets/AdminOptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) => IconButton(onPressed: ()
        {
           Scaffold.of(context).openDrawer();
        }, icon:const Icon(Icons.list)),),
        title: const Text(
          "admin",
        ),
        centerTitle: true,
      ),
      body: SizedBox(height: MediaQuery.of(context).size.height ,
      width:  MediaQuery.of(context).size.width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
              Image.asset("assets/admin.png",
              height: MediaQuery.of(context).size.height*0.3,
              )
          ],
        ),
      ),
      drawer: Drawer( backgroundColor: Colors.grey[400],
        child: SingleChildScrollView(
          child: Column(children: [
          
          DrawerHeader(child: Image.asset("assets/admin.png")),
           Selectoption(onTap: ()
           {
            Navigator.of(context).pop();
              Provider.of<AdminProvider>(context,listen: false).selectedRole="HOD";
              Navigator.of(context).push(MaterialPageRoute(builder:  (context) =>const AddCredentials(),));
           },
           option: "Add Hod",
           icon: Icons.add,
           ),
           Selectoption(onTap: ()
           {
            Navigator.of(context).pop();
            Provider.of<AdminProvider>(context,listen: false).selectedRole="Faculty";
               Navigator.of(context).push(MaterialPageRoute(builder:  (context) =>const AddCredentials(),));
           }, option: "Add Faculty",
           icon: Icons.add,),
          
           Selectoption(onTap: ()
           {
            Navigator.of(context).pop();
              Provider.of<AdminProvider>(context,listen: false).selectedRole="Principal";
               Navigator.of(context).push(MaterialPageRoute(builder:  (context) =>const AddCredentials(),));  
           }, option: "Add Principal",
           icon: Icons.add,),
           Selectoption(onTap: ()
           {
            Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder:  (context) =>const feedbackAmin(),));  
           }, option: "Create Batch & Departments",
            icon: Icons.create),
           Selectoption(onTap: ()
           {
            Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder:  (context) =>const Step1(),));  
           }, option: "Create Subjects & Appoint Fculty ",
           icon: Icons.create),
           Selectoption(onTap: ()
           {
            Navigator.of(context).pop();
               Navigator.of(context).push(MaterialPageRoute(builder:  (context) =>const HodFeedback1(),));  
           }, option: "Feedback Form(HOD)",
           icon: Icons.create),
           Selectoption(onTap: ()
           {
            Navigator.of(context).pop();
               Navigator.of(context).push(MaterialPageRoute(builder:  (context) =>const AddMoreFields(),));  
           }, option: "Feedback(Students)", icon: Icons.create),
           Selectoption(onTap: ()async
           {
            await FirebaseAuth.instance.signOut();
             Navigator.popUntil(context, (route) => route.isFirst);
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(),));
             Provider.of<AdminProvider>(context,listen: false).clearData();
             Provider.of<CreateForm>(context,listen: false).clearData();
             Provider.of<facultyProvider>(context,listen: false).clearData();
             Provider.of<Hodprovider>(context,listen: false).clearData();
             Provider.of<StudentProvider>(context,listen: false).clearData(); 
           }, option: "Log out",icon: Icons.logout,)
                ],),
        ),),
    ); 
  }
}


