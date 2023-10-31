import 'dart:math';
import 'package:flutter/material.dart';

class DesktopPaginationBar extends StatefulWidget {
  const DesktopPaginationBar({
    Key? key,
    required this.maxPage,
    required this.onPageChange,
    this.minPage = 1,
    this.initPage = 1,
    this.displayNum = 3,
  }) : super(key: key);

  final int maxPage;
  final int minPage;
  final int initPage;
  final int displayNum;
  final Function(int) onPageChange;

  @override
  State<StatefulWidget> createState() => _DesktopPaginationBarState();
}

class _DesktopPaginationBarState extends State<DesktopPaginationBar> {
  late int _currentPage;
  late double _itemWidth;
  late double _width;

  @override
  void initState() {
    //初始化页码
    _currentPage = widget.initPage;
    //计算导航栏宽度
    int digit = 0;
    int temp = widget.maxPage.toInt();
    while (temp > 0) {
      temp = (temp / 10).truncate();
      digit++;
    }
    _itemWidth = digit * 10 + 30;
    _width = (_itemWidth + 2) * widget.displayNum + 2 * 40 + 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int left;
    //如果当前显示的是最小页

    if (_currentPage == widget.minPage) {
      left = widget.minPage;
    } else {
      left = _currentPage - (widget.displayNum / 2).truncate();
    }
    //展示的最大页
    int right = left + widget.displayNum - 1;
    //右侧超过边界
    if (right > widget.maxPage) {
      int temp = right - widget.maxPage;
      right = widget.maxPage;
      left = max(widget.minPage, left - temp);
    }

    return Container(
      width: _width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //已经是最小页则不显示前一页
          left > widget.minPage
              ? IconButton(
                  color: Theme.of(context).colorScheme.onSurface,
                  icon: const Icon(Icons.chevron_left),
                  splashRadius: 17,
                  onPressed: () {
                    int targetPage = _currentPage - 1;
                    if (targetPage < widget.minPage) return;
                    widget.onPageChange(targetPage);
                    setState(() {
                      _currentPage--;
                    });
                  },
                )
              : const SizedBox(
                  width: 40,
                ),

          ...List<Widget>.generate(right - left + 1, (index) {
            int targetPage = index + left;
            return Container(
              padding: const EdgeInsets.only(right: 2),
              width: _itemWidth,
              child: OutlinedButton(
                onPressed: _currentPage == targetPage
                    ? null
                    : () {
                        widget.onPageChange(targetPage);
                        setState(() {
                          _currentPage = targetPage;
                        });
                      },
                child: Text("$targetPage"),
              ),
            );
          }),

          //已经是最后一页则不显示后一页
          right < widget.maxPage
              ? IconButton(
                  color: Theme.of(context).colorScheme.onSurface,
                  icon: const Icon(Icons.chevron_right),
                  splashRadius: 17,
                  onPressed: () {
                    int targetPage = _currentPage + 1;
                    if (targetPage > widget.maxPage) return;
                    widget.onPageChange(targetPage);
                    setState(() {
                      _currentPage++;
                    });
                  },
                )
              : const SizedBox(
                  width: 40,
                )
        ],
      ),
    );
  }
}
