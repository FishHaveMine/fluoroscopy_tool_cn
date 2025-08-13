import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepsWidget extends StatefulWidget {
  const StepsWidget({Key? key, required this.currentIndex}) : super(key: key);
  final int currentIndex;

  @override
  StepsWidgetState createState() => StepsWidgetState();
}

class StepsWidgetState extends State<StepsWidget> {
  var _items = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int index = 1; index < 9; index++) {
      _items.add("Step$index");
    }
    setState(() {
      _items;
    });
  }

  void scrollToItem(int index) {
    // 计算每个项的宽度和间隔
    double itemWidth = 70.w + 20.w;
    double itemSpacing = 0.0; // itemSpacing = 8 (margin) * 2

    double offset = (itemWidth + itemSpacing) * index;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80.h,
      alignment: Alignment.center,
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: _items.length,
          itemBuilder: (context, index) {
            //如果显示到最后一个并且Icon总数小于200时继续获取数据
            return _buildItem(index);
          }),
    );
  }

  Widget _buildItem(int index) {
    return Container(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              Opacity(
                opacity: index == 0 ? 0 : 1,
                child: Container(
                  width: 35.w,
                  height: 1,
                  decoration: BoxDecoration(
                      color: index <= widget.currentIndex
                          ? const Color.fromRGBO(25, 98, 255, 1)
                          : Colors.grey),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                    color: index <= widget.currentIndex
                        ? const Color.fromRGBO(25, 98, 255, 1)
                        : Colors.grey),
                width: 20.w,
                height: 20.w,
              ),
              Opacity(
                opacity: _items.length - 1 == index ? 0 : 1,
                child: Container(
                  width: 35.w,
                  height: 1,
                  decoration: BoxDecoration(
                      color: index < widget.currentIndex
                          ? const Color.fromRGBO(25, 98, 255, 1)
                          : Colors.grey),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              _items[index],
              style: TextStyle(
                  fontSize: 12,
                  color: index <= widget.currentIndex
                      ? const Color.fromRGBO(25, 98, 255, 1)
                      : Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
