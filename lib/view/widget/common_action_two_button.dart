import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//弹出框或抽屉等组件下方的确定取消按钮
class CommonActionTwoButton extends StatefulWidget {
  const CommonActionTwoButton({
    Key? key,
    this.onRightTap,
    this.onLeftTap,
    this.rightTitle = "确定",
    this.leftTitle = "取消",
    this.backgroundRightColor,
    this.backgroundLeftColor,
    this.height = 40,
    this.spacer = 30,
    this.leftTextColor,
    this.rightTextColor,
    this.execOnly = true,
  }) : super(key: key);

  //返回值代表是否调用pop
  final Function? onRightTap;
  final Function? onLeftTap;
  final bool execOnly;

  final String rightTitle;
  final String leftTitle;

  final Color? backgroundRightColor;
  final Color? backgroundLeftColor;
  final Color? leftTextColor;
  final Color? rightTextColor;

  //高度
  final double height;

  //两按钮间隔
  final double spacer;

  @override
  State<CommonActionTwoButton> createState() => _CommonActionTwoButtonState();
}

class _CommonActionTwoButtonState extends State<CommonActionTwoButton> {
  bool _rightLoading = false;
  bool _leftLoading = false;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: widget.height,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: widget.backgroundLeftColor == null ? null : MaterialStateProperty.all(widget.backgroundLeftColor!),
              ),
              onPressed: _leftLoading || (widget.execOnly && _rightLoading)
                  ? null
                  : () async {
                      if (widget.onLeftTap == null) {
                        return;
                      }
                      setState(() {
                        _leftLoading = true;
                      });
                      var isPop = await widget.onLeftTap!();

                      if (isPop == true) {
                        //表示调用pop
                        Navigator.pop(context);
                      }

                      setState(() {
                        _leftLoading = false;
                      });
                    },
              child: _leftLoading
                  ? CupertinoActivityIndicator(
                      color: widget.leftTextColor ?? colorScheme.onPrimary,
                    )
                  : Text(widget.leftTitle, style: TextStyle(color: widget.leftTextColor)),
            ),
          ),
        ),
        SizedBox(width: widget.spacer),
        Expanded(
          child: SizedBox(
            height: widget.height,
            child: OutlinedButton(
              style: ButtonStyle(backgroundColor: widget.backgroundRightColor == null ? null : MaterialStateProperty.all(widget.backgroundRightColor!)),
              onPressed: _rightLoading || (widget.execOnly && _leftLoading)
                  ? null
                  : () async {
                      if (widget.onRightTap == null) {
                        return;
                      }

                      setState(() {
                        _rightLoading = true;
                      });

                      var isPop = await widget.onRightTap!();

                      if (isPop == true) {
                        //表示调用pop
                        Navigator.pop(context);
                      }

                      setState(() {
                        _rightLoading = false;
                      });
                    },
              child: _rightLoading
                  ? CupertinoActivityIndicator(
                      color: widget.rightTextColor ?? colorScheme.onPrimary,
                    )
                  : Text(widget.rightTitle, style: TextStyle(color: widget.rightTextColor)),
            ),
          ),
        )
      ],
    );
  }
}
