import 'package:e_commerce/constants.dart';
import 'package:e_commerce/provider/adminmode.dart';
import 'package:e_commerce/provider/modalhud.dart';
import 'package:e_commerce/screens/admin/adminhome.dart';
import 'package:e_commerce/screens/user/homepage.dart';
import 'package:e_commerce/screens/signupscreen.dart';
import 'package:e_commerce/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget
{
  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _email, _password;
  final _auth = Auth();
  bool isAdmin = false;
  final adminPass = "admin1234";
  bool keepMeLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: Form(
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
                          color: Colors.white,
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Theme(
                    child: Checkbox(
                      checkColor: kSecondaryColor,
                      activeColor: kMainColor,
                      value: keepMeLoggedIn,
                      onChanged: (value)
                      {
                        setState(() {
                          keepMeLoggedIn = value;
                        });
                      },
                    ),
                    data: ThemeData(
                      unselectedWidgetColor: Colors.white,
                    ),
                  ),
                  Text(
                    "Remember Me",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
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
                    onPressed: () {
                      if(keepMeLoggedIn == true)
                        {
                          keepUserLoggedIn();
                        }
                      _validate(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
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
                    "Don't have an account ? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.pushNamed(context, SignUpScreen.id);
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 30.0),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                        onTap: ()
                        {
                          Provider.of<AdminMode>(context, listen: false).changeIsAdmin(true);
                        },
                        child: Text(
                            "i am an admin",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin ? kMainColor : Colors.white,
                          ),
                        ),
                      ),
                  ),
                  Expanded(
                      child: GestureDetector(

                        onTap: ()
                        {
                          Provider.of<AdminMode>(context, listen: false).changeIsAdmin(false);
                        },
                        child: Text(
                            "i am a user",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin ? Colors.white : kMainColor,
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modelhud = Provider.of<ModalHud>(context, listen: false);
    modelhud.changeisLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_password == adminPass) {
          try {
            await _auth.signin(_email.trim(), _password.trim());
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelhud.changeisLoading(false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          }
        } else {
          modelhud.changeisLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong !'),
          ));
        }
      } else {
        try {
          await _auth.signin(_email.trim(), _password.trim());
          Navigator.pushNamed(context, HomePage.id);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
          ));
        }
      }
    }
    modelhud.changeisLoading(false);
  }

  void keepUserLoggedIn() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kKeepMeLoggedIn, keepMeLoggedIn);
  }

}