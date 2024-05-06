import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:feedback/ui/pages/Faculty/subject.dart';
import 'package:feedback/ui/pages/Student/selectSubject.dart';
import 'package:feedback/ui/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FacultyHome extends StatefulWidget {
  const FacultyHome({super.key});

  @override
  State<FacultyHome> createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
                tabs: [Text("Account info"), Text("View Feedbaks")]),
            title: Text(" Faculty page"),
            actions: [
              IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
                    Provider.of<AdminProvider>(context, listen: false)
                        .clearData();
                    Provider.of<CreateForm>(context, listen: false).clearData();
                    Provider.of<facultyProvider>(context, listen: false)
                        .clearData();
                    Provider.of<Hodprovider>(context, listen: false)
                        .clearData();
                    Provider.of<StudentProvider>(context, listen: false)
                        .clearData();
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
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
                          future: Provider.of<facultyProvider>(context,
                                  listen: false)
                              .fetchFaculty(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            if (snapshot.hasData) {
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

            // Text("Select Batch",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<QuerySnapshot>(
                future: Provider.of<facultyProvider>(context, listen: false)
                    .fetchYear(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Provider.of<facultyProvider>(context,
                                        listen: false)
                                    .selectedYear = documentSnapshot["year"];
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const FacultySub(),
                                ));
                              },
                              child: ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                title: Text(documentSnapshot["year"]),
                                tileColor: Colors.grey[300],
                              )),
                        );
                      },
                      itemCount: snapshot.data!.size,
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ])),
    );
  }
}
