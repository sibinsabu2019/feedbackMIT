import 'dart:developer';

import 'package:feedback/provider/craeteForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class createsubject extends StatefulWidget {
  const createsubject({
    super.key,
  });

  @override
  State<createsubject> createState() => _createsubjectState();
}

class _createsubjectState extends State<createsubject> {
  List<TextEditingController> _SubjectControllers = [TextEditingController()];
  @override
  Widget build(BuildContext context) {
    return  Container(margin: EdgeInsets.all(10),

      child: SingleChildScrollView(
        child: Column(
              children: [
                // Display existing text fields
                ..._SubjectControllers.asMap().entries.map((entry) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: 'Subject ${entry.key + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _SubjectControllers .removeAt(entry.key);
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 20),
                // Button to add more text fields
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _SubjectControllers .add(TextEditingController());
                    });
                  },style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                  child: Text('Add More Subject'),
                ),
                ElevatedButton(onPressed: ()async
                {
                  log("jjjj");
                     log(_SubjectControllers
                          .map((controller) => controller.text)
                          .toList().toString());
                       await   Provider.of<CreateForm>(context,listen: false).addsubjects(_SubjectControllers
                          .map((controller) => controller.text)
                          .toList());
                   setState(() {
                    _SubjectControllers.forEach((controller) => controller.clear());
                   });
                   Navigator.pop(context);
                  

                },style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                 child: Text("Add to database"))
              ],
            ),
      ),
    );
  }
}