import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../domain/value_objects.dart';
import '../../infrastructure/repos/orders_repo.dart';

part 'upcoming_orders_provider.g.dart';

@riverpod
Stream<List<AppOrder>> upcomingOrders(UpcomingOrdersRef ref) {
  final user = ref.watch(currentUserProvider);
  
  // For demo user, return mock orders
  if (user.id == 'demo_user') {
    return Stream.value(_getMockOrders());
  }
  
  final ordersStream = ref.watch(ordersRepoProvider).getUpcomingOrders(user.id);
  return ordersStream.distinct((previous, next) {
    return previous.lock == next.lock;
  });
}

List<AppOrder> _getMockOrders() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return [
    AppOrder(
      id: 'demo_order_1',
      date: now - 3600000, // 1 hour ago
      pickupOption: PickupOption.delivery,
      paymentMethod: 'Cash',
      deliveryStatus: DeliveryStatus.upcoming,
      deliveryId: null,
      deliveryGeoPoint: null,
      address: Address(
        state: 'California',
        city: 'San Francisco',
        street: '123 Market Street',
        mobile: '+15551234567',
        geoPoint: const GeoPoint(37.7749, -122.4194),
      ),
      userId: 'user_1',
      userName: 'John Smith',
      userPhone: '5551234567',
      userImage: '',
      userNote: 'Please ring the doorbell',
      employeeCancelNote: null,
    ),
    AppOrder(
      id: 'demo_order_2',
      date: now - 1800000, // 30 min ago
      pickupOption: PickupOption.delivery,
      paymentMethod: 'Card',
      deliveryStatus: DeliveryStatus.upcoming,
      deliveryId: null,
      deliveryGeoPoint: null,
      address: Address(
        state: 'California',
        city: 'San Francisco',
        street: '456 Mission Street',
        mobile: '+15559876543',
        geoPoint: const GeoPoint(37.7879, -122.4074),
      ),
      userId: 'user_2',
      userName: 'Jane Doe',
      userPhone: '5559876543',
      userImage: '',
      userNote: '',
      employeeCancelNote: null,
    ),
    AppOrder(
      id: 'demo_order_3',
      date: now - 900000, // 15 min ago
      pickupOption: PickupOption.delivery,
      paymentMethod: 'Cash',
      deliveryStatus: DeliveryStatus.onTheWay,
      deliveryId: 'demo_user',
      deliveryGeoPoint: const GeoPoint(37.7749, -122.4194),
      address: Address(
        state: 'California',
        city: 'San Francisco',
        street: '789 Howard Street',
        mobile: '+15554567890',
        geoPoint: const GeoPoint(37.7847, -122.4015),
      ),
      userId: 'user_3',
      userName: 'Bob Wilson',
      userPhone: '5554567890',
      userImage: '',
      userNote: 'Leave at the front desk',
      employeeCancelNote: null,
    ),
  ];
}
