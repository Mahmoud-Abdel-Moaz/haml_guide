import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:http/http.dart' as http;

import 'api_keys.dart';

class ApiRequests {
  static Future<dynamic> getApiRequests({
    required BuildContext context,
    required String baseUrl,
    required String apiUrl,
    required Map<String, String> headers,
  }) async {
    try {
      if (await CommonComponents.checkConnectivity()) {
        String url = "$baseUrl$apiUrl";
        http.Response response = await http.get(
          Uri.parse(url),
          headers: headers..addAll({"accept-language": "ar"}),
        );

        print('getApiRequests $apiUrl ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          var succeddedDecodedData =
              jsonDecode(utf8.decode(response.bodyBytes));

          // CommonComponents.saveData(
          //  key: ApiKeys.hamlCalc, value: jsonEncode(succeddedDecodedData),);

          return succeddedDecodedData;
        } else {
          debugPrint("GET METHOD status Code => != 200");
          var failedDecodedData = jsonDecode(response.body);
          return failedDecodedData;
        }
      } else {
        if (context.mounted) {
          await CommonComponents.notConnectionAlert(context: context);
        } else {
          return;
        }
      }
    } on TimeoutException catch (error) {
      debugPrint("Time Out Exception is::=>$error");
      await CommonComponents.timeOutExceptionAlert(context);
    } on SocketException catch (error) {
      debugPrint("Socket Exception is::=>$error");
      await CommonComponents.socketExceptionAlert(context);
    } catch (error) {
      debugPrint("General Exception is::=>$error");
    }
  }

