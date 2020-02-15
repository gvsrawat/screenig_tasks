import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:screen_demo/models/response_container.dart';

///Creating a Single file using http client as of now as we have only one api of type GET.
class Requester {
  static Requester _instance;
  HttpClient _httpClient;
  static const _USER_DETAILS_URL = "https://jsonplaceholder.typicode.com/users";
  static const int SUCCESS_CODE = 200;

  Requester._init() {
    _httpClient = HttpClient();
    _httpClient.connectionTimeout = Duration(seconds: 8);
  }

  factory Requester() {
    if (_instance == null) {
      _instance = Requester._init();
    }
    return _instance;
  }

  Future<RequestOutput> requestMethod() async {
    RequestOutput _requestOutput;
    try {
      HttpClientRequest clientRequest =
          await _httpClient.getUrl(Uri.parse(_USER_DETAILS_URL));
      HttpClientResponse response = await clientRequest.close();

      ///Handling only happy case
      if (response.statusCode == SUCCESS_CODE) {
        var completer = Completer<RequestOutput>();
        var stringBuffer = StringBuffer();
        response.transform(utf8.decoder).listen((data) {
          stringBuffer.write(data);
        }).onDone(() {
          _requestOutput = RequestOutput(
              requestStatus: RequestStatus.succeed,
              data: json.decode(stringBuffer.toString()),
              statusCode: SUCCESS_CODE);
          completer.complete(_requestOutput);
        });
        return completer.future;
      } else {
        _requestOutput = RequestOutput(
            requestStatus: RequestStatus.failed,
            statusCode: response.statusCode,
            failureCause: "Request failed due to :- ${response.statusCode}");
      }
    } catch (exception, stackTrace) {
//      print("error origin $stackTrace");
      _requestOutput = RequestOutput(
          requestStatus: RequestStatus.failed,
          statusCode: RequestStatus.failed.index,
          failureCause: exception.toString());
    }
    return _requestOutput;
  }
}
