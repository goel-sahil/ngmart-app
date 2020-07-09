import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class CmsPageScreen extends StatefulWidget {
  String text;
  String title;

  CmsPageScreen({this.text, this.title});

  @override
  _CmsPageScreenState createState() => _CmsPageScreenState();
}

class _CmsPageScreenState extends State<CmsPageScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: widget.text,
          //Optional parameters:
          style: {
            "html": Style(
            ),
            "tr": Style(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: EdgeInsets.all(6),
            ),
            "td": Style(
              padding: EdgeInsets.all(6),
            ),
            "var": Style(fontFamily: 'serif'),
          },
          customRender: {
            "flutter": (RenderContext context, Widget child, attributes, _) {
              return FlutterLogo(
                style: (attributes['horizontal'] != null)
                    ? FlutterLogoStyle.horizontal
                    : FlutterLogoStyle.markOnly,
                textColor: context.style.color,
                size: context.style.fontSize.size * 5,
              );
            },
          },
          onLinkTap: (url) {
            print("Opening $url...");
          },
          onImageTap: (src) {
            print(src);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
        ),
      ),
    );
  }
}
