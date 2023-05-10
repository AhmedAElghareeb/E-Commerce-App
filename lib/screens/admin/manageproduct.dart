import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/admin/editproduct.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/widgets/custommenu.dart';
import 'package:flutter/material.dart';

class ManageProduct extends StatefulWidget
{
  static String id = "ManageScreen";

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProduct(),
        builder: (context, snapshot)
        {
          if (snapshot.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data.documents) {
              var data = doc.data;
              products.add(Product(
                pId: doc.documentID,
                pPrice: data[kProductPrice],
                pName: data[kProductName],
                pDescription: data[kProductDescription],
                pLocation: data[kProductLocation],
                pCategory: data[kProductCategory],));
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: GestureDetector(
                  onTapUp: (details)
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
                              Navigator.pushNamed(context, EditProduct.id, arguments: products[index]);
                            },
                            child: Text("Edit"),
                          ),
                          MyPopupMenuItem(
                            onClick: ()
                            {
                              _store.deleteProduct(products[index].pId);
                              Navigator.pop(context);
                            },
                            child: Text("Delete"),
                          ),
                        ],
                    );
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
          else {
            return Center(child: Text("Loading...", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),));
          }
        },
      ),
    );
  }
}

