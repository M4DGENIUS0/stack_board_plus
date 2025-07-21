import 'package:flutter/painting.dart';
import 'package:stack_board_plus/helpers.dart';

extension ExLocale on Locale {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'languageCode': languageCode,
      if (countryCode != null) 'countryCode': countryCode,
    };
  }
}

Locale jsonToLocale(Map<String, dynamic> data) {
  return Locale(
      asT<String>(data['languageCode']), asNullT<String>(data['countryCode']));
}
