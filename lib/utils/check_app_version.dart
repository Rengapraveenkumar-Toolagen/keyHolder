import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import '../data/model/app_config.dart';
import '../presentation/widgets/alert/alert_widget.dart';
import '../presentation/widgets/common/launch_url.dart';
import 'logger.dart';

Future<void> checkInstalledAppVersion(context, AppConfig appConfigDetail,
    {String title = 'App Update',
    String message = 'recommends that you update to the latest version.',
    String possitiveBtnText = 'Update'}) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String version = packageInfo.version;

  var installedAppVersionSplitArray = version.split('.');
  var appLatestVersionSplitArray = appConfigDetail.appLatestVersion!.split('.');

  String installedAppVersion = installedAppVersionSplitArray[0] +
      installedAppVersionSplitArray[1] +
      installedAppVersionSplitArray[2];

  String appLatestVersion = appLatestVersionSplitArray[0] +
      appLatestVersionSplitArray[1] +
      appLatestVersionSplitArray[2];

  if (int.parse(installedAppVersion) <
      int.parse(appLatestVersion.replaceAll(RegExp('\\(.*?\\)'), ''))) {
    showAlertWithAction(
        context: context,
        title: title,
        content: '$appName $message',
        onPress: () {
          _openAppStore(
              androidAppStoreUrl: appConfigDetail.androidAppStoreUrl,
              iOSAppStoreUrl: appConfigDetail.androidAppStoreUrl);
        },
        possitiveBtnText: possitiveBtnText,
        visibleNegativeBtn: false);
  }
}

void _openAppStore(
    {String? androidAppStoreUrl = '', String? iOSAppStoreUrl = ''}) {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      launchURL(Platform.isAndroid ? androidAppStoreUrl! : iOSAppStoreUrl!);
    }
  } catch (error) {
    Logger.printLog(error.toString());
  }
}
