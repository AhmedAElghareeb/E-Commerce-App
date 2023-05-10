import 'package:e_commerce/functions.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/user/productinfo.dart';
import 'package:flutter/material.dart';

Widget ProductsView(String pCategory, List<Product> allproducts)
{
  List<Product> products;
  products = getProductByCategory(pCategory, allproducts);

  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
    ),
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: GestureDetector(
        onTap: ()
        {
          Navigator.pushNamed(context, ProductInfo.id, arguments: products[index]);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage(
                  products[index].pLocation,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          products[index].pName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$ ${products[index].pPrice}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    itemCount: products.length,
  );
}