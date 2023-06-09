import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';

class Store {
  final Firestore _firestore = Firestore.instance;

  addProduct(Product product) {
    _firestore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
      kProductCategory: product.pCategory,
      kProductPrice: product.pPrice,
    });
  }
  
  Stream<QuerySnapshot> loadProduct() {
    return _firestore.collection(kProductsCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrders()
  {
    return _firestore.collection(kOrders).snapshots();
  }

  Stream<QuerySnapshot> loadOrdersDetails(documentId)
  {
    return _firestore.collection(kOrders).document(documentId).collection(kOrderDetails).snapshots();
  }

  deleteProduct(documentId)
  {
    _firestore.collection(kProductsCollection).document(documentId).delete();
  }

  editProduct(data, documentId)
  {
    _firestore.collection(kProductsCollection).document(documentId).updateData(data);
  }

  storeOrders(data, List<Product> products)
  {
    var docuumentRef = _firestore.collection(kOrders).document();
    docuumentRef.setData(data);
    for (var product in products)
    {
    docuumentRef.collection(kOrderDetails).document().setData(
      {
        kProductName : product.pName,
        kProductPrice : product.pPrice,
        kProductQuantity : product.pQuantity,
        kProductLocation : product.pLocation,
        kProductCategory : product.pCategory,
      }
    );
    }
  }
}
