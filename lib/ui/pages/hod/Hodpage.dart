import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/hod/SelectYear.dart';
import 'package:feedback/ui/pages/hod/facultyForm.dart';
import 'package:feedback/ui/pages/hod/SemHod.dart';
import 'package:feedback/ui/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Hodpage extends StatefulWidget {
  const Hodpage({super.key});

  @override
  State<Hodpage> createState() => _HodpageState();
}

class _HodpageState extends State<Hodpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    return DefaultTabController(length: 2,

      child: Scaffold(
        appBar: AppBar( bottom:TabBar(tabs: [Text("Account info"),Text("View Feedbacks")]) ,leading:  Builder(builder: (context) => IconButton(onPressed: ()
        {
             Scaffold.of(context).openDrawer();
        }, icon: Icon(Icons.list)),
         
      ),  title: Text("Hod page"),),
        body: TabBarView(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 170,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(13)),
                        child: FutureBuilder(
                          future: Provider.of<Hodprovider>(context,
                                  listen: false)
                              .fetchCurrentHod(),
                          builder: (context, snapshot) {
                            
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            if(snapshot.data==null)
                            {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasData||snapshot.data!=null) {
                              Provider.of<Hodprovider>(context,listen: false).Department=snapshot.data!["branch"];
                              return Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Name  : ${snapshot.data!["name"]}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Email  : ${snapshot.data!["email"]}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Department  : ${snapshot.data!["branch"]}"),
                                    )
                                  ],
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          Column(
          children: [
            
            Container(height: MediaQuery.of(context).size.height*0.7,width: MediaQuery.of(context).size.width,
            // child: FutureBuilder(future:  Provider.of<Hodprovider>(context).fetchFacultys(), builder: (context, snapshot) {
            //   if(snapshot.hasError)
            //   {
            //     return Center(child: Text(snapshot.error.toString()),);
            //   }
            //   if(snapshot.hasData)
            //   {
            //     return ListView.builder(itemBuilder: (context, index) {
            //       DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
                   
            //         return Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: GestureDetector(onTap: ()
            //           {
            //             Provider.of<Hodprovider>(context,listen: false).uid=documentSnapshot["id"];
            //               Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectYear(),));
            //           },
            //             child: ListTile(subtitle: Text(documentSnapshot["name"]),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)),
            //         );
            //     },
            //     itemCount: snapshot.data!.size,);
            //   }
            //   return Center(child: CircularProgressIndicator(),);
            // },
            // ),

//

            child: FutureBuilder<QuerySnapshot>(future: Provider.of<Hodprovider>(context,listen: false).fetchYear(), builder: (context, snapshot) {
        if(snapshot.hasError)
        {
          return Center(child: Text(snapshot.error.toString()),);
        }
        if(snapshot.hasData)
        {
           return ListView.builder(itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
              return Padding(padding: EdgeInsets.all(8),
              child: GestureDetector(onTap: ()
              {
                 Provider.of<Hodprovider>(context,listen: false).selectedYear=documentSnapshot["year"];
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const HodSem(),));
              },
              child: ListTile(title: Text(documentSnapshot["year"]),tileColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
              ),);
           },
           itemCount: snapshot.data!.size,);
        }
        return Center(child: CircularProgressIndicator(),);
      },
      ) ,
            )
          ],
        ),
        
        ]),
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
              title: Text('feedback (Faulty)'),
              onTap: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>FacultyForm() ));
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
      ),
    );
  }
}