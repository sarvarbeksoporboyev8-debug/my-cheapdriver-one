import 'package:flutter/material.dart';

import '../../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../../core/presentation/screens/nested_screen_scaffold.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../../core/presentation/widgets/loading_widgets.dart';
import '../../components/retry_again_component.dart';
import '../../components/upcoming_orders_component.dart';
import '../../providers/location_stream_provider.dart';
import '../../providers/update_delivery_geo_point_provider.dart';
import '../../utils/location_error.dart';

class HomeScreenCompact extends HookConsumerWidget {
  const HomeScreenCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isDemoUser = authState.match(
      () => false,
      (user) => user.id == 'demo_user',
    );

    // For demo user, skip location and show orders directly
    if (isDemoUser) {
      return const NestedScreenScaffold(
        body: UpcomingOrdersComponent(),
      );
    }

    final locationAsync = ref.watch(
      locationStreamProvider.select((value) => value.whenData((value) => true)),
    );

    ref.listen(updateDeliveryGeoPointStateProvider, (previous, next) {});

    return NestedScreenScaffold(
      body: locationAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: !locationAsync.hasError,
        loading: () => TitledLoadingIndicator(message: tr(context).determine_location),
        error: (error, st) => RetryAgainComponent(
          description: (error as LocationError).getErrorText(context),
          onPressed: () {
            ref.invalidate(locationStreamProvider);
          },
        ),
        data: (_) => const UpcomingOrdersComponent(),
      ),
    );
  }
}
