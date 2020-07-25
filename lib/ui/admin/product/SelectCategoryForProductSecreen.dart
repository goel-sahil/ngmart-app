import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/CategoryModel.dart';
import 'package:ngmartflutter/model/admin/category/CategoryListResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:provider/provider.dart';

class SelectCategoryForProductScreen extends StatefulWidget {
  @override
  _SelectCategoryForProductScreenState createState() =>
      _SelectCategoryForProductScreenState();
}

class _SelectCategoryForProductScreenState
    extends State<SelectCategoryForProductScreen> {
  AdminProvider adminProvider;
  List<Data> dataInner = new List();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @protected
  void initState() {
    Timer(Duration(milliseconds: 500), () {
      _hitApi();
    });
    super.initState();
  }

  Future<void> _hitApi() async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }
    adminProvider.setLoading(); //show loader
    var response = await adminProvider.getSubCategoryList(context);
    if (response is APIError) {
    } else if (response is CategoryListResponse) {
      dataInner.addAll(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    adminProvider = Provider.of<AdminProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Category",
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              await _hitApi();
            },
            child: ListView.builder(
              itemCount: dataInner.length ?? 0,
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      CategoryModel catModel = CategoryModel(
                          id: dataInner[index].id.toString(),
                          title: dataInner[index].title);
                      Navigator.pop(context, catModel);
                    },
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
                          title: Text(
                            (dataInner[index].title),
                          ),
                        ),
                      ),
                    ));
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
                  child: getNoDataView(
                      msg: "No Category list found.", onRetry: null))
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
