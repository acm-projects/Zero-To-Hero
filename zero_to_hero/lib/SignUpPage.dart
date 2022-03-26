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
  final database = FirebaseDatabase.instance.reference();
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
        if(value!.isEmpty) {
          return "Please enter your Email";
        }
        // reg expression for email validation
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
          return "Please enter a valid Email";
        }
        //passes checks
        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next, //move to next field when done with this field
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white,
        filled: true,
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 133, 152, 199), width: 2.0),
          borderRadius: BorderRadius.circular(10),
        )
      ),
      style: const TextStyle(
        color: Colors.black,
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value){
        RegExp minsix = new RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return "Password is required for login";
        }
        if(!minsix.hasMatch(value)){
          return "Password too short(Min. 6 characters)";
        }
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next, //move to next field when done with this field
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white,
        filled: true,
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 133, 152, 199), width: 2.0),
          borderRadius: BorderRadius.circular(10),
        )
      ),
      style: const TextStyle(
        color: Colors.black,
      ),
    );

    //login button and routing
    final createAccountButton = Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(0),
        color: Colors.white,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            //create account in firebase
            //add a message that account was created
            signUp(emailController.text, passwordController.text);
          },
          child: const Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 133, 152, 199),
                fontWeight: FontWeight.bold
            ),
          ),
        )
    );

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 166, 189, 240),
        body: Center(
            child: Container(
                color: Color.fromARGB(255, 166, 189, 240),
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),//padding of the entire form
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                            "Create account",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            )
                        ),
                        const SizedBox(height: 50),
                        emailField,
                        const SizedBox(height: 10),
                        passwordField,
                        const SizedBox(height: 30),
                        createAccountButton,
                      ],
                    )
                )
            )
        )
    );
  }
  void signUp(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
          firestoreNewAccount()
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
      Navigator.pop(context);
    }
  }

  firestoreNewAccount() async{
    //calling our firestore
    //calling our user model
    //sending these values
    
    User? user = _auth.currentUser;
    final path = database.child('users/' + user!.uid);//needs to be changed to database.child("users/");

    //writing the values
    UserModel userModel = UserModel(user.uid);

    try{
      await path
          .set(userModel.toMap());
    }catch(e){
      Fluttertoast.showToast(msg: "Database write failed: $e");
      return;
    }
    Fluttertoast.showToast(msg: "Account created successfully");
  }
}
