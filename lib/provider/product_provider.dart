import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macstore/models/product_models.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProductToCart({
  required String productName,
  required num productPrice,
  required String categoryName, // Fix the parameter name here
  required List imageUrl,
  required int quantity,
  required String productId,
  required String productSize,
  required num discount,
  required String description,
  // required String storeId,
}) {
  if (state.containsKey(productId)) {
    final existingItem = state[productId]!;
    state = {
      ...state,
      productId: CartModel(
        productId: existingItem.productId,
        productName: existingItem.productName,
        productPrice: existingItem.productPrice,
        catgoryName: existingItem.catgoryName,
        quantity: existingItem.quantity + 1,
        imageUrl: existingItem.imageUrl,
        productSize: existingItem.productSize,
        discountPrice: existingItem.discountPrice,
        description: existingItem.description,
        //storeId: existingItem.storeId,
      ),
    };
  } else {
    state = {
      ...state,
      productId: CartModel(
        productName: productName,
        productPrice: productPrice,
        catgoryName: categoryName, // Update the parameter name here
        imageUrl: imageUrl,
        quantity: quantity,
        productId: productId,
        productSize: productSize,
        discountPrice: discount,
        description: description,
        // storeId: storeId,
      ),
    };
  }
}


  void decrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      ///notify listeners that the state has changed
      ///
      state = {...state};
    }
  }

  void removeItem(String productId) {
    state.remove(productId);

    state = {...state};
  }

  void incrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      ///notify listeners that the state has changed
      ///
      state = {...state};
    }
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.discountPrice;
    });

    return totalAmount;
  }

  Map<String, CartModel> get getCartItems => state;
}