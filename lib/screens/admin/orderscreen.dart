import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/screens/admin/orderdetail.dart';
import 'package:e_commerce/services/store.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget
{
  static String id = "OrderScreen";
  final Store _store = Store();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot)
        {
          if(!snapshot.hasData)
          {
            return Center(
              child: Text("No Orders Here Yet..."),
            );
          }
          else
          {
            List<Order> orders = [];
            for (var doc in snapshot.data.documents)
              {
                orders.add(Order(
                  documentId: doc.documentID,
                  Address: kAddress,
                  totalPrice: doc.data[kTotallPrice],
                ));
              }
            return ListView.builder(
              itemBuilder: (context, index) =>
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.pushNamed(context, OrderDetail.id, arguments: orders[index].documentId);
                  },
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
                            "Total Price is \$ ${orders[index].totalPrice}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Address is ${orders[index].Address}",
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
              ),
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }
}