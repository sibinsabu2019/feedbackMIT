import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/login.dart';
import 'package:feedback/ui/pages/principal/viewStudentsFeedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrincipalHome extends StatefulWidget {
  const PrincipalHome({super.key});

  @override
  State<PrincipalHome> createState() => _PrincipalHomeState();
}

class _PrincipalHomeState extends State<PrincipalHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Principal page"),leading: Builder(
      builder: (context) {
        return IconButton(onPressed: ()
        {
        Scaffold.of(context).openDrawer();
        }, icon: Icon(Icons.list));
      }
    ),),
      body: Center(child: ElevatedButton(onPressed: ()
      {
        FirebaseAuth.instance.signOut();
      }
      
      , child: Text("log out")),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/college.jpg"),fit: BoxFit.fill)
              ),
              child: Text("")
            ),
            ListTile(
              title: Text('Feedbacks'),
              onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentsFeedback(),));
              },
            ),
            ListTile(
              title: Text('sign out'),
              onTap: ()async {
             await FirebaseAuth.instance.signOut();
             Navigator.popUntil(context, (route) => route.isFirst);
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(),));
             Provider.of<AdminProvider>(context,listen: false).clearData();
             Provider.of<CreateForm>(context,listen: false).clearData();
             Provider.of<facultyProvider>(context,listen: false).clearData();
             Provider.of<Hodprovider>(context,listen: false).clearData();
             Provider.of<StudentProvider>(context,listen: false).clearData(); 
              },
            ),
          ],
        ),
      ),
   
    );
  }
}