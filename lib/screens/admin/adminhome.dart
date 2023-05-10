import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/admin/addproduct.dart';
import 'package:e_commerce/screens/admin/manageproduct.dart';
import 'package:e_commerce/screens/admin/orderscreen.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget
{
  static String id = "AdminHome";

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          MaterialButton(
            color: kSecondaryColor,
            onPressed: () {
              Navigator.pushNamed(context, AddProduct.id);
            },
            child: Text('Add Product'),
          ),
          MaterialButton(
            color: kSecondaryColor,
            onPressed: () {
              Navigator.pushNamed(context, ManageProduct.id);
            },
            child: Text('Edit Product'),
          ),
          MaterialButton(
            color: kSecondaryColor,
            onPressed: () {
              Navigator.pushNamed(context, OrderScreen.id);
            },
            child: Text('View orders'),
          )
        ],
      ),
    );
  }
}