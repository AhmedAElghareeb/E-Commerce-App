import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/widgets/customtextfield.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatelessWidget
{
  static String id = "EditProduct";
  String _name, _price, _description, _category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
            ),
            Column(
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

                    _store.editProduct({
                      kProductName: _name,
                      kProductLocation: _imageLocation,
                      kProductCategory: _category,
                      kProductDescription: _description,
                      kProductPrice: _price,
                    },
                      product.pId,
                    );
                  }
                },
                child: Text(
                  "Add",
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}