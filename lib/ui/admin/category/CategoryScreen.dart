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
import 'file:///D:/Workspace/ngmart_flutter/lib/model/admin/brand/BrandResponse.dart';
import 'package:ngmartflutter/model/admin/category/AdminCategoryResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:ngmartflutter/ui/admin/brand/AddBrandScreen.dart';
import 'package:provider/provider.dart';

import '../../FullScreenImageScreen.dart';
import 'AddCategoryScreen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  AdminProvider adminProvider;
  List<DataCategory> dataInner = new List();
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

    var response = await adminProvider.getCategory(context,_currentPageNumber);
    if (response is APIError) {
    } else if (response is AdminCategoryResponse) {
      if (_currentPageNumber == 1) {
        dataInner.clear();
      }
      dataInner.addAll(response.data.dataCategory);
      if (response.data.dataCategory.length < response.data.perPage) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
    }
  }

  _hitDeleteCategoryApi({int id, int position}) async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }
    adminProvider.setLoading();

    var response = await adminProvider.deleteCategory(context, id);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is CommonResponse) {
      showInSnackBar(response.message);
      dataInner.removeAt(position);
      setState(() {});
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
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {},
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return new FullScreenImage(
                                        imageSrc: dataInner[index].imageUrl,
                                      );
                                    },
                                    fullscreenDialog: true));
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage("${dataInner[index].imageUrl}")),
                        ),
                        title: Text(dataInner[index].title),
                        subtitle: Text(dataInner[index].category != null
                            ? 'Parent Category: ${dataInner[index].category.title}'
                            : "Status: ${dataInner[index].status}"),
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
                                  builder: (context) => AddCategoryScreen(
                                        fromCategoryScreen: true,
                                        dataCategory: dataInner[index],
                                      )));
                          if (isUpdated != null && isUpdated) {
                            _currentPageNumber = 1;
                            _hitApi();
                          }
                        },
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          _hitDeleteCategoryApi(
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
              status: adminProvider.getLoading(),
              context: context,
            ),
          ),
          (dataInner.length == 0) && (adminProvider.getLoading() == false)
              ? Center(
                  child:
                      getNoDataView(msg: "No Category found.", onRetry: null))
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
