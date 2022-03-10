import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zero_to_hero/SignUpPage.dart';
import 'package:zero_to_hero/NavBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

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
        prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 166, 189, 240),),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white,
        filled: true,
          focusedBorder: OutlineInputBorder (
            borderSide: const BorderSide(color: Color.fromARGB(255, 133, 152, 199), width: 4.0),
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
        prefixIcon: const Icon(Icons.vpn_key, color: Color.fromARGB(255, 166, 189, 240),),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder ( //highlighted border color
          borderSide: const BorderSide(color: Color.fromARGB(255, 133, 152, 199), width: 4.0),
          borderRadius: BorderRadius.circular(10),
        )
      ),
      style: const TextStyle(
        color: Colors.black,
      ),
    );

    //login button and routing
    final loginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 133, 152, 199),
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );

    //create an account row and routing
    final createAccountRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("New? ", style: TextStyle(color: Colors.white)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage())
            );
          },
          child: const Text("Create account:", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white)),
        )
      ]
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 166, 189, 240),
      body: Center(
        child: SingleChildScrollView(
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
                    "Welcome\nback:",
                      textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    )
                  ),
                  const SizedBox(height: 50),
                  emailField,
                  const SizedBox(height: 10),
                  passwordField,
                  const SizedBox(height: 30),
                  loginButton,
                  const SizedBox(height: 5),
                  createAccountRow
                ],
              )
            )
          ),
        )
      )
    );
  }

  //login function
void signIn(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
            Fluttertoast.showToast(msg: "Login Successful"),
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const NavBar())
            )}).catchError((e){
            Fluttertoast.showToast(msg: e!.message);
          });
    }
}
}

