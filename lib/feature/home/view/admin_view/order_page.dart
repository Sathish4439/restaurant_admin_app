import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_order_controller.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/order_model.dart';
import 'package:restaurent_admin_app/feature/home/view/widget/widgets.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  final controller = Get.put(AdminOrderController());

  @override
  void initState() {
    super.initState();
    controller.fetchOrders();
    controller.fetchOrderStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppbar(title: "Order Management"),
      body: Column(
        children: [
          // Statistics Cards
          _buildStatsCards(),

          // Filter Section
          _buildFilterSection(),

          // Orders List
          Expanded(
            child: _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Obx(() {
      final stats = controller.orderStats.value;
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: "Total Orders",
                value: stats.totalOrders.toString(),
                color: AppColors.primary,
                icon: Icons.receipt_long,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                title: "Revenue",
                value: controller.formatCurrency(stats.totalRevenue),
                color: AppColors.secondary,
                icon: Icons.attach_money,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                title: "Pending",
                value: stats.pendingOrders.toString(),
                color: Colors.orange,
                icon: Icons.pending,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: controller.statusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.filterByStatus(value);
                    }
                  },
                )),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => controller.refreshData(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.orders.isEmpty) {
        return const Center(
          child: Text(
            "No orders found",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.orders.length,
        itemBuilder: (context, index) {
          final order = controller.orders[index];
          return _buildOrderCard(order);
        },
      );
    });
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.id}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(order.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Table and Time
            Row(
              children: [
                Icon(Icons.table_restaurant, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  "Table ${order.table.name}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  controller.formatDate(order.createdAt),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order Items
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item.quantity}x ${item.menuItem.name}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        controller.formatCurrency(
                            item.menuItem.price * item.quantity),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )),

            const Divider(),

            // Total and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${controller.formatCurrency(order.total)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                _buildStatusActions(order),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusActions(OrderModel order) {
    if (order.status == 'SERVED' || order.status == 'CANCELLED') {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (order.status == 'PENDING') ...[
          _buildActionButton(
            'Prepare',
            Colors.blue,
            () => controller.updateOrderStatus(order.id, 'PREPARING'),
          ),
          const SizedBox(width: 8),
        ],
        if (order.status == 'PREPARING') ...[
          _buildActionButton(
            'Serve',
            Colors.green,
            () => controller.updateOrderStatus(order.id, 'SERVED'),
          ),
          const SizedBox(width: 8),
        ],
        _buildActionButton(
          'Cancel',
          Colors.red,
          () => _showCancelDialog(order),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'PREPARING':
        return Colors.blue;
      case 'SERVED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCancelDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Order"),
          content: Text("Are you sure you want to cancel Order #${order.id}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.updateOrderStatus(order.id, 'CANCELLED');
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
