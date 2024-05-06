import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FacultyForm2 extends StatelessWidget {
  FacultyForm2({super.key});
  TextEditingController value = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Provider.of<Hodprovider>(context,listen: false).selected();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: Provider.of<Hodprovider>(context, listen: false)
                    .fetchFacultyform(),
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              documentSnapshot["qstn"],
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          TextField(keyboardType: TextInputType.number,
                                            controller: value,
                                            decoration: InputDecoration(
                                                labelText: "Enter point"),
                                          ),
                                          CupertinoButton(child: Text("Submit"), onPressed: ()
                                          {
                                             Provider.of<Hodprovider>(context,listen: false).SubmitForm( documentSnapshot["qstn"],int.parse(value.text));
                                             Navigator.pop(context);
                                          })
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ListTile(
                                title: Text(documentSnapshot["qstn"]),
                                tileColor: 
                                // Provider.of<Hodprovider>(context,listen: false).feedbackList[index]==documentSnapshot["qstn"]?
                                Colors.grey[200],
                              )),
                        );
                      },
                      itemCount: snapshot.data!.size,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
