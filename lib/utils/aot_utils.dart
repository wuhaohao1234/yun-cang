import 'package:ota_update/ota_update.dart';

class OTAUtils {
  static startOTA(String url, void onData(OtaEvent event)) async {
    try {
      OtaUpdate()
          .execute(
        url,
        destinationFilename: "云仓.apk",
      )
          .listen(
            (OtaEvent event) {
          onData(event);
        },
      );
    } catch (e) {
      onData(OtaEvent()..status = OtaStatus.DOWNLOAD_ERROR
        ..value = "0");
    }
  }


}