import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/functions.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/loginscreen.dart';
import 'package:e_commerce/screens/user/cartscreen.dart';
import 'package:e_commerce/screens/user/productinfo.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/widgets/productview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String id = "HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  final _auth = Auth();
  FirebaseUser _loggedUser;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  List<Product> _products;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: kAnActiveColor,
              currentIndex: _bottomBarIndex,
              fixedColor: kMainColor,
              onTap: (value) async
              {
                if(value == 1)
                {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.clear();
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                }
                setState(() {
                  _bottomBarIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                    icon: Icon(
                        Icons.home,
                    ),
                ),
                BottomNavigationBarItem(
                  label: "Sign Out",
                    icon: Icon(
                        Icons.close,
                    ),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value)
                {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: [
                  Text(
                    "Jackets",
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : kAnActiveColor,
                      fontSize: _tabBarIndex == 0 ? 13 : 8,
                    ),
                  ),
                  Text(
                    "Trousers",
                    style: TextStyle(
                      color: _tabBarIndex == 1 ? Colors.black : kAnActiveColor,
                      fontSize: _tabBarIndex == 1 ? 13 : 8,
                    ),
                  ),
                  Text(
                    "T-Shirts",
                    style: TextStyle(
                      color: _tabBarIndex == 2 ? Colors.black : kAnActiveColor,
                      fontSize: _tabBarIndex == 2 ? 13 : 8,
                    ),
                  ),
                  Text(
                    "Shoes",
                    style: TextStyle(
                      color: _tabBarIndex == 3 ? Colors.black : kAnActiveColor,
                      fontSize: _tabBarIndex == 3 ? 13 : 8,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                JacketView(),
                ProductsView(kTrousers, _products),
                ProductsView(kTshirts, _products),
                ProductsView(kShoes, _products),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
            child: Container(
              height: MediaQuery.of(context).size.height* .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Descover".toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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
        ),
      ],
    );
  }

  @override
  void initState() {
    getCurrenUser();
  }

  getCurrenUser() async {
    _loggedUser = await _auth.getUser();
  }

  Widget JacketView()
  {
    return StreamBuilder<QuerySnapshot>(
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
          _products = [...products];
          products.clear();
          products = getProductByCategory(kJackets, _products);
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
                        opacity: 0.6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0,),
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
    );
  }

}