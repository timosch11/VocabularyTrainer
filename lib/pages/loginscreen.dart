import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'registerscreen.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLoginWidget extends StatefulWidget {
  const MyLoginWidget({super.key});

  @override
  MyLoginWidgetState createState() => MyLoginWidgetState();
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyLoginWidgetState extends State<MyLoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MyHomeWidget();
                  } else {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (!isKeyboard)
                                Image(
                                    image: AssetImage('assets/images/logo.png'),
                                    width: 144,
                                    height: 185),
                              if (!isKeyboard)
                                BubbleSpecialThree(
                                  text: 'Hi!',
                                  color: Color(0xffA1CAD0),
                                  tail: true,
                                  isSender: false,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                            ],
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Welcome 👋",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Color(0xffA1CAD0),
                                      fontWeight: FontWeight.bold))),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Form(
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        labelText: "E-Mail",
                                        hintText: "Please, enter your e-mail address",
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder()),
                                    onChanged: (String value) {},
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? "Bitte wähle eine E-Mail Adresse"
                                          : null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextFormField(
                                    obscureText: true,
                                    obscuringCharacter: "*",
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        hintText: "Please, enter your Password",
                                        prefixIcon: Icon(Icons.password),
                                        border: OutlineInputBorder()),
                                    onChanged: (String value) {},
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? "Bitte wähle ein Passwort"
                                          : null;
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, right: 50),
                                      child: MaterialButton(
                                        onPressed: () {
                                          signIn();
                                        },
                                        child: Text(
                                          "Login",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        height: 70,
                                        minWidth: 150,
                                        color: Color(0xffA1CAD0),
                                        textColor: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyRegWidget()));
                                        },
                                        child: Text(
                                          "Register",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        height: 70,
                                        minWidth: 150,
                                        color: Color(0xffA1CAD0),
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          )
                        ]);
                  }
                })));
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
