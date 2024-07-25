import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/models/user.dart';
import 'package:test/screens/home_screen.dart';
import 'package:test/widgets/auth_title_container.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLogin = false;
  String? _enteredName;
  String? _enteredPhoneNumber;
  String _enteredEmail = "";
  String _enteredPassword = "";
  String? _enteredConfirmPassword;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
  }

  String? _emailValidator(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.trim().isEmpty) {
      return "Please enter a valid email.";
    } else if (!emailRegex.hasMatch(value.trim())) {
      return "Please enter a valid email.";
    }
    return null;
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    if ((_enteredConfirmPassword != _enteredPassword) && !_isLogin) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Center(child: Text("Confirm password doesn't match password")),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print("User signed in: ${userCredential.user!.email}");
        // UserClass aUser = UserClass(id: id, name: name, email: email, password: password, phoneNumber: phoneNumber)
      } else {
        final userCredentials =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);

        // created a user in the database
        var userCred = userCredentials.user!;
        UserClass aUser = UserClass(
            id: userCred.uid,
            name: _enteredName!,
            email: _enteredEmail,
            password: _enteredPassword,
            phoneNumber: _enteredPhoneNumber!);

        final url = Uri.parse("http://10.0.2.2:8080/api/users");
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "id": aUser.id,
            "name": aUser.name,
            "phoneNumber": aUser.phoneNumber,
            "email": aUser.email,
            "password": aUser.password,
          }),
        );

        if (response.statusCode == 200) {
          // Handle successful response
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Created'),
              content: Text('${response.body} : ${aUser.email} '),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text(
                    'Okay',
                  ),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.body),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          // Handle error response
        }

        print("User is: ${userCredentials.user!.uid}");
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'network-request-failed':
          errorMessage =
              "Network error occurred. Please check your connection and try again.";
          break;
        case 'email-already-in-use':
          errorMessage =
              "The email address is already in use by another account.";
          break;
        case 'invalid-credential':
          errorMessage = "Invalid email or password";
          break;
        case 'operation-not-allowed':
          errorMessage = "Operation not allowed. Please contact support.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        case 'user-disabled':
          errorMessage = "The user account has been disabled.";
          break;
        default:
          errorMessage = error.message ?? "Authentication failed.";
          break;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text(errorMessage)),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        double fontSizeTitle = width * 0.08;
        double paddingValue = width * 0.05;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 244, 255),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLogin)
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.4,
                        child: Image.asset('assets/images/Logo.png'),
                      ),
                    Padding(
                      padding: _isLogin
                          ? EdgeInsets.symmetric(horizontal: paddingValue)
                          : EdgeInsets.only(
                              top: paddingValue,
                              left: paddingValue,
                              right: paddingValue,
                            ),
                      child: Text(
                        _isLogin ? "Event Echo" : 'Sign up',
                        style: TextStyle(
                          fontSize: fontSizeTitle,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: _isLogin
                          ? EdgeInsets.only(bottom: paddingValue / 1.2)
                          : EdgeInsets.only(bottom: paddingValue / 3),
                      child: Text(
                        _isLogin
                            ? "Echoing Moments, Mastering Time"
                            : 'Tell us about you',
                        style: TextStyle(
                          fontSize: fontSizeTitle * 0.4,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    if (!_isLogin) const AuthTitleContainer(name: 'Name'),
                    if (!_isLogin)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        surfaceTintColor: Colors.white,
                        margin: EdgeInsets.only(
                          top: paddingValue / 3,
                          left: paddingValue * 2,
                          right: paddingValue * 2,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingValue,
                              vertical: paddingValue / 2 / 5),
                          child: TextFormField(
                            style: TextStyle(fontSize: fontSizeTitle * 0.4),
                            decoration: InputDecoration(
                              hintText: "eg. Andre Okeke",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: fontSizeTitle * 0.4,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter a name.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredName = value!;
                            },
                          ),
                        ),
                      ),
                    if (!_isLogin)
                      const AuthTitleContainer(name: 'Phone number'),
                    if (!_isLogin)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        surfaceTintColor: Colors.white,
                        margin: EdgeInsets.only(
                          top: paddingValue / 3,
                          left: paddingValue * 2,
                          right: paddingValue * 2,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingValue,
                              vertical: paddingValue / 2 / 5),
                          child: TextFormField(
                            style: TextStyle(fontSize: fontSizeTitle * 0.4),
                            decoration: InputDecoration(
                              hintText: "eg. 08022334455",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: fontSizeTitle * 0.4,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your phone number.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPhoneNumber = value!;
                            },
                          ),
                        ),
                      ),
                    const AuthTitleContainer(name: 'Email'),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_isLogin ? 10 : 40),
                      ),
                      surfaceTintColor: Colors.white,
                      margin: EdgeInsets.only(
                        top: paddingValue / 3,
                        left: paddingValue * 2,
                        right: paddingValue * 2,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingValue,
                            vertical: paddingValue / 2 / 5),
                        child: TextFormField(
                          style: TextStyle(fontSize: fontSizeTitle * 0.4),
                          decoration: InputDecoration(
                            hintText: "eg. you@email.com",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: fontSizeTitle * 0.4,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: _emailValidator,
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                      ),
                    ),
                    const AuthTitleContainer(name: 'Password'),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_isLogin ? 10 : 40),
                      ),
                      surfaceTintColor: Colors.white,
                      margin: EdgeInsets.only(
                        top: paddingValue / 3,
                        left: paddingValue * 2,
                        right: paddingValue * 2,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingValue,
                            vertical: paddingValue / 2 / 5),
                        child: TextFormField(
                          style: TextStyle(fontSize: fontSizeTitle * 0.4),
                          decoration: InputDecoration(
                            hintText: "Min. 8 characters",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: fontSizeTitle * 0.4,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: _obscureText
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value == null || value.trim().length < 8) {
                              return "Must be at least 8 characters long";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                      ),
                    ),
                    if (!_isLogin)
                      const AuthTitleContainer(name: 'Confirm Password'),
                    if (!_isLogin)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        surfaceTintColor: Colors.white,
                        margin: EdgeInsets.only(
                          top: paddingValue / 3,
                          left: paddingValue * 2,
                          right: paddingValue * 2,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingValue,
                              vertical: paddingValue / 2 / 5),
                          child: TextFormField(
                            style: TextStyle(fontSize: fontSizeTitle * 0.4),
                            decoration: InputDecoration(
                              hintText: "Match Password",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: fontSizeTitle * 0.4,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: _obscureText
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.trim().length < 8) {
                                return "Must be at least 8 characters long";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredConfirmPassword = value!;
                            },
                          ),
                        ),
                      ),
                    SizedBox(height: paddingValue * 2),
                    if (_isLogin)
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingValue * 3),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeTitle * 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                    if (!_isLogin)
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingValue * 3),
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeTitle * 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account?"
                              : "Already have an account?",
                          style: TextStyle(
                            color: const Color.fromARGB(199, 0, 0, 0),
                            fontSize: fontSizeTitle * 0.4,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin ? "Sign up" : "Login",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: fontSizeTitle * 0.4,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: paddingValue / 5),
                    if (_isLogin)
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: fontSizeTitle * 0.4,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
