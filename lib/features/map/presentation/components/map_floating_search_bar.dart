import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/hooks/floating_search_bar_controller_hook.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/fp_framework.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../providers/place_autocomplete_provider.dart';
import 'map_search_menu_component.dart';

class MapFloatingSearchBar extends HookConsumerWidget {
  const MapFloatingSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchBarController = useFloatingSearchBarController();
    final isOpen = useState(false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Sizes.marginH16, 44, Sizes.marginH16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(Sizes.mapSearchBarRadius),
            child: TextField(
              controller: searchBarController.textController,
              style: TextStyles.f16(context).copyWith(
                color: Theme.of(context).textTheme.titleMedium!.color,
              ),
              decoration: InputDecoration(
                hintText: tr(context).searchForAPlace,
                hintStyle: TextStyles.f16(context).copyWith(
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
                suffixIcon: searchBarController.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchBarController.clear();
                          ref
                              .read(placeAutocompleteQueryProvider.notifier)
                              .update((_) => const None());
                          isOpen.value = false;
                        },
                      )
                    : Icon(
                        Icons.place,
                        color: Theme.of(context).textTheme.titleMedium!.color,
                      ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Sizes.mapSearchBarRadius),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.paddingH16,
                  vertical: Sizes.paddingV14,
                ),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  ref
                      .read(placeAutocompleteQueryProvider.notifier)
                      .update((_) => Some(query));
                  isOpen.value = true;
                } else {
                  ref
                      .read(placeAutocompleteQueryProvider.notifier)
                      .update((_) => const None());
                  isOpen.value = false;
                }
              },
              onTap: () => isOpen.value = true,
            ),
          ),
          if (isOpen.value)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                child: MapSearchMenuComponent(
                  searchBarController: searchBarController,
                  onClose: () => isOpen.value = false,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
