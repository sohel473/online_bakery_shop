import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pc_build_assistant/models/product.dart';

class DatabaseHelper {
  static Firestore _database = Firestore.instance;

  static getData() async {
    List<Product> products = new List<Product>();
    try {
      List<Map<String, dynamic>> productList;
      QuerySnapshot collection =
          await _database.collection('products').getDocuments();
      List<DocumentSnapshot> documents = collection.documents;
      productList = documents.map((DocumentSnapshot snapshot) {
        return snapshot.data;
      }).toList();
      products.clear();
      for (Map<String, dynamic> item in productList) {
        products.add(Product(
          name: item["name"],
          description: item["description"],
          imgurl: item["imgurl"],
          price: item["price"],
        ));
      }
    } catch (e) {
      print(e.toString());
    }
    return products;
  }
}
