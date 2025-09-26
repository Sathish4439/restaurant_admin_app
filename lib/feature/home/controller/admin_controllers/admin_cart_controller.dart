import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/api_service.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/cart_model.dart';

class AdminCartController extends GetxController {
  final api = ApiService();

  var isLoading = false.obs;
  var cartItems = <CartModel>[].obs;
  var totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Fetch cart items for a customer
  Future<void> fetchCartItems(int customerId) async {
    try {
      isLoading.value = true;

      String url = '${EndPoints.getCart}/$customerId';
      print('🚀 Request: GET $url');

      var response = await api.get(url);
      print('✅ Response: ${response.statusCode} $url');
      print('📥 Data: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        var cartResponse = CartResponse.fromJson(response.data);

        if (cartResponse.success) {
          cartItems.value = cartResponse.data;
          _calculateTotal();
          print('✅ Successfully fetched ${cartItems.length} cart items');
        } else {
          print('❌ API Error: ${cartResponse.message}');
          Get.snackbar('Error', cartResponse.message);
        }
      } else {
        print('❌ Invalid response format: ${response.data.runtimeType}');
        Get.snackbar('Error', 'Invalid response format from server');
      }
    } catch (e) {
      print('❌ Error fetching cart: $e');
      Get.snackbar('Error', 'Failed to fetch cart: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Add item to cart
  Future<void> addToCart({
    required int customerId,
    required int menuItemId,
    required int quantity,
    String? notes,
  }) async {
    try {
      isLoading.value = true;

      var data = {
        'customerId': customerId,
        'menuItemId': menuItemId,
        'quantity': quantity,
        if (notes != null) 'notes': notes,
      };

      print('🚀 Request: POST ${EndPoints.createCart}');
      print('📦 Data: $data');

      var response = await api.post(EndPoints.createCart, data: data);
      print('✅ Response: ${response.statusCode}');
      print('📥 Data: ${response.data}');

      if (response.data['success'] == true) {
        Get.snackbar('Success', 'Item added to cart successfully');
        await fetchCartItems(customerId); // Refresh cart
      } else {
        String errorMessage =
            response.data['message'] ?? 'Failed to add item to cart';
        print('❌ API Error: $errorMessage');
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      print('❌ Error adding to cart: $e');
      Get.snackbar('Error', 'Failed to add item to cart: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Update cart item
  Future<void> updateCartItem({
    required int cartItemId,
    required int quantity,
    String? notes,
  }) async {
    try {
      isLoading.value = true;

      var data = {
        'quantity': quantity,
        if (notes != null) 'notes': notes,
      };

      String url = '${EndPoints.updateCart}/$cartItemId';
      print('🚀 Request: PUT $url');
      print('📦 Data: $data');

      var response = await api.put(url, data: data);
      print('✅ Response: ${response.statusCode}');
      print('📥 Data: ${response.data}');

      if (response.data['success'] == true) {
        Get.snackbar('Success', 'Cart item updated successfully');
        // Refresh cart for the customer (you might need to store customerId)
        // await fetchCartItems(customerId);
      } else {
        String errorMessage =
            response.data['message'] ?? 'Failed to update cart item';
        print('❌ API Error: $errorMessage');
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      print('❌ Error updating cart item: $e');
      Get.snackbar('Error', 'Failed to update cart item: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(int cartItemId) async {
    try {
      isLoading.value = true;

      String url = '${EndPoints.deleteCart}/$cartItemId';
      print('🚀 Request: DELETE $url');

      var response = await api.delete(url);
      print('✅ Response: ${response.statusCode}');
      print('📥 Data: ${response.data}');

      if (response.data['success'] == true) {
        Get.snackbar('Success', 'Item removed from cart successfully');
        // Remove item from local list
        cartItems.removeWhere((item) => item.id == cartItemId);
        _calculateTotal();
      } else {
        String errorMessage =
            response.data['message'] ?? 'Failed to remove item from cart';
        print('❌ API Error: $errorMessage');
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      print('❌ Error removing from cart: $e');
      Get.snackbar('Error', 'Failed to remove item from cart: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate total amount
  void _calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.menuItem.price * item.quantity;
    }
    totalAmount.value = total;
    print('💰 Final calculated total: $total');
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0.0;
  }
}
