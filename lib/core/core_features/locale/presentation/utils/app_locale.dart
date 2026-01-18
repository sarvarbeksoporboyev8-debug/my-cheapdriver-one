import 'package:flutter/material.dart';

import '../../../../../gen/my_assets.dart';
import '../../../../presentation/helpers/localization_helper.dart';
import '../../../../presentation/styles/styles.dart';

enum AppLocale {
  english('en', MyAssets.ASSETS_ICONS_LANGUAGES_ICONS_ENGLISH_PNG, FontStyles.familyPoppins),
  russian('ru', MyAssets.ASSETS_ICONS_LANGUAGES_ICONS_ENGLISH_PNG, FontStyles.familyPoppins),
  uzbek('uz', MyAssets.ASSETS_ICONS_LANGUAGES_ICONS_ENGLISH_PNG, FontStyles.familyPoppins);

  const AppLocale(this.code, this.flag, this.fontFamily);

  final String code;
  final String flag;
  final String fontFamily;

  String getLanguageName(BuildContext context) {
    return switch (this) {
      AppLocale.english => tr(context).english,
      AppLocale.russian => tr(context).russian,
      AppLocale.uzbek => tr(context).uzbek,
    };
  }
}
