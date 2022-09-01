import 'package:azwords/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late String _email;

  late String _password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextInputField(
              labelText: 'Email',
              calback: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextInputField(
              labelText: 'Password',
              calback: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await _auth
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      try {
                        await _auth
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                        });
                      } catch (e) {
                        return;
                      }
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.pink[400]),
                  height: 60,
                  alignment: Alignment.center,
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  const TextInputField({Key? key, required this.labelText, this.calback})
      : super(key: key);
  final String labelText;
  final Function(String)? calback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onChanged: calback,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.blue, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 22, 151, 202),
            ),
          ),
        ),
      ),
    );
  }
}
