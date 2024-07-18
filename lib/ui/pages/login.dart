import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:feedback/loginSelection/loginAdmin.dart';
import 'package:feedback/loginSelection/loginFaculty.dart';
import 'package:feedback/loginSelection/loginHOD.dart';
import 'package:feedback/loginSelection/loginPrincipal.dart';
import 'package:feedback/provider/StudentProvider.dart';
import 'package:feedback/ui/pages/Student/Home.dart';
import 'package:feedback/ui/pages/Student/signup.dart';
import 'package:feedback/ui/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool view =true;
  String _selectedRole = 'student'; // Initial selected role
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  TextEditingController Email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
  Future<void>ResetPassword()async
  {
   try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: Email.text.trim());
       CustomSnackbar.success(context, "Password reset link sent to your email!");
   }  
    on FirebaseAuthException catch(ex)
   {
      CustomSnackbar.ErrorSnackbar(context, ex.code);
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.teal, // Example app bar color
      ),
      body: loading == false
          ? Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding:
                        EdgeInsets.all(20.0), // Add padding to form container
                    decoration: BoxDecoration(
                      color: Colors
                          .grey.shade200, // Set container background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Subtle shadow
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Add your app logo here (consider using an Image widget)
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          hint: const Text('Select Role'),
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'student',
                              child: Text('Student'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'faculty',
                              child: Text('Faculty'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'principal',
                              child: Text('Principal'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'hod',
                              child: Text('HOD'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'admin',
                              child: Text('Admin'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true, // Add fill color to dropdown
                            fillColor:
                                Colors.grey.shade300, // Lighter grey fill
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners
                              borderSide: BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: Email,
                          decoration: InputDecoration(
                            labelText: 'Email id',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners
                              borderSide: BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(obscureText:view,
                          controller: password,
                          decoration: InputDecoration(
                          prefix: IconButton(onPressed: ()
                          {
                            setState(() {
                              view=!view;
                            });
                          }, icon: Icon(view==true?Icons.visibility:Icons.visibility_off))
                          ,
                            labelText: 'password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners
                              borderSide: const BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: ()async {
                                  if(Email.text.isEmpty)
                                  {
                                     CustomSnackbar.ErrorSnackbar(context, "Please enter your Email");

                                  }
                                  else

                                  {
                                   await ResetPassword();
                                  }
                                },
                                child: const Text(
                                  "forgot password ?",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.teal),
                                ))
                          ],
                        ),

                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Handle login logic with the selected role and other form values
                              log('Login with role: $_selectedRole');
                              log("email  ${Email.text}");
                              if (_selectedRole == "admin") {
                                setState(() {
                                  loading = true;
                                });
                                await LoginControllerAdmin.loginAdmin(
                                    context, _selectedRole, Email, password);
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                              if (_selectedRole == 'hod') {
                                setState(() {
                                  loading = true;
                                });
                                await LoginControllerHOD.loginHOD(
                                    context, _selectedRole, Email, password);
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                              if (_selectedRole == 'faculty') {
                                setState(() {
                                  loading = true;
                                });
                                await LoginControllerFaculty.loginFaculty(
                                    context, _selectedRole, Email, password);
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                              if (_selectedRole == 'principal') {
                                setState(() {
                                  loading = true;
                                });
                                await LoginControllerPrincipal.loginPrincipal(
                                    context, _selectedRole, Email, password);
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }

                              if (_selectedRole == "student") {
                                setState(() {
                                  loading = true;
                                });
                                log("haiiii");
                               bool success= await Provider.of<StudentProvider>(context,
                                        listen: false)
                                    .signin(Email.text.trim(),
                                        password.text.trim());
                                if (success) {
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const Homescreen(),
                                  ));
                                  CustomSnackbar.success(context, "login success");
                                } else {
                                  

                                  setState(() {
                                    loading = false;
                                  });
                                  
                                  String Error=Provider.of<StudentProvider>(context,listen: false).Error!;
                                   setState(() {
                                     loading= false;
                                   });
                                 if(Error=="invalid-credential")
                                   CustomSnackbar.ErrorSnackbar(context,"Invalid email or password");
                                }
                               
                              }
                            }
                          },
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .teal, // Set button color (matches app bar)
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _selectedRole == "student"
                              ? Row(
                                  children: [
                                    const Text("If you dont have an account "),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => Signup(),
                                        ));
                                      },
                                      child: const Text(
                                        "sign up",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.teal),
                                      ),
                                    )
                                  ],
                                )
                              : const Text(""),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
                strokeWidth: 4,
                strokeAlign: 5,
              ),
            ),
    );
  }
}
