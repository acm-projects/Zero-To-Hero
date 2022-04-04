import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/UserModel.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}


class _SignUpPageState extends State<SignUpPage> {
  //auth
  final _auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.ref();
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your Email";
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return "Please enter a valid Email";
        }
        //passes checks
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      //move to next field when done with this field

      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 166, 189, 240),),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          // hintText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 255, 224, 206)),
          ),
          fillColor: const Color.fromARGB(255, 255, 224, 206),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 133, 152, 199), width: 4.0),
            borderRadius: BorderRadius.circular(15),
          )),
      style: const TextStyle(
        color: Colors.black,
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp minsix = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Password is required for Sign Up";
        }
        if (!minsix.hasMatch(value)) {
          return "Password too short(Min. 6 characters)";
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      //move to next field when done with this field
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),

          // hintText: "Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 255, 224, 206)),
          ),
          fillColor: const Color.fromARGB(255, 255, 224, 206),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 133, 152, 199), width: 4.0),
            borderRadius: BorderRadius.circular(15),
          )),
      style: const TextStyle(
        color: Colors.black,
      ),
    );

    //login button and routing
    //login button and routing
    //login button and routing

    final createAccountButton = Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(0),
        color: Colors.white,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
          minWidth: 380,
          onPressed: () {
            signUp(emailController.text, passwordController.text);
          },
          child: const Text(
            "Sign Up:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 133, 152, 163),
              fontWeight: FontWeight.bold,
            ),
          ),
        ));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Create account',
            style: TextStyle(color: Color.fromARGB(255, 166, 189, 240)),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 166, 189, 240),
        body: Center(
            child: Container(
                color: const Color.fromARGB(255, 166, 189, 240),
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                //padding of the entire form
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //this container displays the Create Account text
                        // Container(
                        //   child: const Text('Create account:',
                        //     style: TextStyle(
                        //       color: Color.fromARGB(255, 166, 189, 240),
                        //       fontSize: 40,
                        //     ),
                        //   ),
                        //   color: Colors.white,
                        //   margin: const EdgeInsets.only(left: 0, top:0, right: 0, bottom:0),
                        //   alignment: const AlignmentDirectional(0.0, 0.0),
                        //   width: 990,
                        //   height: 70,
                        // ),

                        const SizedBox(height: 100),
                        SizedBox(
                          height: 35,
                          //width: double.infinity,
                          //width: double.maxFinite,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 0, right: 250, bottom: 0),
                            child: const Text(
                              "Email",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        emailField,
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 30,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 0, right: 200, bottom: 0),
                            child: const Text(
                              "Password",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                          width: 300,
                        ),
                        passwordField,
                        const SizedBox(height: 180),
                        createAccountButton,
                      ],
                    )))));
  }
  void signUp(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
          firestoreNewAccount(email)
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
      Navigator.pop(context);
    }
  }

  firestoreNewAccount(String email) async{
    //calling our firestore
    //calling our user model
    //sending these values

    User? user = _auth.currentUser;
    final path = database.child('users/' + user!.uid);//needs to be changed to database.child("users/");
    //writing the values
    UserModel userModel = UserModel(user.uid);
    userModel.email = email;
    userModel.streak = 0;
    userModel.totalGoals = 0;
    userModel.longestStreak = 0;
    try{
      await path
          .update(userModel.toMap());
    }catch(e){
      Fluttertoast.showToast(msg: "Database write failed: $e");
      return;
    }
    Fluttertoast.showToast(msg: "Account created successfully");
  }
}
