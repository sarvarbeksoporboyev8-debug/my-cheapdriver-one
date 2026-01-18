import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool isRTL(BuildContext context) {
  // No RTL languages in current supported locales (en, ru, uz)
  return false;
}

AppLocalizations tr(BuildContext context) {
  return AppLocalizations.of(context)!;
}