  static Future<dynamic> postApiRequests(
      {required BuildContext context,
      required String baseUrl,
      required String apiUrl,
      required Map<String, String> headers,
      required dynamic body}) async {
    try {
      if (await CommonComponents.checkConnectivity()) {
        if (context.mounted) {
          CommonComponents.loading(context);
        } else {
          return;
        }

        String url = "$baseUrl$apiUrl";
        http.Response response = await http.post(
          Uri.parse(url),
          headers: headers..addAll({"accept-language": "ar"}),
          body: body,
        );
        log('postApiRequests $apiUrl $body ${response.statusCode} ${response.body} ${jsonDecode(utf8.decode(response.bodyBytes))}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) {
            Navigator.pop(context);
          } else {
            return;
          }

          var succeddedData = jsonDecode(utf8.decode(response.bodyBytes));
          return succeddedData;
        } else {
          if (context.mounted) {
            Navigator.pop(context);
          } else {
            return;
          }

          debugPrint("POST METHOD=> status Code !=200 or 201");
          var failedDecodedData = jsonDecode(response.body);
          return failedDecodedData;
        }
      } else {
        if (context.mounted) {
          await CommonComponents.notConnectionAlert(context: context);
        } else {
          return;
        }
      }
    } on TimeoutException catch (error) {
      Navigator.pop(context);
      debugPrint("Time Out Exception is::=>$error");
      await CommonComponents.timeOutExceptionAlert(context);
    } on SocketException catch (error) {
      Navigator.pop(context);
      debugPrint("Socket Exception is::=>$error");
      await CommonComponents.socketExceptionAlert(context);
    } catch (error) {
      debugPrint("General Exception is::=>$error");
    }
  }

  static Future<dynamic> putApiRequests({
    required BuildContext context,
    required String baseUrl,
    required String apiUrl,
    required Map<String, String> headers,
    required dynamic body,
  }) async {
    try {
      if (await CommonComponents.checkConnectivity()) {
        if (context.mounted) {
          CommonComponents.loading(context);
        } else {
          return;
        }

        String url = "$baseUrl$apiUrl";
        http.Response response = await http.put(
          Uri.parse(url),
          headers: headers..addAll({"accept-language": "ar"}),
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) {
            Navigator.pop(context);
          } else {
            return;
          }

          var succeddedDecodedData = jsonDecode(response.body);
          return succeddedDecodedData;
        } else {
          debugPrint("PUT METHOD status Code !=200 or 201");
          if (context.mounted) {
            Navigator.pop(context);
          } else {
            return;
          }
          var failedDecodedData = jsonDecode(response.body);
          return failedDecodedData;
        }
      } else {
        if (context.mounted) {
          await CommonComponents.notConnectionAlert(context: context);
        } else {
          return;
        }
      }
    } on SocketException catch (error) {
      Navigator.pop(context);
      await CommonComponents.socketExceptionAlert(context);
      debugPrint("Socket Exception is::=>$error");
    } on TimeoutException catch (error) {
      Navigator.pop(context);
      await CommonComponents.timeOutExceptionAlert(context);
      debugPrint("Time Out Exception is::=>$error");
    } catch (error) {
      Navigator.pop(context);
      debugPrint("General Exception is::=>$error");
    }
  }

  static Future<dynamic> patchApiRequests({
    required BuildContext context,
    required String baseUrl,
    required String apiUrl,
    required Map<String, String> headers,
    required dynamic body,
  }) async {
    try {
      if (await CommonComponents.checkConnectivity()) {
        if (context.mounted) {
          CommonComponents.loading(context);
        } else {
          return;
        }

        String url = "$baseUrl$apiUrl";
        http.Response response = await http.patch(
          Uri.parse(url),
          headers: headers..addAll({"accept-language": "ar"}),
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) {
            Navigator.pop(context);
          } else {
            return;
          }

          var succeddedDecodedData = jsonDecode(response.body);
          return succeddedDecodedData;
        } else {
          debugPrint("PATCH METHOD status Code !=200 or 201");
          if (context.mounted) {
            Navigator.pop(context);
          } else {
            return;
          }
          var failedDecodedData = jsonDecode(response.body);
          return failedDecodedData;
        }
      } else {
        if (context.mounted) {
          await CommonComponents.notConnectionAlert(context: context);
        } else {
          return;
        }
      }
    } on SocketException catch (error) {
      Navigator.pop(context);
      await CommonComponents.socketExceptionAlert(context);
      debugPrint("Socket Exception is::=>$error");
    } on TimeoutException catch (error) {
      Navigator.pop(context);
      await CommonComponents.timeOutExceptionAlert(context);
      debugPrint("Time Out Exception is::=>$error");
    } catch (error) {
      Navigator.pop(context);
      debugPrint("General Exception is::=>$error");
    }
  }

  static Future<dynamic> deleteApiRequests({
    required BuildContext context,
    required String baseUrl,
    required String apiUrl,
    required Map<String, String> headers,
    required dynamic body,
  }) async {
    try {
      if (await CommonComponents.checkConnectivity()) {
        if (context.mounted) {
          CommonComponents.loading(context);
        } else {
          return;
        }

        String url = "$baseUrl$apiUrl";
        http.Response response = await http.delete(
          Uri.parse(url),
          headers: headers..addAll({"accept-language": "ar"}),
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          if (context.mounted) {
            Navigator.pop(context);

            var succeddedDecodedData = jsonDecode(response.body);
            return succeddedDecodedData;
          } else {
            return;
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context);
            debugPrint("DELETE METHOD status Code !=200 or 201");
            var failedDecodedData = jsonDecode(response.body);
            return failedDecodedData;
          } else {
            return;
          }
        }
      } else {
        if (context.mounted) {
          await CommonComponents.notConnectionAlert(context: context);
        } else {
          return;
        }
      }
    } on TimeoutException catch (error) {
      Navigator.pop(context);
      debugPrint("Time Out Exception is::=> $error");
      await CommonComponents.timeOutExceptionAlert(context);
    } on SocketException catch (error) {
      Navigator.pop(context);
      debugPrint("Socket Exception is::=>$error");
      await CommonComponents.socketExceptionAlert(context);
    } catch (error) {
      Navigator.pop(context);
      debugPrint("General Exception is::=>$error");
    }
  }
}
