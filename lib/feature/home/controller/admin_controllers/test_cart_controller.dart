import 'package:get/get.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_cart_controller.dart';

class TestCartController extends GetxController {
  final cartController = Get.find<AdminCartController>();

  // Test cart functionality
  Future<void> testCartOperations() async {
    print('🧪 Testing Cart Operations...');

    try {
      // Test 1: Fetch cart items for customer ID 26
      print('\n📋 Test 1: Fetch cart items for customer 26');
      await cartController.fetchCartItems(26);

      // Test 2: Add item to cart
      print('\n📋 Test 2: Add item to cart');
      await cartController.addToCart(
        customerId: 26,
        menuItemId: 1,
        quantity: 2,
        notes: 'Test order',
      );

      // Test 3: Update cart item
      if (cartController.cartItems.isNotEmpty) {
        print('\n📋 Test 3: Update cart item');
        await cartController.updateCartItem(
          cartItemId: cartController.cartItems.first.id,
          quantity: 3,
          notes: 'Updated test order',
        );
      }

      print('\n✅ Cart operations test completed');
    } catch (e) {
      print('\n❌ Cart operations test failed: $e');
    }
  }
}
