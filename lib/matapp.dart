import 'package:e_commerce/constants.dart';
import 'package:e_commerce/provider/adminmode.dart';
import 'package:e_commerce/provider/cartitem.dart';
import 'package:e_commerce/provider/modalhud.dart';
import 'package:e_commerce/screens/admin/addproduct.dart';
import 'package:e_commerce/screens/admin/adminhome.dart';
import 'package:e_commerce/screens/admin/editproduct.dart';
import 'package:e_commerce/screens/admin/manageproduct.dart';
import 'package:e_commerce/screens/admin/orderdetail.dart';
import 'package:e_commerce/screens/admin/orderscreen.dart';
import 'package:e_commerce/screens/loginscreen.dart';
import 'package:e_commerce/screens/signupscreen.dart';
import 'package:e_commerce/screens/splashscreen.dart';
import 'package:e_commerce/screens/user/cartscreen.dart';
import 'package:e_commerce/screens/user/homepage.dart';
import 'package:e_commerce/screens/user/productinfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp extends StatefulWidget
{
  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<SharedPreferences>
      (
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot)
      {
        if(!snapshot.hasData)
          {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    "Loading...",
                  ),
                ),
              ),
            );
          }
        else
        {
          isUserLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers:
            [
              ChangeNotifierProvider<ModalHud>(
                create: (context) => ModalHud(),),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: isUserLoggedIn ? HomePage.id : SplashScreen.id,
              routes:
              {
                ProductInfo.id : (context) => ProductInfo(),
                SplashScreen.id : (context) => SplashScreen(),
                LoginScreen.id : (context) => LoginScreen(),
                SignUpScreen.id : (context) => SignUpScreen(),
                AdminHome.id : (context) => AdminHome(),
                HomePage.id : (context) => HomePage(),
                AddProduct.id : (context) => AddProduct(),
                ManageProduct.id : (context) => ManageProduct(),
                EditProduct.id : (context) => EditProduct(),
                CartScreen.id : (context) => CartScreen(),
                OrderScreen.id : (context) => OrderScreen(),
                OrderDetail.id : (context) => OrderDetail(),
              },
            ),
          );
        }
      },
    );
  }
}