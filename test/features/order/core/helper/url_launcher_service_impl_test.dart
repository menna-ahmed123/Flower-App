import 'package:flower_app/features/order/core/helper/url_launcher_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Stands in for the platform plugin, recording the URLs it was asked about.
class _RecordingUrlLauncher extends UrlLauncherPlatform {
  _RecordingUrlLauncher({
    this.canLaunchResult = true,
    this.launchResult = true,
  });

  final bool canLaunchResult;
  final bool launchResult;

  final List<String> checked = [];
  final List<String> launched = [];
  PreferredLaunchMode? lastMode;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async {
    checked.add(url);
    return canLaunchResult;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    lastMode = options.mode;
    return launchResult;
  }
}

void main() {
  late _RecordingUrlLauncher platform;
  setUp(() {
    platform = _RecordingUrlLauncher();
    UrlLauncherPlatform.instance = platform;
  });

  group('launchPhone', () {
    test(
      'asks the platform to open a tel: URI with the given number',
      () async {
        final launched = await const UrlLauncherServiceImpl().launchPhone(
          '+20 101-234-5678',
        );

        expect(launched, isTrue);
        expect(
          Uri.parse(platform.launched.single),
          Uri(scheme: 'tel', path: '+20 101-234-5678'),
        );
      },
    );

    test('launches nothing when the number cannot be handled', () async {
      platform = _RecordingUrlLauncher(canLaunchResult: false);
      UrlLauncherPlatform.instance = platform;

      final launched = await const UrlLauncherServiceImpl().launchPhone('1234');

      expect(launched, isFalse);
      expect(platform.launched, isEmpty);
    });
  });

  group('launchWhatsApp', () {
    test('builds a wa.me link from the digits of the number', () async {
      await const UrlLauncherServiceImpl().launchWhatsApp('+20 101-234-5678');

      expect(platform.launched, ['https://wa.me/201012345678']);
    });

    test('keeps separators out of the link', () async {
      await const UrlLauncherServiceImpl().launchWhatsApp('(010) 1234 5678');

      expect(platform.launched, ['https://wa.me/201012345678']);
    });

    test('turns a local number into the international wa.me form', () async {
      await const UrlLauncherServiceImpl().launchWhatsApp('01067066051');

      expect(platform.launched, ['https://wa.me/201067066051']);
    });

    test('opens outside the app so WhatsApp itself handles the chat', () async {
      await const UrlLauncherServiceImpl().launchWhatsApp('01012345678');

      expect(platform.lastMode, PreferredLaunchMode.externalApplication);
    });

    test('reports the platform result back to the caller', () async {
      platform = _RecordingUrlLauncher(launchResult: false);
      UrlLauncherPlatform.instance = platform;

      final launched = await const UrlLauncherServiceImpl().launchWhatsApp(
        '01012345678',
      );

      expect(launched, isFalse);
    });
  });
}
