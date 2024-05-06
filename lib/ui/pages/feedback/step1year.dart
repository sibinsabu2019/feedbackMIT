import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/craeteForm.dart';
import 'package:feedback/ui/pages/feedback/step2branch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Step1 extends StatefulWidget {
  const Step1({super.key});

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  String? batch;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            "Select Batch ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 50,),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              height: 200,
              child: FutureBuilder(
                future: Provider.of<CreateForm>(context, listen: false).fetchyear(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    log("dataaaaaaaaaaaaaa indddddd");
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                        log("message");
                        log(documentSnapshot["year"].toString());

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                batch = documentSnapshot["year"];
                                Provider.of<CreateForm>(context,listen: false).selectedYear=documentSnapshot["year"];
                              });
                              log(documentSnapshot["year"]);
                               Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectBranch(),));
                            },
                            child: ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              title: Text(documentSnapshot["year"]),
                              tileColor: Colors.grey[300],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
         
          batch != null ? Text("selected batch:$batch") : const Text("batch is not selected"),
           
        ],
      ),
    );
  }
}
