import 'package:flutter/material.dart';

typedef OnToggle = void Function(int index);

class ToggleWidget extends StatefulWidget {
  final Color activeBgColor;
  final Color activeTextColor;
  final Color inactiveBgColor;
  final Color inactiveTextColor;
  final List<String> labels;
  final double cornerRadius;
  final OnToggle onToggle;
  final double minWidth;
  final int initialLabel;

  ToggleWidget({
    Key key,
    @required this.activeBgColor,
    @required this.activeTextColor,
    @required this.inactiveBgColor,
    @required this.inactiveTextColor,
    @required this.labels,
    this.onToggle,
    this.cornerRadius = 8.0,
    this.minWidth = 72,
    this.initialLabel = 0,
  }) : super(key: key);

  @override
  _ToggleWidgetState createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  int current;

  @override
  void initState() {
    current = widget.initialLabel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.cornerRadius),
      child: Container(
        height: 40,
        color: widget.inactiveBgColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.labels.length * 2 - 1, (index) {
            final active = index ~/ 2 == current;
            final textColor = active ? widget.activeTextColor : widget.inactiveTextColor;
            final bgColor = active ? widget.activeBgColor : Colors.transparent;
            if (index % 2 == 1) {
              final activeDivider = active || index ~/ 2 == current - 1;
              return Container(
                width: 1,
                color: activeDivider ? widget.activeBgColor : Colors.black45,
                margin: EdgeInsets.symmetric(vertical: activeDivider ? 0 : 8),
              );
            } else {
              return GestureDetector(
                onTap: () => _handleOnTap(index ~/ 2),
                child: Container(
                  constraints: BoxConstraints(minWidth: widget.minWidth),
                  alignment: Alignment.center,
                  color: bgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.labels[index ~/ 2],
                        style: TextStyle(color: textColor,fontSize: 12.0,fontFamily: 'IranSansLight')),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  void _handleOnTap(int index) async {
    setState(() => current = index);
    if (widget.onToggle != null) {
      widget.onToggle(index);
    }
  }
}

//ToggleWidget(
//activeBgColor: Colors.white,
//activeTextColor: Colors.black,
//inactiveBgColor: Colors.grey[400],
//inactiveTextColor: Colors.black,
//labels: [
//'AND',
//'XOR',
//'NOT',
//'NOT',
//],
//initialLabel: 1,
//onToggle: (index) {
//},
//),