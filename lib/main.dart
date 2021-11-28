// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:scanbot_sdk/common_data.dart';
// import 'package:scanbot_sdk/cropping_screen_data.dart';
// import 'package:scanbot_sdk/document_scan_data.dart';
// import 'package:scanbot_sdk/scanbot_sdk.dart';
// import 'package:scanbot_sdk/scanbot_sdk_models.dart';
// import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() {
//     return _MyHomePageState();
//   }
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   @override
//   void initState() {
//     super.initState();
//     _setSDK();
//   }

//   _setSDK() async {
//     var customStorageBaseDirectory = await getDemoStorageBaseDirectory();

//     final String licenseKey = "pul/h/agx3dFtRcc+B9djsvkoHKZPb" +
//         "GoZe2QEktX9GaLXx94rqWyyTreVzHt" +
//         "POnbwYVmkbtYM+VfTZjcQ/TVtmtRHi" +
//         "lUwPyaRLYcj6byo0dg2W3eDwDpTK5d" +
//         "S4fPzHRNSDdYtEHKtNl0Wq8QSLBcUC" +
//         "CgGFUBiNAbSm46K2cpaziFot8VZfc9" +
//         "XDtUiYtxVu4nrAezDqRwCNw8N1vor5" +
//         "wy361AvBPmAAXv9HvMflsw3U2VRo8i" +
//         "XcDHAe8wKa9l6020zuz1mxghZ4kgjY" +
//         "GD26z00lH6CBCwVed3kLoz5Ck/t2Ah" +
//         "WHszmd15ffEyWHta6/ah3cBC9Ys6Na" +
//         "3xkS0HysMjOw==\nU2NhbmJvdFNESw" +
//         "pjb20uZXhhbXBsZS5zY2FuX2JvdAox" +
//         "NjAwOTkxOTk5CjU5MAoz\n";

//     var config = ScanbotSdkConfig(
//         licenseKey: licenseKey,
//         imageFormat: ImageFormat.JPG,
//         imageQuality: 80,
//         storageBaseDirectory: customStorageBaseDirectory,
//         loggingEnabled: true);

//     try {
//       await ScanbotSdk.initScanbotSdk(config);
//     } catch (e) {
//       print(e);
//     }
//   }

//   void _incrementCounter() async {
//     startDocumentScanning();
//   }

//   startDocumentScanning() async {
//     DocumentScanningResult result;
//     try {
//       var config = DocumentScannerConfiguration(
//         bottomBarBackgroundColor: Colors.blue,
//         ignoreBadAspectRatio: true,
//         multiPageEnabled: false,
//         multiPageButtonHidden: true,
//         //maxNumberOfPages: 3,
//         //flashEnabled: true,
//         //autoSnappingSensitivity: 0.7,
//         cameraPreviewMode: CameraPreviewMode.FIT_IN,
//         orientationLockMode: CameraOrientationMode.PORTRAIT,
//         //documentImageSizeLimit: Size(2000, 3000),
//         cancelButtonTitle: "Cancel",
//         pageCounterButtonTitle: "%d Page(s)",
//         textHintOK: "Perfect, don't move...",
//         //textHintNothingDetected: "Nothing",
//       );
//       result = await ScanbotSdkUi.startDocumentScanner(config);
//        if (isOperationSuccessful(result)) {
//       _pageRepository.addPages(result.pages);
//       gotoImagesView();
//     }
//     } catch (e) {
//       print(e);
//     }
//   }

//    gotoImagesView() async {
//     imageCache.clear();
//     return await Navigator.of(context).push(
//       MaterialPageRoute(builder: (context) => DocumentPreview(_pageRepository)),
//     );
//   }

//   Future<String> getDemoStorageBaseDirectory() async {
//     Directory storageDirectory;
//     if (Platform.isAndroid) {
//       storageDirectory = await getExternalStorageDirectory();
//     } else if (Platform.isIOS) {
//       storageDirectory = await getApplicationDocumentsDirectory();
//     } else {
//       throw ("Unsupported platform");
//     }

//     return "${storageDirectory.path}/my-custom-storage";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:scan_bot/ui/preview_document_widget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_models.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'pages_repository.dart';
import 'ui/menu_items.dart';
import 'ui/utils.dart';

