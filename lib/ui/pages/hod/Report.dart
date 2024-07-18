import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/provider/HodProvider.dart';
import 'package:feedback/provider/facultyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // Use a Map to store expansion state for each item
  final Map<int, bool> isExpandedMap = {};

  @override
  Widget build(BuildContext context) {
    // Access MediaQuery outside build using a getter
    final mediaQuery = MediaQuery.of(context);
    double persum = 0;
    double size = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Card'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            Provider.of<Hodprovider>(context, listen: false).FetchSubjects(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListView.builder(
              itemCount: data.length - 1,
              itemBuilder: (context, index) {
                isExpandedMap[index] ??=
                    false; // Initialize state if not present

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(
                          () => isExpandedMap[index] = !isExpandedMap[index]!);
                      log(data["subject${index + 1}"].toString());
                      Provider.of<Hodprovider>(context, listen: false)
                          .barchart = true;
                      Provider.of<Hodprovider>(context, listen: false)
                          .selectSubject = data["subject${index + 1}"];
                      Provider.of<facultyProvider>(context, listen: false)
                          .selectedsubject = data["subject${index + 1}"];

                          Timer(Duration(seconds: 1),() =>setState(() {
                            
                          }) ,);
                    },
                    child: Container(
                      height: isExpandedMap[index]!
                          ? mediaQuery.size.height * 0.7
                          : 70,
                      width: mediaQuery.size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[300],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("  ${(index + 1).toString()} .",
                                  style: TextStyle(fontSize: 15)),
                              Text(data["subject${index + 1}"].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300)),
                              Spacer(),
                              isExpandedMap[index]!
                                  ? Expanded(
                                      child: FutureBuilder(
                                        future: Provider.of<Hodprovider>(
                                                context,
                                                listen: false)
                                            .fetchsubfac(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Flexible(
                                              child: Text(
                                                "        Faculty:  ${snapshot.data!["name"].toString()}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "    Questions",
                                style: TextStyle(
                                    fontSize: 18.5,
                                    ),
                              ),
                              Spacer(),
                              Text(
                                "avg   ",
                                style: TextStyle(
                                    fontSize: 18.5,
                                    ),
                              ),
                              Text(
                                "No.Res ",
                                style: TextStyle(
                                    fontSize: 18.5,
                                    ),
                              )
                            ],
                          ),
                          if (isExpandedMap[index]!)
                            Expanded(
                              child: FutureBuilder<QuerySnapshot>(
                                future: Provider.of<Hodprovider>(context,
                                                listen: false)
                                            .barchart ==
                                        true
                                    ? Provider.of<Hodprovider>(context,
                                            listen: false)
                                        .fetchBarchart()
                                    : Provider.of<facultyProvider>(context)
                                        .fetchBarchart(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Text(snapshot.error.toString()));
                                  }
                                  if (snapshot.hasData) {
                                    size =
                                        (snapshot.data!.size * 100).toDouble();

                                    persum = 0;
                                    return ListView.builder(
                                      itemCount: snapshot.data!.size,
                                      itemBuilder: (context, index) {
                                        double sum = 0;
                                        double avg = 0;
                                        double total = 0;
                                        DocumentSnapshot documentSnapshot =
                                            snapshot.data!.docs[index];
                                        Map<String, dynamic> database =
                                            documentSnapshot.data()
                                                as Map<String, dynamic>;
                                                Map<String, dynamic> demo1 =
                                            documentSnapshot.data()
                                                as Map<String, dynamic>;
                                        total = (database["total"] * 4)
                                            .toDouble(); // Fix the error here
                                        database.remove("qstn");
                                        database.remove("total");
                                        Map<String, double> demo = {};
                                        database.forEach((key, value) {
                                          if (value is num) {
                                            sum += value.toDouble();
                                            demo[key] = value.toDouble();
                                          } else {
                                            log("not num");
                                          }
                                        });
                                        persum += (sum / total) * 100.0;
                                        // log("Total percentage so far: ${(persum).toString()}");

                                        // log("the total sum is ${sum}");
                                        Provider.of<Hodprovider>(context,listen: false).totalper=((persum / size) * 100);

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    documentSnapshot["qstn"],
                                                    style: TextStyle(
                                                        fontSize: 14.5,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                    "${((sum / total) * 100.0).toString()} %"),
                                                SizedBox(width: 45),
                                                Text(demo1["total"].toString())
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          isExpandedMap[index]!
                              ? Text("Grand Total in (%) = ${Provider.of<Hodprovider>(context,listen: false).totalper.toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 19),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
