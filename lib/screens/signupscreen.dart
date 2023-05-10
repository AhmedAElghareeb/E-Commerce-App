import 'package:e_commerce/constants.dart';
import 'package:e_commerce/provider/modalhud.dart';
import 'package:e_commerce/screens/user/homepage.dart';
import 'package:e_commerce/screens/loginscreen.dart';
import 'package:e_commerce/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatefulWidget
{
  static String id = "SignUpScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _email, _password;
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: kMainColor,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<ModalHud>(context).isLoading,
          child: Form(
            key: _globalKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*.2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: AssetImage("images/icons/buy.png"),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: Text(
                            "E-Commerce Store",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height*.1,
                ),
                CustomTextField(
                  onClick: (value) {},
                    icon: Icons.person,
                    hint: "Enter Your Name",
                ),
                SizedBox(
                  height: height*.02,
                ),
                CustomTextField(
                  onClick: (value)
                  {
                    _email = value;
                  },
                  hint: "Enter Your E-Mail",
                  icon: Icons.email,
                ),
                SizedBox(
                  height: height*.02,
                ),
                CustomTextField(
                  onClick: (value)
                  {
                    _password = value;
                  },
                  hint: "Enter Your Password",
                  icon: Icons.lock,
                ),
                SizedBox(
                  height: height*.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120.0,),
                  child: Builder(
                    builder: (context) {
                      return MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.black,
                        onPressed: ()
                        async {
                          final modalhud = Provider.of<ModalHud>(context, listen: false);
                          modalhud.changeisLoading(true);
                          if(_globalKey.currentState.validate())
                            {
                              _globalKey.currentState.save();
                              try {
                                final authresult = await _auth.signUp(
                                  _email.trim(), _password.trim(),
                                );
                                modalhud.changeisLoading(false);
                                Navigator.pushNamed(context, HomePage.id);
                              }on PlatformException catch(e)
                              {
                                modalhud.changeisLoading(false);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                  e.message,
                                ),
                                ));
                              }
                            }
                          modalhud.changeisLoading(false);
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      );
                    }
                  ),
                ),
                SizedBox(
                  height: height*.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account ? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 16.0),
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}