import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/widgets/customtextfield.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatelessWidget
{
  static String id = "AddProduct";
  String _name, _price, _description, _category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              onClick: (value)
              {
                _name = value;
              },
              hint: "Product Name",
            ),
            SizedBox(height: 10,),
            CustomTextField(
              onClick: (value)
              {
                _price = value;
              },
              hint: "Product Price",
            ),
            SizedBox(height: 10,),
            CustomTextField(
              onClick: (value)
              {
                _description = value;
              },
              hint: "Product Description",
            ),
            SizedBox(height: 10,),
            CustomTextField(
              onClick: (value)
              {
                _category = value;
              },
              hint: "Product Category",
            ),
            SizedBox(height: 10,),
            CustomTextField(
              onClick: (value)
              {
                _imageLocation = value;
              },
              hint: "Product Location",
            ),
            SizedBox(height: 20,),
            MaterialButton(
              color: kSecondaryColor,
              onPressed: () {
                if (_globalKey.currentState.validate()) {
                  _globalKey.currentState.save();

                  _store.addProduct(Product(
                      pName: _name,
                      pPrice: _price,
                      pDescription: _description,
                      pLocation: _imageLocation,
                      pCategory: _category,
                  ),
                  );
                }
              },
              child: Text(
                "Add",
              ),
            ),
          ],
        ),
      ),
    );
  }
}