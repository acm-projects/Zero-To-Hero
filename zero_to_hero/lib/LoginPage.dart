import 'package:flutter/material.dart';
import 'package:zero_to_hero/SignUpPage.dart';

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

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // validator: ,
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
      // validator: ,
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
        onPressed: () {},
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.lightBlue,
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
          child: const Text("Create an account", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white)),
        )
      ]
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.lightBlue,
          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),//padding of the entire form
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Welcome Back",
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
        )
      )
    );
  }
}
