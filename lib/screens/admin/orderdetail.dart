import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/store.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatelessWidget
{
  static String id = "OrderDetail";
  Store store = Store();

  @override
  Widget build(BuildContext context) {
    String documentId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: store.loadOrdersDetails(documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData)
          {
            List<Product> products = [];
            for (var doc in snapshot.data.documents)
            {
              products.add(Product(
                pName: doc.data[kProductName],
                pQuantity: doc.data[kProductQuantity],
                pCategory: doc.data[kProductCategory],
              ));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        color: kSecondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Prdouct Name : ${products[index].pName}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Quantity : ${products[index].pQuantity}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Category : ${products[index].pCategory}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: products.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: ()
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Order Is Confirmed"),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Text("Confirm Order"),
                          color: kMainColor,
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: MaterialButton(
                          onPressed: ()
                          {
                            Navigator.pop(context);
                          },
                          child: Text("Delete Order"),
                          color: kMainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          else
          {
            return Center(
              child: Text("Loading Order Details..."),
            );
          }
        },
      ),
    );
  }
}