import 'package:flower_app/features/order/core/helper/url_launcher_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UrlLauncherService.cleanPhoneNumber', () {
    test('keeps digits only', () {
      expect(UrlLauncherService.cleanPhoneNumber('01012345678'), '01012345678');
    });

    test('strips the leading + and separators', () {
      expect(UrlLauncherService.cleanPhoneNumber('+20 101-234-5678'), '201012345678');
    });

    test('strips parentheses and spaces', () {
      expect(UrlLauncherService.cleanPhoneNumber('(010) 1234 5678'), '01012345678');
    });

    test('empty when nothing but symbols', () {
      expect(UrlLauncherService.cleanPhoneNumber('---'), '');
    });
  });

  group('UrlLauncherService URI builders', () {
    test('phoneUri uses the tel scheme with the raw number', () {
      final uri = UrlLauncherService.phoneUri('+20 101 234 5678');
      expect(uri.scheme, 'tel');
      // Uri keeps the number as the path, percent-encoding the spaces.
      expect(uri.path, '+20%20101%20234%205678');
      expect(uri.toString(), 'tel:+20%20101%20234%205678');
    });

    test('whatsappUri builds a wa.me link from the cleaned digits', () {
      final uri = UrlLauncherService.whatsappUri('+20 101-234-5678');
      expect(uri.toString(), 'https://wa.me/201012345678');
    });
  });
}