void main() => runApp(MyApp());

// Please note: The Scanbot SDK will run without a license key for one minute per session!
// After the trial period is over all Scanbot SDK functions as well as the UI components will stop working
// or may be terminated. You can get an unrestricted "no-strings-attached" 30 day trial license key for free.
// Please submit the trial license form (https://scanbot.io/sdk/trial.html) on our website by using
// the app identifier "io.scanbot.example.sdk.flutter" of this example app or of your app.
const SCANBOT_SDK_LICENSE_KEY = "";

initScanbotSdk() async {
  // Consider adjusting this optional storageBaseDirectory - see the comments below.
  var customStorageBaseDirectory = await getDemoStorageBaseDirectory();

  final String licenseKey = "pul/h/agx3dFtRcc+B9djsvkoHKZPb" +
      "GoZe2QEktX9GaLXx94rqWyyTreVzHt" +
      "POnbwYVmkbtYM+VfTZjcQ/TVtmtRHi" +
      "lUwPyaRLYcj6byo0dg2W3eDwDpTK5d" +
      "S4fPzHRNSDdYtEHKtNl0Wq8QSLBcUC" +
      "CgGFUBiNAbSm46K2cpaziFot8VZfc9" +
      "XDtUiYtxVu4nrAezDqRwCNw8N1vor5" +
      "wy361AvBPmAAXv9HvMflsw3U2VRo8i" +
      "XcDHAe8wKa9l6020zuz1mxghZ4kgjY" +
      "GD26z00lH6CBCwVed3kLoz5Ck/t2Ah" +
      "WHszmd15ffEyWHta6/ah3cBC9Ys6Na" +
      "3xkS0HysMjOw==\nU2NhbmJvdFNESw" +
      "pjb20uZXhhbXBsZS5zY2FuX2JvdAox" +
      "NjAwOTkxOTk5CjU5MAoz\n";

  var config = ScanbotSdkConfig(
    loggingEnabled:
        true, // Consider switching logging OFF in production builds for security and performance reasons.
    licenseKey: licenseKey,
    imageFormat: ImageFormat.JPG,
    imageQuality: 80,
    storageBaseDirectory: customStorageBaseDirectory,
  );

  try {
    await ScanbotSdk.initScanbotSdk(config);
  } catch (e) {
    print(e);
  }
}

