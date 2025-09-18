import 'package:flutter/material.dart';

/// 可展开收起组件
class ExpandableWidget extends StatefulWidget {
  /// 折叠状态下显示的内容
  final Widget collapsedChild;

  /// 展开状态下显示的内容
  final Widget expandedChild;

  /// 控制展开/收起的触发区域
  final Widget toggleWidget;

  /// 初始是否展开
  final bool initiallyExpanded;

  /// 展开/收起动画时长
  final Duration animationDuration;

  /// 展开/收起时的曲线动画
  final Curve animationCurve;

  const ExpandableWidget({
    super.key,
    required this.collapsedChild,
    required this.expandedChild,
    required this.toggleWidget,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    // 初始化动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: _isExpanded ? 1.0 : 0.0,
    );

    // 初始化动画
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 切换展开/收起状态
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 触发区域
        InkWell(
          onTap: _toggleExpansion,
          child: widget.toggleWidget,
        ),

        // 折叠内容
        widget.collapsedChild,

        // 展开内容（带动画）
        SizeTransition(
          sizeFactor: _animation,
          child: widget.expandedChild,
        ),
      ],
    );
  }
}
