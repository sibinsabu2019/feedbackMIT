import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/Student/selectSubject.dart';
import 'package:feedback/ui/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Student"),
        leading: IconButton(
          onPressed: () {
           _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.list),
        ),
      ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(tileColor: Colors.grey[300],
                title: Text('feedback'),
                onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => subject() ,));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(tileColor: Colors.grey[300],
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
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 170,),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(margin: EdgeInsets.all(15),
                decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.circular(13) ),
                  child: FutureBuilder(
                    future: Provider.of<StudentProvider>(context,listen: false).fetchStudent(),
                    builder: (context, snapshot) {
                        
                      if(snapshot.hasError) {
                       
                        return Center(child: Text(snapshot.error.toString()),);
                      }
                      if(snapshot.hasData) {
                          Provider.of<StudentProvider>(context,listen: false).Batch=snapshot.data!["batch"];
                        Provider.of<StudentProvider>(context,listen: false).Branch=snapshot.data!["branch"];
                        return Container(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Name  : ${snapshot.data!["name"]}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Email  : ${snapshot.data!["email"]}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Batch  : ${snapshot.data!["batch"]}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Branch  : ${snapshot.data!["branch"]}"),
                              )
                            ],
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator(),);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
