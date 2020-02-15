import 'package:flutter/foundation.dart';
import 'package:screen_demo/models/response_container.dart';
import 'package:screen_demo/models/user_model.dart';
import 'package:screen_demo/network_layer/resource_requester.dart';

class UserDetailModel with ChangeNotifier {
  List<User> _users = [];
  RequestStatus _requestStatus = RequestStatus.idle;

  RequestStatus get requestStatus => _requestStatus;

  Future<RequestOutput> fetchUsers() async {
    _requestStatus = RequestStatus.inProgress;
    setState();
    RequestOutput requestOutput = await Requester().requestMethod();
    if (requestOutput.requestStatus == RequestStatus.succeed) {
      Iterable iterator = requestOutput.data;
      _users = iterator
          .map((userJson) => User.fromJson(userJson))
          .toList(growable: true);
    }
    _requestStatus = requestOutput.requestStatus;
    return requestOutput;
  }

  List<User> getUsers() {
    return _users;
  }

  void setState({RequestStatus requestStatus}) {
    if (requestStatus != null) {
      _requestStatus = requestStatus;
    }
    notifyListeners();
  }

  void deleteAllDetails(List<User> userListToDelete,
      {bool shouldDeleteAll = false}) {
    if (shouldDeleteAll) {
      _users = [];
      setState();
      return;
    }
    userListToDelete.forEach((user) {
      _users.remove(user);
    });
    setState();
  }
}
