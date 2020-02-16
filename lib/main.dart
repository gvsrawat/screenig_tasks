import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_demo/models/notification_model.dart';
import 'package:screen_demo/models/response_container.dart';
import 'package:screen_demo/models/user_details_model.dart';
import 'package:screen_demo/notification_manager/notification_manager.dart';
import 'package:screen_demo/screens/user_details_screen.dart';
import 'package:screen_demo/shared_custom_widgets/shared_custom_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationManager();
    return ChangeNotifierProvider(
      create: (_) => UserDetailModel(),
      child: MaterialApp(
        title: 'Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sHeight, _sWidth;
  final String thanksForService = "Thanks for availing service from";
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  showScrollableDialog() async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        barrierLabel: "",
        barrierColor: Colors.grey,
        transitionDuration: Duration(milliseconds: 120),
        transitionBuilder: (context, ag_first, ag_two, widget) {
          return Transform.scale(
              scale: ag_first.value,
              child: Material(
                child: Container(
                  width: _sWidth,
                  margin: EdgeInsets.symmetric(
                      vertical: _sHeight * 8, horizontal: _sWidth * 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: SingleChildScrollView(
                    reverse: true,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              margin: EdgeInsets.all(_sWidth * 1),
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                        Text(
                          thanksForService,
                          style: TextStyle(fontSize: _sWidth * 4),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: _sHeight * 1.5),
                          child: CircleAvatar(
                            radius: _sWidth * 15,
                            backgroundImage: NetworkImage(
                                "https://thumbor.forbes.com/thumbor/960x0/https%3A%2F%2Fblogs-images.forbes.com%2Fpavelkrapivin%2Ffiles%2F2018%2F09%2FHappy-Employee-Working-Laptop-AdobeStock_171333654-by-By-Drobot-Dean-1200x801.jpg"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: _sHeight * 0.8),
                          child: Text(
                            "Dr. Nupur Garg",
                            style: TextStyle(
                                fontSize: _sWidth * 5,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: _sHeight * 5),
                          child: Text(
                            "Rate your experience",
                            style: TextStyle(
                              fontSize: _sWidth * 4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: _sHeight * 1.5),
                          child: _showRatingsStars(),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: _sHeight * 5, left: _sWidth * 5),
                            child: Text(
                              "Leave your comments",
                              style: TextStyle(
                                fontSize: _sWidth * 4,
                              ),
                            ),
                          ),
                        ),
                        _leaveYourCommentsWidget(),
                        SharedWidgets().button(() => Navigator.pop(context),
                            "Submit", _sWidth * 24, _sWidth)
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  @override
  void initState() {
    NotificationManager().getEventBus().on<NotificationModel>().listen((data) {
      showSnackBar(data?.title);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _sHeight = size.height / 100;
    _sWidth = size.width / 100;
    final userDetails = Provider.of<UserDetailModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          color: Colors.grey,
          width: double.infinity,
          child: userDetails.requestStatus == RequestStatus.inProgress
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                )
              : _showColumn(
                  userDetails)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _leaveYourCommentsWidget() {
    return Container(
      height: _sHeight * 20,
      margin: EdgeInsets.only(
          left: _sWidth * 5,
          right: _sWidth * 5,
          top: _sHeight * 0.8,
          bottom: _sHeight * 1.6),
      padding: EdgeInsets.all(_sWidth * 2),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: TextField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: 10,
        maxLength: 250,
        decoration:
            InputDecoration.collapsed(hintText: "", border: InputBorder.none),
      ),
    );
  }

  Widget _showRatingsStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star_border,
          color: Colors.green,
          size: _sWidth * 7,
        ),
        Icon(
          Icons.star_border,
          color: Colors.green,
          size: _sWidth * 7,
        ),
        Icon(
          Icons.star_border,
          color: Colors.green,
          size: _sWidth * 7,
        ),
        Icon(
          Icons.star_border,
          color: Colors.green,
          size: _sWidth * 7,
        ),
        Icon(
          Icons.star_border,
          color: Colors.green,
          size: _sWidth * 7,
        )
      ],
    );
  }

  _getUserDetails(UserDetailModel userDetail) async {
    RequestOutput requestOutput = await userDetail.fetchUsers();
    if (requestOutput.requestStatus == RequestStatus.failed) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(requestOutput.failureCause)));
    } else if (requestOutput.requestStatus == RequestStatus.succeed) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserDetailScreen()));
    }
    userDetail.setState();
  }

  void showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(text ?? "Notification occurred")));
  }

  Widget _showColumn(UserDetailModel userDetails) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SharedWidgets().button(
            () => showScrollableDialog(), "Popup", _sWidth * 30, _sWidth),
        SharedWidgets().button(() => _getUserDetails(userDetails),
            "User Details Screen", _sWidth * 55, _sWidth),
      ],
    );
  }
}
