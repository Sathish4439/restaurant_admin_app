import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/api_service.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/order_model.dart';

class AdminOrderController extends GetxController {
  final api = ApiService();

  var isLoading = false.obs;
  var orders = <OrderModel>[].obs;
  var orderStats = OrderStatsModel(
    totalOrders: 0,
    totalRevenue: 0.0,
    pendingOrders: 0,
    preparingOrders: 0,
    servedOrders: 0,
    cancelledOrders: 0,
    ordersByStatus: {},
  ).obs;

  var selectedStatus = 'ALL'.obs;
  var selectedTable = 'ALL'.obs;

  // Status options
  final statusOptions = ['ALL', 'PENDING', 'PREPARING', 'SERVED', 'CANCELLED'];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    fetchOrderStats();
  }

  // Fetch all orders
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;

      String url = EndPoints.getOrder;

      var response = await api.get(url);

      print('API Response: ${response.data}');

      if (response.data['success'] == true) {
        var data = response.data['data'] as List;
        print('Orders data: $data');

        orders.value = data
            .map((e) {
              try {
                return OrderModel.fromJson(e);
              } catch (parseError) {
                print('Error parsing order: $parseError');
                print('Problematic data: $e');
                return null;
              }
            })
            .where((order) => order != null)
            .cast<OrderModel>()
            .toList();

        print('Successfully parsed ${orders.length} orders');
      } else {
        String errorMessage =
            response.data['message'] ?? 'Failed to fetch orders';
        print('API Error: $errorMessage');
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      print('Error fetching orders: $e');
      Get.snackbar('Error', 'Failed to fetch orders: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch order statistics
  Future<void> fetchOrderStats() async {
    try {
      var response = await api.get(EndPoints.getOrderStats);
      print('Order Stats Response: ${response.data}');

      if (response.data['success'] == true) {
        try {
          orderStats.value = OrderStatsModel.fromJson(response.data['data']);
          print('Successfully parsed order statistics');
        } catch (parseError) {
          print('Error parsing order stats: $parseError');
          print('Problematic data: ${response.data['data']}');
          Get.snackbar('Error', 'Failed to parse order statistics');
        }
      } else {
        String errorMessage =
            response.data['message'] ?? 'Failed to fetch order statistics';
        print('API Error: $errorMessage');
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      print('Error fetching order statistics: $e');
      Get.snackbar('Error', 'Failed to fetch order statistics: $e');
    }
  }

  // Update order status
  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      isLoading.value = true;

      var response = await api.put(
        '${EndPoints.updateOrder}/$orderId',
        data: {'status': newStatus},
      );

      if (response.data['success']) {
        Get.snackbar('Success', 'Order status updated successfully');
        await fetchOrders(); // Refresh orders
        await fetchOrderStats(); // Refresh stats
      } else {
        Get.snackbar('Error',
            response.data['message'] ?? 'Failed to update order status');
      }
    } catch (e) {
      print('Error updating order status: $e');
      Get.snackbar('Error', 'Failed to update order status');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter orders by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    fetchOrders();
  }

  // Filter orders by table
  void filterByTable(String table) {
    selectedTable.value = table;
    fetchOrders();
  }

  // Get status color
  String getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return '#FF9800'; // Orange
      case 'PREPARING':
        return '#2196F3'; // Blue
      case 'SERVED':
        return '#4CAF50'; // Green
      case 'CANCELLED':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Get status icon
  String getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return '⏳';
      case 'PREPARING':
        return '👨‍🍳';
      case 'SERVED':
        return '✅';
      case 'CANCELLED':
        return '❌';
      default:
        return '❓';
    }
  }

  // Format currency
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  // Format date
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Refresh data
  Future<void> refreshData() async {
    await Future.wait([
      fetchOrders(),
      fetchOrderStats(),
    ]);
  }
}
