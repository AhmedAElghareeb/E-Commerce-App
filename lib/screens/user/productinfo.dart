import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/provider/cartitem.dart';
import 'package:e_commerce/screens/user/cartscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget
{
  static String id = "ProductInfo";

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(product.pLocation),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
            child: Container(
              height: MediaQuery.of(context).size.height* .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  GestureDetector(
                      onTap: ()
                      {
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        color: kMainColor,
                      ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Column(
              children: [
                Opacity(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.pName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            product.pDescription,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$ ${product.pPrice}",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                color: kMainColor,
                                child: IconButton(
                                  onPressed: ()
                                  {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 50.0,
                                ),
                              ),
                              Material(
                                color: kMainColor,
                                child: IconButton(
                                  onPressed: ()
                                  {
                                    if (quantity > 1)
                                    {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.remove),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  opacity: 0.5,
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Builder(
                    builder: (context) => MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                        ),
                      ),
                      color: kMainColor,
                      onPressed: ()
                      {
                        CartItem cartItem =
                        Provider.of<CartItem>(context, listen: false);
                        product.pQuantity = quantity;
                        bool exist = false;
                        var productsInCart = cartItem.products;
                        for (var productsInCart in productsInCart)
                        {
                          if (productsInCart.pName == product.pName)
                          {
                            exist = true;
                          }
                        }
                        if (exist)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Item Already In Cart",
                              ),
                            ),
                          );
                        }
                        else
                        {
                          cartItem.addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Item Added To Cart Successfully",
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Add To Cart".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}