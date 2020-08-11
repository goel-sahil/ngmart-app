import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/UniversalProperties.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/NotificationResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/admin/order/OrderScreen.dart';
import 'package:ngmartflutter/ui/orderHistory/OrderHistory.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  bool fromAdmin;

  NotificationScreen({this.fromAdmin});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DashboardProvider provider;
  List<DataInner> dataInner = new List();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  int _currentPageNumber = 1;
  ScrollController scrollController = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @protected
  void initState() {
    _setScrollListener();
    _currentPageNumber = 1;
    Timer(Duration(milliseconds: 500), () {
      _hitApi();
    });
    super.initState();
  }

  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (dataInner.length >= (PAGINATION_SIZE * _currentPageNumber) &&
            _loadMore) {
          isPullToRefresh = true;
          _hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  Future<void> _hitApi() async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }

    if (!isPullToRefresh) {
      provider.setLoading(); //show loader
    }
    isPullToRefresh = false;

    if (_loadMore) {
      _currentPageNumber++;
    } else {
      _currentPageNumber = 1;
    }

    var response = await provider.getNotifications(context, _currentPageNumber);
    if (response is APIError) {
    } else if (response is NotificationResponse) {
      if (_currentPageNumber == 1) {
        dataInner.clear();
      }
      dataInner.addAll(response.data.dataInner);

      if (response.data.dataInner.length < response.data.perPage) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
//      unreadNotificationsCount = 0;
//      setState(() {});
    }
  }

  _hitDeleteBannerApi({int id, int position}) async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }
    provider?.setLoading();
    var response = await provider.deleteNotification(context, id);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is CommonResponse) {
      showInSnackBar(response.message);
      dataInner.removeAt(position);
      setState(() {});
    }
  }

  _hitMarkNotificationAsReadApi({int id, int position}) async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }
//    provider?.setLoading();
    var response = await provider.markNotiAsRead(context, id);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is CommonResponse) {
//      showInSnackBar(response.message);
      dataInner[position].status = 1;
      if (unreadNotificationsCount > 0) unreadNotificationsCount--;
      setState(() {});
    }
  }

  _hitMarkAllNotificationAsReadApi() async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }
    provider?.setLoading();
    var response = await provider.markAllNotificationRead(context);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is CommonResponse) {
      _currentPageNumber = 1;
      isPullToRefresh = true;
      _loadMore = false;
      _hitApi();
      unreadNotificationsCount = 0;
      showInSnackBar(response.message);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
              onTap: () {
                _hitMarkAllNotificationAsReadApi();
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 20, right: 10),
                  child: Text("Mark all read")))
        ],
      ),
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              isPullToRefresh = true;
              _loadMore = false;
              await _hitApi();
            },
            child: ListView.builder(
              itemCount: dataInner.length ?? 0,
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                String status = dataInner[index].message;
                return InkWell(
                  onTap: () {
                    _hitMarkNotificationAsReadApi(
                        id: dataInner[index].id, position: index);
                    if (widget.fromAdmin) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AdminOrdersScreen(
                                    fromNotification: true,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => OrderHistory(
                                    fromNotification: true,
                                  )));
                    }
                  },
                  //status=0 unread
                  //status=1 read
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: dataInner[index].status == 0
                          ? AppColors.kDisabledButtonColor
                          : Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {},
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(dataInner[index].title[0]),
                          ),
                        ),
                        title: Text(dataInner[index]?.title ?? ""),
                        subtitle: Text('$status'),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          _hitDeleteBannerApi(
                              id: dataInner[index].id, position: index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: provider.getLoading(),
              context: context,
            ),
          ),
          (dataInner.length == 0) && (provider.getLoading() == false)
              ? Center(
                  child: getNoDataView(
                      msg: "No notification found.", onRetry: null))
              : Container()
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
