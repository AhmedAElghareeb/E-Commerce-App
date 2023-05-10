import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/provider/cartitem.dart';
import 'package:e_commerce/screens/user/productinfo.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/widgets/custommenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget
{
  static String id = "CartScreen";
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
            "My Cart",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: ()
          {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )
        ),
      ),
      body: Column(
        children: [
          LayoutBuilder(
            builder: (context, constrains)
              {
                if (products.isNotEmpty)
                {
                return Container(
                  height: MediaQuery.of(context).size.height -
                      statusBarHeight -
                      appBarHeight -
                      MediaQuery.of(context).size.height * 0.07,
                  child: ListView.builder(
                    itemBuilder: (context, index)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTapUp: (details)
                          {
                            showCustomMenu(details, context, products[index]);
                          },
                          child: Container(
                            color: kSecondaryColor,
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.height * 0.15 / 2,
                                  backgroundImage: AssetImage(products[index].pLocation),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              products[index].pName,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                              "\$ ${products[index].pPrice}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: Text(
                                          products[index].pQuantity.toString(),
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: products.length,
                  ),
                );
                }
                else
                  {
                    return Container(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).size.height * 0.07 -
                          statusBarHeight -
                          appBarHeight,
                      child: Center(
                        child: Text(
                          "Cart Is Empty",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
              }
          ),
          Builder(
            builder: (context) => MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              minWidth: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              color: kMainColor,
              onPressed: ()
              {
                showCustomDialog(products, context);
              },
              child: Text(
                "Order".toUpperCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomMenu(details, context, product) async
  {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width - dx;
    double dy2 = MediaQuery.of(context).size.width - dy;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        dx,
        dy,
        dx2,
        dy2,
      ),
      items:
      [
        MyPopupMenuItem(
          onClick: ()
          {
            Navigator.pop(context);
            Provider.of<CartItem>(context, listen: false).deleteProduct(product);
            Navigator.pushNamed(context, ProductInfo.id, arguments: product);
          },
          child: Text("Edit"),
        ),
        MyPopupMenuItem(
          onClick: ()
          {
            Navigator.pop(context);
            Provider.of<CartItem>(context, listen: false).deleteProduct(product);
          },
          child: Text("Delete"),
        ),
      ],
    );
  }

  void showCustomDialog(List<Product> products, context)
  async {
    var price = getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        MaterialButton(
          onPressed: ()
          {
            try {
            Store _store = Store();
            _store.storeOrders(
              {
                kTotallPrice: price,
                kAddress: address,
              },
              products,
              );
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(
                  "ORDER CONFIRMED",
                ),
                ),
            );
            Navigator.pop(context);
            }catch (ex)
            {
              print(ex.message);
            }
          },
          child: Text(
              "CONFIRM",
          ),
        ),
      ],
      content: TextField(
        onChanged: (value)
        {
          address = value;
        },
        decoration: InputDecoration(
          hintText: "Enter Your Address...",
        ),
      ),
      title: Text("Total Price = \$ $price"),
    );
    await showDialog(
      context: context,
      builder: (context)
      {
        return alertDialog;
      },
    );
  }

  getTotalPrice(List<Product> products)
  {
    var price = 0;
    for(var product in products)
    {
      price += product.pQuantity * int.parse(product.pPrice);
    }
    return price;
  }
}