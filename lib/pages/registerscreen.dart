import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:age_calculator/age_calculator.dart';
import "home.dart";

class MyRegWidget extends StatefulWidget {
  const MyRegWidget({super.key});

  @override
  _MyRegisterWidgetState createState() => _MyRegisterWidgetState();
}

class _MyRegisterWidgetState extends State<MyRegWidget> {
  bool isChecked = false;
  DateTime date = DateTime(2022, 12, 24);
  String textfordate = "Geburtstag";
  late DatabaseReference dbRef;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final birthdayController = TextEditingController();
  final passwordController = TextEditingController();
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("Student");
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
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
                          text: 'Schön dich \nkennen zu \nlernen',
                          color: Color(0xffA1CAD0),
                          tail: true,
                          isSender: false,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 25),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "E-Mail",
                          hintText: "Gebe hier deine E-Mail Adresse an",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()),
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty
                            ? "Bitte gebe hier deine e-mail Adresse an"
                            : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Nutzername",
                          hintText: "Gebe hier deinen Nutzernamen an",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()),
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty
                            ? "Bitte gebe hier deinen Nutzernamen an"
                            : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: birthdayController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: textfordate,
                          hintText: "Gebe hier dein Geburtsdatum an",
                          prefixIcon: Icon(Icons.date_range),
                          border: OutlineInputBorder()),
                      onChanged: (String value) {},
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(1920),
                          lastDate: DateTime(2025),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Color(
                                      0xffA1CAD0), // header background color
                                  onPrimary: Colors.black, // header text color
                                  onSurface: Colors.green, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary:
                                        Color(0xffA1CAD0), // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (newDate == null) return;
                        setState(() {
                          date = newDate;
                          textfordate =
                              "${date.day} - ${date.month} - ${date.year}";
                        });
                      },
                      validator: (value) {
                        return value!.isEmpty
                            ? "Bitte gebe hier deine e-mail Adresse an"
                            : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Nun musst du nurnoch ein Passwort wählen",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      obscureText: true,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "und es einmal bestätigen",
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder()),
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty
                            ? "Bitte bestätige dein Passwort"
                            : null;
                      },
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text(
                        "Ich habe die AGB's gelesen und bin mindestens 8 Jahre alt"),
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    value: isChecked,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: MaterialButton(
                      onPressed: () {
                        Map<String, String> Student = {
                          "email": emailController.text,
                          "username": usernameController.text,
                          "birthday": date.toString(),
                          "age": AgeCalculator.age(date).years.toString(),
                          "password": passwordController.text
                        };
                        dbRef.set(Student);
                        signUp();
                        signIn();
                      },
                      child: Text(
                        "Registrieren!",
                        style: TextStyle(fontSize: 20),
                      ),
                      height: 70,
                      minWidth: 200,
                      color: Color(0xffA1CAD0),
                      textColor: Colors.white,
                    ),
                  ),
                ])));
  }

  Future signUp() async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      User? user = result.user;
      user?.updateDisplayName(usernameController.text);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyHomeWidget()));
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
