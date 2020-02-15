import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_demo/models/response_container.dart';
import 'package:screen_demo/models/user_details_model.dart';
import 'package:screen_demo/models/user_model.dart';
import 'package:screen_demo/shared_custom_widgets/shared_custom_widgets.dart';

class UserDetailScreen extends StatefulWidget {
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool _isDeleteEnabled;
  String _selectUnSelectText;
  final String _selectAll = "Select All", _unSelectAll = "Unselect All";
  List<User> _userListToDelete;

  @override
  void initState() {
    _selectUnSelectText = _selectAll;
    _isDeleteEnabled = false;
    _userListToDelete = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var _sWidth = size.width / 100;
    final userDetailObject = Provider.of<UserDetailModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        actions: <Widget>[
          _isDeleteEnabled
              ? Container(
                  child: SharedWidgets().button(
                      () => _selectUnSelectOperation(userDetailObject),
                      _selectUnSelectText,
                      _sWidth * 40,
                      _sWidth),
                )
              : Container()
        ],
        centerTitle: false,
      ),
      body: Builder(builder: (context) {
        List<User> _users = userDetailObject.getUsers();
        return Stack(
          children: <Widget>[
            _users.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, itemIndex) {
                      return ListTile(
                        selected: _userListToDelete.contains(_users[itemIndex]),
                        onTap: () {
                          if (_isDeleteEnabled) {
                            if (_userListToDelete.contains(_users[itemIndex])) {
                              _userListToDelete.remove(_users[itemIndex]);
                            } else {
                              var user = User(email: _users[itemIndex].email);
                              _userListToDelete.add(user);
                            }
                          }
                          if (_userListToDelete.isEmpty) {
                            _isDeleteEnabled = false;
                          }
                          if (_userListToDelete.length == _users.length) {
                            _selectUnSelectText = _unSelectAll;
                          } else {
                            _selectUnSelectText = _selectAll;
                          }
                          userDetailObject.setState();
                        },
                        onLongPress: () {
                          if (!_isDeleteEnabled) {
                            _isDeleteEnabled = true;
                            var user = User(email: _users[itemIndex].email);
                            _userListToDelete.add(user);
                            userDetailObject.setState();
                          }
                        },
                        title: Text("Name : " + _users[itemIndex].name ??
                            "User $itemIndex"),
                        subtitle: Text("Email-Id : " +
                                _users[itemIndex].email?.toString() ??
                            "$itemIndex"),
                      );
                    },
                    itemCount: _users.length,
                  )
                : Container(
                    child: Center(
                      child: Text("Details Not Available"),
                    ),
                  ),
            _isDeleteEnabled
                ? Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: _sWidth * 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SharedWidgets().button(
                              () => _cancelDeletion(userDetailObject),
                              "Cancel",
                              _sWidth * 40,
                              _sWidth,
                              buttonColor: Colors.grey),
                          SharedWidgets().button(() {
                            _isDeleteEnabled = false;
                            userDetailObject.deleteAllDetails(_userListToDelete,
                                shouldDeleteAll:
                                    _users.length == _userListToDelete.length);
                          }, "Delete", _sWidth * 40, _sWidth)
                        ],
                      ),
                    ))
                : Container()
          ],
        );
      }),
    );
  }

  _selectUnSelectOperation(UserDetailModel userDetailModel) {
    _userListToDelete = [];
    if (_selectUnSelectText == _selectAll) {
      userDetailModel.getUsers().forEach((user) {
        var _user = User(email: user.email);
        _userListToDelete.add(_user);
      });
    }
    _isDeleteEnabled = _selectUnSelectText == _selectAll;
    _selectUnSelectText =
        _selectUnSelectText == _selectAll ? _unSelectAll : _selectAll;
    userDetailModel.setState(requestStatus: RequestStatus.idle);
  }

  _cancelDeletion(UserDetailModel userDetailModel) {
    _userListToDelete = [];
    _isDeleteEnabled = false;
    _selectUnSelectText = _selectAll;
    userDetailModel.setState(requestStatus: RequestStatus.idle);
  }
}
