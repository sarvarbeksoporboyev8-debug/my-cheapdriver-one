import 'package:flutter/material.dart';

import '../../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../../core/presentation/screens/nested_screen_scaffold.dart';
import '../../../../../core/presentation/styles/styles.dart';
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

    if (isDemoUser) {
      return NestedScreenScaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.paddingH20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_shipping,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: Sizes.marginV20),
                Text(
                  'Demo Mode',
                  style: TextStyles.f24(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Sizes.marginV12),
                Text(
                  'Welcome to the demo version!\nExplore the app features using the navigation below.',
                  textAlign: TextAlign.center,
                  style: TextStyles.f16(context),
                ),
              ],
            ),
          ),
        ),
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
