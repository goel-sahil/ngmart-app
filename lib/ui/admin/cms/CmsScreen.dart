import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/admin/cms/CmsResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:ngmartflutter/ui/admin/cms/UpdateCmsScreen.dart';
import 'package:ngmartflutter/ui/admin/quantity/AddQuantityScreen.dart';
import 'package:provider/provider.dart';

class CmsScreen extends StatefulWidget {
  @override
  _CmsScreenState createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> {
  AdminProvider adminProvider;
  List<CmsData> dataInner = new List();
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
      adminProvider.setLoading(); //show loader
    }
    isPullToRefresh = false;

    if (_loadMore) {
      _currentPageNumber++;
    } else {
      _currentPageNumber = 1;
    }

    var response = await adminProvider.getCms(context);
    if (response is APIError) {
    } else if (response is CmsResponse) {
      if (_currentPageNumber == 1) {
        dataInner.clear();
      }
      dataInner.addAll(response.data);

      if (response.data.length < 10) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    adminProvider = Provider.of<AdminProvider>(context);
    return Scaffold(
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
                String status =
                    dataInner[index].status == 1 ? "Active" : "In Active";
                return InkWell(
                  onTap: () {},
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(dataInner[index].title[0] ?? "A"),
                          foregroundColor: Colors.white,
                        ),
                        title: Text(dataInner[index].title),
                        subtitle: Text('Status: $status'),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () async {
                          var isUpdated = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UpdateCmsScreen(
                                        cmsResponse: dataInner[index],
                                      )));
                          if (isUpdated != null && isUpdated) {
                            _currentPageNumber = 1;
                            _hitApi();
                          }
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
              status: adminProvider.getLoading(),
              context: context,
            ),
          ),
          (dataInner.length == 0) && (adminProvider.getLoading() == false)
              ? Center(
                  child: getNoDataView(msg: "No CMS found.", onRetry: null))
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
