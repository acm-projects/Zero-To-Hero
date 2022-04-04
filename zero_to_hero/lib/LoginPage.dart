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
        //prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 255, 255, 255),),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide:  const BorderSide(color: Color.fromARGB(255, 255, 224, 206)),
          ),
        fillColor: const Color.fromARGB(255, 255, 224, 206),
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
        //prefixIcon: const Icon(Icons.vpn_key, color: Color.fromARGB(255, 166, 189, 240),),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide:  const BorderSide(color: Color.fromARGB(255, 255, 224, 206)),
          ),

        fillColor: Color.fromARGB(255, 255, 224, 206),
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

    // Align (alignment: Alignment.bottomCenter,)
    //login button and routing
    final loginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(0),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },

        child: const Text(
          "Login:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 133, 152, 199),
            fontWeight: FontWeight.bold
          ),
        ),
      ),
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
                  const SizedBox(height: 70),
                  const Text(
                    "Welcome\nback:",
                      textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    )
                  ),
                  const SizedBox(height: 70),
                  SizedBox (
                      height: 30,
                      width: double.infinity,
                      child: Container (
                        child: const Text(
                            "Email",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            )
                        ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  emailField,
                  const SizedBox(height: 20),
                  SizedBox (
                    height: 28,
                    width: double.infinity,
                    child: Container (
                      child: const Text(
                          "Password",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  passwordField,
                  const SizedBox(height: 100),
                  loginButton,
                  const SizedBox(height: 8),
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
                builder: (context) => NavBar(uid: uid.user?.uid as String))
            )}).catchError((e){
            Fluttertoast.showToast(msg: e!.message);
          });
    }
}
}

