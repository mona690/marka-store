import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macstore/models/product_models.dart';

class ProductSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CartModel>> searchProducts(String searchText) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await _firestore
          .collection('products')
          .orderBy('productName') // Order products by name
          .startAt([searchText]) // Start at the search text
          .endAt([searchText + '\uf8ff']) // End at the search text + '\uf8ff' (a Unicode character that is a very high code point)
          .get();

      return result.docs.map((doc) {
        final data = doc.data();
        return CartModel(
          productName: data['productName'] ?? '',
          productPrice: data['productPrice'] ?? 0.0,
          catgoryName: data['catgoryName'] ?? '',
          imageUrl: (data['imageUrl'] is List)
              ? List.from(data['imageUrl'] as List)
              : [data['imageUrl']?.toString() ?? ''],
          productId: data['productId'] ?? '',
          productSize: data['productSize'] ?? '',
          discountPrice: data['discountPrice'] ?? 0.0,
          description: data['description'] ?? '',
          quantity: data['quantity'] ?? 0,
        );
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      throw Exception('Error searching products: $e');
    }
  }
}