Future<String> getDemoStorageBaseDirectory() async {
  // !! Please note !!
  // It is strongly recommended to use the default (secure) storage location of the Scanbot SDK.
  // However, for demo purposes we overwrite the "storageBaseDirectory" of the Scanbot SDK by a custom storage directory.
  //
  // On Android we use the "ExternalStorageDirectory" which is a public(!) folder.
  // All image files and export files (PDF, TIFF, etc) created by the Scanbot SDK in this demo app will be stored
  // in this public storage directory and will be accessible for every(!) app having external storage permissions!
  // Again, this is only for demo purposes, which allows us to easily fetch and check the generated files
  // via Android "adb" CLI tools, Android File Transfer app, Android Studio, etc.
  //
  // On iOS we use the "ApplicationDocumentsDirectory" which is accessible via iTunes file sharing.
  //
  // For more details about the storage system of the Scanbot SDK Flutter Plugin please see our docs:
  // - https://scanbotsdk.github.io/documentation/flutter/
  //
  // For more details about the file system on Android and iOS we also recommend to check out:
  // - https://developer.android.com/guide/topics/data/data-storage
  // - https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

  Directory storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  } else {
    throw ("Unsupported platform");
  }

  return "${storageDirectory.path}/my-custom-storage";
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    initScanbotSdk();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPageWidget());
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  PageRepository _pageRepository = PageRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Scanbot SDK Example Flutter',
            style: TextStyle(inherit: true, color: Colors.black)),
      ),
      body: ListView(
        children: <Widget>[
          TitleItemWidget("Document Scanner"),
          MenuItemWidget(
            "Scan Document",
            onTap: () {
              startDocumentScanning();
            },
          ),
          // MenuItemWidget(
          //   "Import Image",
          //   onTap: () {
          //     importImage();
          //   },
          // ),
          // MenuItemWidget(
          //   "View Image Results",
          //   endIcon: Icons.keyboard_arrow_right,
          //   onTap: () {
          //     gotoImagesView();
          //   },
          // ),
          // TitleItemWidget("Data Detectors"),
          // MenuItemWidget(
          //   "Scan Barcode (all formats: 1D + 2D)",
          //   onTap: () {
          //     startBarcodeScanner();
          //   },
          // ),
          // MenuItemWidget(
          //   "Scan QR code (QR format only)",
          //   onTap: () {
          //     startQRScanner();
          //   },
          // ),
          // MenuItemWidget(
          //   "Scan MRZ (Machine Readable Zone)",
          //   onTap: () {
          //     startMRZScanner();
          //   },
          // ),
          // MenuItemWidget(
          //   "Scan EHIC (European Health Insurance Card)",
          //   onTap: () {
          //     startEhicScanner();
          //   },
          // ),
          // TitleItemWidget("Test other SDK API methods"),
          // MenuItemWidget(
          //   "getLicenseStatus()",
          //   startIcon: Icons.phonelink_lock,
          //   onTap: () {
          //     getLicenseStatus();
          //   },
          // ),
          // MenuItemWidget(
          //   "getOcrConfigs()",
          //   startIcon: Icons.settings,
          //   onTap: () {
          //     getOcrConfigs();
          //   },
          // ),
        ],
      ),
    );
  }

  startDocumentScanning() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    DocumentScanningResult result;
    try {
      var config = DocumentScannerConfiguration(
        bottomBarBackgroundColor: Colors.blue,
        ignoreBadAspectRatio: true,
        multiPageEnabled: false,
        multiPageButtonHidden: true,
        //maxNumberOfPages: 3,
        //flashEnabled: true,
        //autoSnappingSensitivity: 0.7,
        cameraPreviewMode: CameraPreviewMode.FIT_IN,
        orientationLockMode: CameraOrientationMode.PORTRAIT,
        //documentImageSizeLimit: Size(2000, 3000),
        cancelButtonTitle: "Cancel",
        pageCounterButtonTitle: "%d Page(s)",
        textHintOK: "Perfect, don't move...",
        //textHintNothingDetected: "Nothing",
        // ...
      );
      result = await ScanbotSdkUi.startDocumentScanner(config);
    } catch (e) {
      print(e);
    }

    if (isOperationSuccessful(result)) {
      //_pageRepository.addPages(result.pages);
      //gotoImagesView();

      imageCache.clear();

      var response = await createLoadImageRequest(
          path: result.pages[0].documentPreviewImageFileUri.toFilePath());

      var jsonResponse = response.data;
      var message = jsonResponse['message'];
      var status = jsonResponse['status'];

      if (response.statusCode == 200) {
        if (status == 1) {
          print(message);

          return await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => DocumentPreview(_pageRepository)),
          );
        } else {
          print(message);
        }
      } else {
        print(response.statusCode);
      }
    }
  }

  gotoImagesView() async {}

  ////////////////// Create Load Image /////////////////////////
  Future<Response> createLoadImageRequest({
    String path,
  }) async {
    Response response;
    try {
      FormData formData = FormData.fromMap({
        "user_id": "46",
        "load_id": "12",
        "load_image_name": "Test",
        "load_image": await MultipartFile.fromFile(path),
      });
      response = await Dio()
          .post("create_load_image",
              data: formData,
              options: Options(
                headers: {
                  'Accept': 'application/json',
                  'Authentication':
                      "afb07f25c69b648ba737cae30fba707735a8d56a603840b39bf30ab05ce183730c8c62458a22d97c386d7c6369ecf2270f3c7fccbc816189d459ec96444a9fd5",
                },
                sendTimeout: 90,
              ));
      print(response.toString());
    } on TimeoutException catch (e) {
      //showToast(message: e.message);
      print("Create Load Image TimeOut: " + e.message);
    } on DioError catch (e) {
      //showToast(message: e.message);
      print("Create Load Image Dio: " + e.message);
    }
    return response;
  }

  // getOcrConfigs() async {
  //   try {
  //     var result = await ScanbotSdk.getOcrConfigs();
  //     showAlertDialog(context, jsonEncode(result), title: "OCR Configs");
  //   } catch (e) {
  //     print(e);
  //     showAlertDialog(context, "Error getting license status");
  //   }
  // }

  // getLicenseStatus() async {
  //   try {
  //     var result = await ScanbotSdk.getLicenseStatus();
  //     showAlertDialog(context, jsonEncode(result), title: "License Status");
  //   } catch (e) {
  //     print(e);
  //     showAlertDialog(context, "Error getting OCR configs");
  //   }
  // }

  // importImage() async {
  //   try {
  //     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //     await createPage(image.uri);
  //     gotoImagesView();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // createPage(Uri uri) async {
  //   if (!await checkLicenseStatus(context)) {
  //     return;
  //   }

  //   var dialog = ProgressDialog(context,
  //       type: ProgressDialogType.Normal, isDismissible: false);
  //   dialog.style(message: "Processing");
  //   dialog.show();
  //   try {
  //     var page = await ScanbotSdk.createPage(uri, false);
  //     page = await ScanbotSdk.detectDocument(page);
  //     this._pageRepository.addPage(page);
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     dialog.hide();
  //   }
  // }

  // startBarcodeScanner() async {
  //   if (!await checkLicenseStatus(context)) {
  //     return;
  //   }

  //   try {
  //     var config = BarcodeScannerConfiguration(
  //       topBarBackgroundColor: Colors.blue,
  //       finderTextHint:
  //           "Please align any supported barcode in the frame to scan it.",
  //       // ...
  //     );
  //     var result = await ScanbotSdkUi.startBarcodeScanner(config);
  //     _showBarcodeScanningResult(result);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // startQRScanner() async {
  //   if (!await checkLicenseStatus(context)) {
  //     return;
  //   }

  //   try {
  //     var config = BarcodeScannerConfiguration(
  //       barcodeFormats: [BarcodeFormat.QR_CODE],
  //       finderTextHint: "Please align a QR code in the frame to scan it.",
  //       // ...
  //     );
  //     var result = await ScanbotSdkUi.startBarcodeScanner(config);
  //     _showBarcodeScanningResult(result);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // _showBarcodeScanningResult(final BarcodeScanningResult result) {
  //   if (isOperationSuccessful(result)) {
  //     showAlertDialog(
  //         context,
  //         "Format: " +
  //             result.barcodeFormat.toString() +
  //             "\nValue: " +
  //             result.text,
  //         title: "Barcode Result:");
  //   }
  // }

  // startEhicScanner() async {
  //   if (!await checkLicenseStatus(context)) {
  //     return;
  //   }

  //   HealthInsuranceCardRecognitionResult result;
  //   try {
  //     var config = HealthInsuranceScannerConfiguration(
  //       topBarBackgroundColor: Colors.blue,
  //       topBarButtonsColor: Colors.white70,
  //       // ...
  //     );
  //     result = await ScanbotSdkUi.startEhicScanner(config);
  //   } catch (e) {
  //     print(e);
  //   }

  //   if (isOperationSuccessful(result) && result?.fields != null) {
  //     var concatenate = StringBuffer();
  //     result.fields
  //         .map((field) =>
  //             "${field.type.toString().replaceAll("HealthInsuranceCardFieldType.", "")}:${field.value}\n")
  //         .forEach((s) {
  //       concatenate.write(s);
  //     });
  //     showAlertDialog(context, concatenate.toString());
  //   }
  // }

  // startMRZScanner() async {
  //   if (!await checkLicenseStatus(context)) {
  //     return;
  //   }

  //   MrzScanningResult result;
  //   try {
  //     var config = MrzScannerConfiguration(
  //       topBarBackgroundColor: Colors.blue,
  //       // ...
  //     );
  //     result = await ScanbotSdkUi.startMrzScanner(config);
  //   } catch (e) {
  //     print(e);
  //   }

  //   if (isOperationSuccessful(result)) {
  //     var concatenate = StringBuffer();
  //     result.fields
  //         .map((field) =>
  //             "${field.name.toString().replaceAll("MRZFieldName.", "")}:${field.value}\n")
  //         .forEach((s) {
  //       concatenate.write(s);
  //     });
  //     showAlertDialog(context, concatenate.toString());
  //   }
  // }

}
