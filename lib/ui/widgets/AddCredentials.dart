import 'dart:developer';
import 'dart:ffi';

import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/provider/adminProvider.dart';

import 'package:feedback/ui/pages/login.dart';
import 'package:feedback/ui/widgets/snackbar.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AddCredentials extends StatefulWidget {
  const AddCredentials({super.key});

  @override
  State<AddCredentials> createState() => _AddCredentialsState();
}

class _AddCredentialsState extends State<AddCredentials> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool loading = false;
    bool view =true;
  String SelectedDepatment = "Select Department";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminProvider>(context, listen: false).FetchDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            TextFileds(view: false,
              controller: email,
              icon: Icons.email_rounded,
              label: "Enter email",
            ),
            TextFileds(
              view: true,
                controller: password,
                icon: Icons.security,
                label: "Enter password"),
            TextFileds(
              view: false,
              controller: name,
              icon: Icons.person,
              label: " Enter your name",
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Provider.of<StudentProvider>(context, listen: false)
                                  .SelectedRole ==
                              "student" ||
                          Provider.of<AdminProvider>(context, listen: false)
                                  .selectedRole ==
                              "Principal"
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: 
                                      
                                           Expanded(
                                             child: SizedBox(height: MediaQuery.of(context).size.height*0.5,
                                             width: MediaQuery.of(context).size.width*0.5,
                                               child: ListView.builder(
                                                                                       itemCount: Provider.of<AdminProvider>(
                                                    context,
                                                    listen: false)
                                                .DepartmentList
                                                .length,
                                                                                       itemBuilder: (context, index) {
                                                                                         return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        SelectedDepatment = Provider
                                                                .of<AdminProvider>(
                                                                    context,
                                                                    listen: false)
                                                            .DepartmentList[index];
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: ListTile(
                                                      title: Text(Provider.of<
                                                                  AdminProvider>(
                                                              context,
                                                              listen: false)
                                                          .DepartmentList[index]),
                                                    )),
                                                                                         );
                                                                                       },
                                                                                    
                                                                                 ),
                                             ),
                                           ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                          child: Text("$SelectedDepatment")),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.22,
            ),
            Padding(
              padding: const EdgeInsets.all(19),
              child: GestureDetector(
                onTap: () async {
                   if (Provider.of<StudentProvider>(context, listen: false)
                          .SelectedRole ==
                           "student") {
                          if (email.text == "") {
                            CustomSnackbar.ErrorSnackbar(context, "Email is null");
                            return;
                          }
                          if (password.text.length < 6) {
                            CustomSnackbar.ErrorSnackbar(
                            context, "password length is less than 6");
                            return;
                          }
                          if (name.text == "") {
                           CustomSnackbar.ErrorSnackbar(
                           context, "User name is null");
                           return;
                          }
                           setState(() {
                           loading = true;
                           });
                         bool success = await Provider.of<StudentProvider>(context,
                            listen: false)
                        .CreateStudent(
                            name: name.text,
                            email: email.text,
                            password: password.text);

                       if (success) {
                         CustomSnackbar.success(context,
                          "Your account is created. you can log in now");
                          Navigator.of(context).popUntil((route) => route.isFirst);
                           Navigator.pushReplacement(
                          context,
                           MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                          setState(() {
                          loading = false;
                         });
                        } else {
                         setState(() {
                         loading = false;
                         });
                         log("false");
                         CustomSnackbar.ErrorSnackbar(
                          context,
                          Provider.of<StudentProvider>(context, listen: false)
                              .Error
                              .toString());
                          }
                  } 
                  else {
                    if (email.text == "") {
                      CustomSnackbar.ErrorSnackbar(context, "Email is null");
                      return;
                    }
                    if (password.text.length < 6) {
                      CustomSnackbar.ErrorSnackbar(
                          context, "password length is less than 6");
                      return;
                    }
                    if (name.text == "") {
                      CustomSnackbar.ErrorSnackbar(
                          context, "User name is null");
                      return;
                    }
                    if (SelectedDepatment == "Select Department") {
                      if (Provider.of<AdminProvider>(context, listen: false)
                              .selectedRole ==
                          "Principal") {
                        log("messagejgjgkfyjfhui");
                      } else {
                        CustomSnackbar.ErrorSnackbar(
                            context, "Department is not Selected");
                        return;
                      }
                    }
                    setState(() {
                      loading = true;
                    });
                        bool success =
                        await Provider.of<AdminProvider>(context, listen: false)
                            .signinCredentials(
                                email.text.toLowerCase().trim(),
                                password.text.trim(),
                                name.text.trim(),
                                SelectedDepatment);

                    if (success) {
                      setState(() {
                        loading = false;
                      });
                      CustomSnackbar.success(context, "Account created");
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        loading = false;
                      });
                      CustomSnackbar.ErrorSnackbar(
                          context,
                          Provider.of<AdminProvider>(context, listen: false)
                              .Error
                              .toString());
                    }
                  }
                },
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.7,
                              blurRadius: 7)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loading == false
                          ? Text(
                              "Create Account for ${Provider.of<AdminProvider>(context).selectedRole == null ? Provider.of<StudentProvider>(context, listen: false).SelectedRole : Provider.of<AdminProvider>(context).selectedRole}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 34, 15, 17),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            )
                          : CircularProgressIndicator(),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextFileds extends StatelessWidget {
  const TextFileds(
      {super.key,
      required this.view,
      required this.controller,
      required this.icon,
      required this.label});

  final TextEditingController controller;
  final IconData? icon;
  final String label;
  final bool? view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 1, left: 16, right: 16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.083,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.7,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ]),
        child: TextField(
          obscureText:view! ,
          controller: controller,
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: label,
              border: const OutlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}
