import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

import 'package:wms/configs/app_style_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 子组件构造器
typedef RefreshViewChildBuilder = Widget Function(
    BuildContext context, ScrollPhysics physics, Widget header, Widget footer);
typedef OnRefreshCallback = Future<void> Function();
typedef OnLoadCallback = Future<void> Function();

/// RefreshView
/// 下拉刷新,上拉加载组件
class RefreshView extends StatefulWidget {
  /// 控制器
  final RefreshViewController controller;

  /// 刷新回调(null为不开启刷新)
  final OnRefreshCallback onRefresh;

  /// 加载回调(null为不开启加载)
  final OnLoadCallback onLoad;

  /// 是否开启控制结束刷新
  final bool enableControlFinishRefresh;

  /// 是否开启控制结束加载
  final bool enableControlFinishLoad;

  /// 任务独立(刷新和加载状态独立)
  final bool taskIndependence;

  /// Header
  final Header header;
  final int headerIndex;

  /// Footer
  final Footer footer;

  /// 子组件构造器
  final RefreshViewChildBuilder builder;

  /// 子组件
  final Widget child;

  /// 首次刷新
  final bool firstRefresh;

  /// 首次刷新组件
  /// 不设置时使用header
  final Widget firstRefreshWidget;

  /// 空视图
  /// 当不为null时,只会显示空视图
  /// 保留[headerIndex]以上的内容
  final Widget emptyWidget;

  /// 顶部回弹(onRefresh为null时生效)
  final bool topBouncing;

  /// 底部回弹(onLoad为null时生效)
  final bool bottomBouncing;

  /// CustomListView Key
  final Key listKey;

  /// Slivers集合
  final List<Widget> slivers;

  /// 列表方向
  final Axis scrollDirection;

  /// 反向
  final bool reverse;
  final ScrollController scrollController;
  final bool primary;
  final bool shrinkWrap;
  final Key center;
  final double anchor;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;

  /// 全局默认Header
  static Header _defaultHeader = ClassicalHeader();

  static set defaultHeader(Header header) {
    if (header != null) {
      _defaultHeader = header;
    }
  }

  /// 全局默认Footer
  static Footer _defaultFooter = ClassicalFooter();

  static set defaultFooter(Footer footer) {
    if (footer != null) {
      _defaultFooter = footer;
    }
  }

  /// 触发时超过距离
  static double callOverExtent = 30.0;

  /// 默认构造器
  /// 将child转换为CustomScrollView可用的slivers
  RefreshView({
    Key key,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.enableControlFinishRefresh = false,
    this.enableControlFinishLoad = false,
    this.taskIndependence = false,
    this.scrollController,
    this.header,
    this.footer,
    this.firstRefresh,
    this.firstRefreshWidget,
    this.headerIndex,
    this.emptyWidget,
    this.topBouncing = true,
    this.bottomBouncing = true,
    @required this.child,
  })  : this.scrollDirection = null,
        this.reverse = null,
        this.builder = null,
        this.primary = null,
        this.shrinkWrap = null,
        this.center = null,
        this.anchor = null,
        this.cacheExtent = null,
        this.slivers = null,
        this.semanticChildCount = null,
        this.dragStartBehavior = null,
        this.listKey = null,
        super(key: key);

  /// custom构造器(推荐)
  /// 直接使用CustomScrollView可用的slivers
  RefreshView.custom({
    Key key,
    this.listKey,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.enableControlFinishRefresh = false,
    this.enableControlFinishLoad = false,
    this.taskIndependence = false,
    this.header,
    this.headerIndex,
    this.footer,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.firstRefresh,
    this.firstRefreshWidget,
    this.emptyWidget,
    this.topBouncing = true,
    this.bottomBouncing = true,
    @required this.slivers,
  })  : this.builder = null,
        this.child = null,
        super(key: key);

  /// 自定义构造器
  /// 用法灵活,但需将physics、header和footer放入列表中
  RefreshView.builder({
    Key key,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.enableControlFinishRefresh = false,
    this.enableControlFinishLoad = false,
    this.taskIndependence = false,
    this.scrollController,
    this.header,
    this.footer,
    this.firstRefresh,
    this.topBouncing = true,
    this.bottomBouncing = true,
    @required this.builder,
  })  : this.scrollDirection = null,
        this.reverse = null,
        this.child = null,
        this.primary = null,
        this.shrinkWrap = null,
        this.center = null,
        this.anchor = null,
        this.cacheExtent = null,
        this.slivers = null,
        this.semanticChildCount = null,
        this.dragStartBehavior = null,
        this.headerIndex = null,
        this.firstRefreshWidget = null,
        this.emptyWidget = null,
        this.listKey = null,
        super(key: key);

  @override
  _RefreshViewState createState() {
    return _RefreshViewState();
  }
}

class _RefreshViewState extends State<RefreshView> {
  // Physics
  RefreshViewPhysics _physics;

  // Header
  Header get _header {
    if (_enableFirstRefresh && widget.firstRefreshWidget != null)
      return _firstRefreshHeader;
    return widget.header ?? RefreshView._defaultHeader;
  }

  // 是否开启首次刷新
  bool _enableFirstRefresh = false;

  // 首次刷新组件
  Header _firstRefreshHeader;

  // Footer
  Footer get _footer {
    return widget.footer ?? RefreshView._defaultFooter;
  }

  // 子组件的ScrollController
  ScrollController _childScrollController;

  // ScrollController
  ScrollController get _scrollerController {
    return widget.scrollController ??
        _childScrollController ??
        PrimaryScrollController.of(context);
  }

  // 滚动焦点状态
  ValueNotifier<bool> _focusNotifier;

  // 任务状态
  ValueNotifier<TaskState> _taskNotifier;

  // 触发刷新状态
  ValueNotifier<bool> _callRefreshNotifier;

  // 触发加载状态
  ValueNotifier<bool> _callLoadNotifier;

  // 初始化
  @override
  void initState() {
    super.initState();
    _focusNotifier = ValueNotifier<bool>(false);
    _taskNotifier = ValueNotifier(TaskState());
    _callRefreshNotifier = ValueNotifier<bool>(false);
    _callLoadNotifier = ValueNotifier<bool>(false);
    _taskNotifier.addListener(() {
      // 监听首次刷新是否结束
      if (_enableFirstRefresh && !_taskNotifier.value.refreshing) {
        _scrollerController.jumpTo(0.0);
        setState(() {
          _enableFirstRefresh = false;
        });
      }
    });
    // 判断是否开启首次刷新
    _enableFirstRefresh = widget.firstRefresh ?? false;
    if (_enableFirstRefresh) {
      _firstRefreshHeader = FirstRefreshHeader(widget.firstRefreshWidget);
      SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
        callRefresh();
      });
    }
  }

  // 更新依赖
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 绑定控制器
    if (widget.controller != null)
      widget.controller._bindRefreshViewState(this);
    // 列表物理形式
    _physics = RefreshViewPhysics(
      topBouncing: widget.onRefresh == null ? widget.topBouncing : true,
      bottomBouncing: widget.onLoad == null ? widget.bottomBouncing : true,
    );
  }

  // 销毁
  void dispose() {
    super.dispose();
    _focusNotifier.dispose();
    _taskNotifier.dispose();
    _callRefreshNotifier.dispose();
    _callLoadNotifier.dispose();
  }

  // 触发刷新
  void callRefresh({Duration duration = const Duration(milliseconds: 300)}) {
    // ignore: invalid_use_of_protected_member
    if (_scrollerController == null || _scrollerController.positions.isEmpty)
      return;
    _callRefreshNotifier.value = true;
    _scrollerController
        .animateTo(0.0, duration: duration, curve: Curves.linear)
        .whenComplete(() {
      _scrollerController.animateTo(
          -(_header.triggerDistance + RefreshView.callOverExtent),
          duration: Duration(milliseconds: 100),
          curve: Curves.linear);
    });
  }

  // 触发加载
  void callLoad({Duration duration = const Duration(milliseconds: 300)}) {
    // ignore: invalid_use_of_protected_member
    if (_scrollerController == null || _scrollerController.positions.isEmpty)
      return;
    _callLoadNotifier.value = true;
    _scrollerController
        .animateTo(_scrollerController.position.maxScrollExtent,
            duration: duration, curve: Curves.linear)
        .whenComplete(() {
      _scrollerController.animateTo(
          _scrollerController.position.maxScrollExtent +
              _footer.triggerDistance +
              RefreshView.callOverExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 列表物理形式
    bool topBouncing = widget.onRefresh == null ? widget.topBouncing : true;
    bool bottomBouncing = widget.onLoad == null ? widget.bottomBouncing : true;
    if (topBouncing != _physics.topBouncing ||
        bottomBouncing != _physics.bottomBouncing) {
      _physics = RefreshViewPhysics(
        topBouncing: topBouncing,
        bottomBouncing: bottomBouncing,
      );
    }
    // 构建Header和Footer
    var header = widget.onRefresh == null
        ? null
        : _header.builder(context, widget, _focusNotifier, _taskNotifier,
            _callRefreshNotifier);
    var footer = widget.onLoad == null
        ? null
        : _footer.builder(
            context, widget, _focusNotifier, _taskNotifier, _callLoadNotifier);
    // 生成slivers
    List<Widget> slivers;
    if (widget.builder == null) {
      if (widget.slivers != null)
        slivers = List.from(
          widget.slivers,
          growable: true,
        );
      else if (widget.child != null) slivers = _buildSliversByChild();
      // 判断是否有空视图
      if (widget.emptyWidget != null && slivers != null) {
        slivers = slivers.sublist(0, widget.headerIndex ?? 0);
        // 添加空元素避免异常
        slivers.add(SliverList(
          delegate: SliverChildListDelegate([SizedBox()]),
        ));
        slivers.add(EmptyWidget(
          child: widget.emptyWidget,
        ));
      }
      // 插入Header和Footer
      if (header != null && slivers != null)
        slivers.insert(widget.headerIndex ?? 0, header);
      if (footer != null && slivers != null) slivers.add(footer);
    }
    // 构建列表组件
    Widget listBody;
    if (widget.builder != null) {
      listBody = widget.builder(context, _physics, header, footer);
    } else if (widget.slivers != null) {
      listBody = CustomScrollView(
        key: widget.listKey,
        physics: _physics,
        slivers: slivers,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.scrollController,
        primary: widget.primary,
        shrinkWrap: widget.shrinkWrap,
        center: widget.center,
        anchor: widget.anchor,
        cacheExtent: widget.cacheExtent,
        semanticChildCount: widget.semanticChildCount,
        dragStartBehavior: widget.dragStartBehavior,
      );
    } else if (widget.child != null) {
      listBody = _buildListBodyByChild(slivers, header, footer);
    } else {
      listBody = Container();
    }
    return ScrollNotificationListener(
      onNotification: (notification) {
        return false;
      },
      onFocus: (focus) {
        _focusNotifier.value = focus;
      },
      child: listBody,
    );
  }

  // 将child转换为CustomScrollView可用的slivers
  List<Widget> _buildSliversByChild() {
    Widget child = widget.child;
    List<Widget> slivers;
    if (child == null) return slivers;
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        // ignore: invalid_use_of_protected_member
        Widget sliver = child.buildChildLayout(context);
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding)];
        } else {
          slivers = [sliver];
        }
      } else {
        // ignore: invalid_use_of_protected_member
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else if (child is SingleChildScrollView) {
      slivers = [
        SliverPadding(
          sliver: SliverList(
            delegate: SliverChildListDelegate([child.child]),
          ),
          padding: child.padding ?? EdgeInsets.all(0.0),
        ),
      ];
    } else if (child is! Scrollable) {
      slivers = [
        SliverToBoxAdapter(
          child: child,
        )
      ];
    }
    return slivers;
  }

  // 通过child构建列表组件
  Widget _buildListBodyByChild(
      List<Widget> slivers, Widget header, Widget footer) {
    Widget child = widget.child;
    if (child is ScrollView) {
      _childScrollController = child.controller;
      return CustomScrollView(
        physics: _physics,
        controller: child.controller ?? widget.scrollController,
        cacheExtent: child.cacheExtent,
        key: child.key,
        scrollDirection: child.scrollDirection,
        semanticChildCount: child.semanticChildCount,
        slivers: slivers,
        dragStartBehavior: child.dragStartBehavior,
        reverse: child.reverse,
      );
    } else if (child is SingleChildScrollView) {
      _childScrollController = child.controller;
      return CustomScrollView(
        physics: _physics,
        controller: child.controller ?? widget.scrollController,
        scrollDirection: child.scrollDirection,
        slivers: slivers,
        dragStartBehavior: child.dragStartBehavior,
        reverse: child.reverse,
      );
    } else if (child is Scrollable) {
      _childScrollController = child.controller;
      return Scrollable(
        physics: _physics,
        controller: child.controller ?? widget.scrollController,
        axisDirection: child.axisDirection,
        semanticChildCount: child.semanticChildCount,
        dragStartBehavior: child.dragStartBehavior,
        viewportBuilder: (context, position) {
          Viewport viewport = child.viewportBuilder(context, position);
          // 判断是否有空视图
          if (widget.emptyWidget != null) {
            if (viewport.children.length > (widget.headerIndex ?? 0) + 1) {
              viewport.children.removeRange(
                  widget.headerIndex, viewport.children.length - 1);
            }
            // 添加空元素避免异常
            viewport.children.add(SliverList(
              delegate: SliverChildListDelegate([SizedBox()]),
            ));
            viewport.children.add(EmptyWidget(
              child: widget.emptyWidget,
            ));
          }
          if (header != null) {
            viewport.children.insert(widget.headerIndex ?? 0, header);
          }
          if (footer != null) {
            viewport.children.add(footer);
          }
          return viewport;
        },
      );
    } else {
      return CustomScrollView(
        physics: _physics,
        controller: widget.scrollController,
        slivers: slivers,
      );
    }
  }
}

/// 任务状态
class TaskState {
  bool refreshing;
  bool loading;

  TaskState({this.refreshing = false, this.loading = false});

  TaskState copy({bool refreshing, bool loading}) {
    return TaskState(
      refreshing: refreshing ?? this.refreshing,
      loading: loading ?? this.loading,
    );
  }
}

/// RefreshView控制器
class RefreshViewController {
  /// 触发刷新
  void callRefresh({Duration duration = const Duration(milliseconds: 300)}) {
    if (this._easyRefreshState != null) {
      this._easyRefreshState.callRefresh(duration: duration);
    }
  }

  /// 触发加载
  void callLoad({Duration duration = const Duration(milliseconds: 300)}) {
    if (this._easyRefreshState != null) {
      this._easyRefreshState.callLoad(duration: duration);
    }
  }

  /// 完成刷新
  FinishRefresh finishRefreshCallBack;

  void finishRefresh({
    bool success,
    bool noMore,
  }) {
    if (finishRefreshCallBack != null) {
      finishRefreshCallBack(success: success, noMore: noMore);
    }
  }

  /// 完成加载
  FinishLoad finishLoadCallBack;

  void finishLoad({
    bool success,
    bool noMore,
  }) {
    if (finishLoadCallBack != null) {
      finishLoadCallBack(success: success, noMore: noMore);
    }
  }

  /// 恢复刷新状态(用于没有更多后)
  VoidCallback resetRefreshStateCallBack;

  void resetRefreshState() {
    if (resetRefreshStateCallBack != null) {
      resetRefreshStateCallBack();
    }
  }

  /// 恢复加载状态(用于没有更多后)
  VoidCallback resetLoadStateCallBack;

  void resetLoadState() {
    if (resetLoadStateCallBack != null) {
      resetLoadStateCallBack();
    }
  }

  // 状态
  _RefreshViewState _easyRefreshState;

  // 绑定状态
  void _bindRefreshViewState(_RefreshViewState state) {
    this._easyRefreshState = state;
  }

  void dispose() {
    this._easyRefreshState = null;
    this.finishRefreshCallBack = null;
    this.finishLoadCallBack = null;
    this.resetLoadStateCallBack = null;
    this.resetRefreshStateCallBack = null;
  }
}

class RefreshViewPhysics extends ScrollPhysics {
  /// 顶部回弹
  final bool topBouncing;

  /// 底部回弹
  final bool bottomBouncing;

  /// Creates scroll physics that bounce back from the edge.
  const RefreshViewPhysics({
    ScrollPhysics parent,
    this.topBouncing = true,
    this.bottomBouncing = true,
  }) : super(parent: parent);

  @override
  RefreshViewPhysics applyTo(ScrollPhysics ancestor) {
    return RefreshViewPhysics(
      parent: buildParent(ancestor),
      topBouncing: topBouncing,
      bottomBouncing: bottomBouncing,
    );
  }

  /// The multiple applied to overscroll to make it appear that scrolling past
  /// the edge of the scrollable contents is harder than scrolling the list.
  /// This is done by reducing the ratio of the scroll effect output vs the
  /// scroll gesture input.
  ///
  /// This factor starts at 0.52 and progressively becomes harder to overscroll
  /// as more of the area past the edge is dragged in (represented by an increasing
  /// `overscrollFraction` which starts at 0 when there is no overscroll).
  double frictionFactor(double overscrollFraction) =>
      0.52 * math.pow(1 - overscrollFraction, 2);

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    if (!position.outOfRange) return offset;

    final double overscrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast =
        math.max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        // Apply less resistance when easing the overscroll vs tensioning.
        ? frictionFactor(
            (overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) return absDelta * gamma;
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (!this.topBouncing) {
      if (value < position.pixels &&
          position.pixels <= position.minScrollExtent) // underscroll
        return value - position.pixels;
      if (value < position.minScrollExtent &&
          position.minScrollExtent < position.pixels) // hit top edge
        return value - position.minScrollExtent;
    }
    if (!this.bottomBouncing) {
      if (position.maxScrollExtent <= position.pixels &&
          position.pixels < value) // overscroll
        return value - position.pixels;
      if (position.pixels < position.maxScrollExtent &&
          position.maxScrollExtent < value) // hit bottom edge
        return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.91,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  // The ballistic simulation here decelerates more slowly than the one for
  // ClampingScrollPhysics so we require a more deliberate input gesture
  // to trigger a fling.
  @override
  double get minFlingVelocity => kMinFlingVelocity * 2.0;

  // Methodology:
  // 1- Use https://github.com/flutter/scroll_overlay to test with Flutter and
  //    platform scroll views superimposed.
  // 2- Record incoming speed and make rapid flings in the test app.
  // 3- If the scrollables stopped overlapping at any moment, adjust the desired
  //    output value of this function at that input speed.
  // 4- Feed new input/output set into a power curve fitter. Change function
  //    and repeat from 2.
  // 5- Repeat from 2 with medium and slow flings.
  /// Momentum build-up function that mimics iOS's scroll speed increase with repeated flings.
  ///
  /// The velocity of the last fling is not an important factor. Existing speed
  /// and (related) time since last fling are factors for the velocity transfer
  /// calculations.
  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
            40000.0);
  }

  // Eyeballed from observation to counter the effect of an unintended scroll
  // from the natural motion of lifting the finger after a scroll.
  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  /// 重新runtimeType,用于更新状态
  @override
  Type get runtimeType {
    if (topBouncing && bottomBouncing)
      return RefreshViewPhysics;
    else if (!topBouncing && bottomBouncing)
      return ClampingScrollPhysics;
    else if (topBouncing && !bottomBouncing)
      return AlwaysScrollableScrollPhysics;
    else
      return NeverScrollableScrollPhysics;
  }
}

/// Header
abstract class Header {
  /// Header容器高度
  final double extent;

  /// 触发刷新高度
  final double triggerDistance;

  /// 是否浮动
  final bool float;

  /// 完成延时
  final Duration completeDuration;

  /// 是否开启无限刷新
  final bool enableInfiniteRefresh;

  /// 开启震动反馈
  final bool enableHapticFeedback;

  Header({
    this.extent = 60.0,
    this.triggerDistance = 70.0,
    this.float = false,
    this.completeDuration,
    this.enableInfiniteRefresh = false,
    this.enableHapticFeedback = false,
  });

  // 构造器
  Widget builder(
      BuildContext context,
      RefreshView easyRefresh,
      ValueNotifier<bool> focusNotifier,
      ValueNotifier<TaskState> taskNotifier,
      ValueNotifier<bool> callRefreshNotifier) {
    return RefreshViewSliverRefreshControl(
      refreshIndicatorExtent: extent,
      refreshTriggerPullDistance: triggerDistance,
      builder: contentBuilder,
      completeDuration: completeDuration,
      onRefresh: easyRefresh.onRefresh,
      focusNotifier: focusNotifier,
      taskNotifier: taskNotifier,
      callRefreshNotifier: callRefreshNotifier,
      taskIndependence: easyRefresh.taskIndependence,
      enableControlFinishRefresh: easyRefresh.enableControlFinishRefresh,
      enableInfiniteRefresh: enableInfiniteRefresh && !float,
      enableHapticFeedback: enableHapticFeedback,
      headerFloat: float,
      bindRefreshIndicator: (finishRefresh, resetRefreshState) {
        if (easyRefresh.controller != null) {
          easyRefresh.controller.finishRefreshCallBack = finishRefresh;
          easyRefresh.controller.resetRefreshStateCallBack = resetRefreshState;
        }
      },
    );
  }

  // Header构造器
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore);
}

/// 通知器Header
class NotificationHeader extends Header {
  /// Header
  final Header header;

  /// 通知器
  final LinkHeaderNotifier notifier;

  NotificationHeader({
    @required this.header,
    this.notifier,
  })  : assert(
          header != null,
          'A non-null Header must be provided to a NotifierHeader.',
        ),
        super(
          extent: header.extent,
          triggerDistance: header.triggerDistance,
          float: header.float,
          completeDuration: header.completeDuration,
          enableInfiniteRefresh: header.enableInfiniteRefresh,
          enableHapticFeedback: header.enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    // 发起通知
    this.notifier?.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
    return header.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
  }
}

/// 通用Header
class CustomHeader extends Header {
  /// Header构造器
  final RefreshControlBuilder headerBuilder;

  CustomHeader({
    extent = 60.0,
    triggerDistance = 70.0,
    float = false,
    completeDuration,
    enableInfiniteRefresh = false,
    enableHapticFeedback = false,
    @required this.headerBuilder,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: completeDuration,
          enableInfiniteRefresh: enableInfiniteRefresh,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    return headerBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
  }
}

/// 链接通知器
class LinkHeaderNotifier extends ChangeNotifier {
  BuildContext context;
  RefreshMode refreshState = RefreshMode.inactive;
  double pulledExtent = 0.0;
  double refreshTriggerPullDistance;
  double refreshIndicatorExtent;
  AxisDirection axisDirection;
  bool float;
  Duration completeDuration;
  bool enableInfiniteRefresh;
  bool success = true;
  bool noMore = false;

  void contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    this.context = context;
    this.refreshState = refreshState;
    this.pulledExtent = pulledExtent;
    this.refreshTriggerPullDistance = refreshTriggerPullDistance;
    this.refreshIndicatorExtent = refreshIndicatorExtent;
    this.axisDirection = axisDirection;
    this.float = float;
    this.completeDuration = completeDuration;
    this.enableInfiniteRefresh = enableInfiniteRefresh;
    this.success = success;
    this.noMore = noMore;
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      notifyListeners();
    });
  }
}

/// 链接器Header
class LinkHeader extends Header {
  final LinkHeaderNotifier linkNotifier;

  LinkHeader(
    this.linkNotifier, {
    extent = 60.0,
    triggerDistance = 70.0,
    completeDuration,
    enableHapticFeedback = false,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: true,
          completeDuration: completeDuration,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
    return SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }
}

/// 经典Header
class ClassicalHeader extends Header {
  /// Key
  final Key key;

  /// 方位
  final AlignmentGeometry alignment;

  /// 提示刷新文字
  final String refreshText;

  /// 准备刷新文字
  final String refreshReadyText;

  /// 正在刷新文字
  final String refreshingText;

  /// 刷新完成文字
  final String refreshedText;

  /// 刷新失败文字
  final String refreshFailedText;

  /// 没有更多文字
  final String noMoreText;

  /// 显示额外信息(默认为时间)
  final bool showInfo;

  /// 更多信息
  final String infoText;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  ClassicalHeader({
    double extent = 60.0,
    double triggerDistance = 70.0,
    bool float = false,
    Duration completeDuration = const Duration(seconds: 1),
    bool enableInfiniteRefresh = false,
    bool enableHapticFeedback = true,
    this.key,
    this.alignment,
    this.refreshText,
    this.refreshReadyText,
    this.refreshingText,
    this.refreshedText,
    this.refreshFailedText,
    this.noMoreText,
    this.showInfo: true,
    this.infoText,
    this.bgColor: Colors.transparent,
    this.textColor: Colors.black,
    this.infoColor: Colors.teal,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: float
              ? completeDuration == null
                  ? Duration(
                      milliseconds: 400,
                    )
                  : completeDuration +
                      Duration(
                        milliseconds: 400,
                      )
              : completeDuration,
          enableInfiniteRefresh: enableInfiniteRefresh,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    return ClassicalHeaderWidget(
      key: key,
      classicalHeader: this,
      refreshState: refreshState,
      pulledExtent: pulledExtent,
      refreshTriggerPullDistance: refreshTriggerPullDistance,
      refreshIndicatorExtent: refreshIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteRefresh: enableInfiniteRefresh,
      success: success,
      noMore: noMore,
    );
  }
}

/// 经典Header组件
class ClassicalHeaderWidget extends StatefulWidget {
  final ClassicalHeader classicalHeader;
  final RefreshMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration completeDuration;
  final bool enableInfiniteRefresh;
  final bool success;
  final bool noMore;

  ClassicalHeaderWidget(
      {Key key,
      this.refreshState,
      this.classicalHeader,
      this.pulledExtent,
      this.refreshTriggerPullDistance,
      this.refreshIndicatorExtent,
      this.axisDirection,
      this.float,
      this.completeDuration,
      this.enableInfiniteRefresh,
      this.success,
      this.noMore})
      : super(key: key);

  @override
  ClassicalHeaderWidgetState createState() => ClassicalHeaderWidgetState();
}

class ClassicalHeaderWidgetState extends State<ClassicalHeaderWidget>
    with TickerProviderStateMixin<ClassicalHeaderWidget> {
  // 是否到达触发刷新距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
      _overTriggerDistance = over;
    }
  }

  /// 默认语言
//  GlobalRefreshViewLocalizations _localizations =
//  GlobalRefreshViewLocalizations();

  /// 文本
  String get _refreshText {
    // return widget.classicalHeader.refreshText ?? 'Pull to refresh';
    return widget.classicalHeader.refreshText ?? '下拉刷新';
  }

  String get _refreshReadyText {
    // return widget.classicalHeader.refreshReadyText ?? 'Release to refresh';
    return widget.classicalHeader.refreshReadyText ?? '松开刷新页面';
  }

  String get _refreshingText {
    // return widget.classicalHeader.refreshingText ?? 'Refreshing...';
    return widget.classicalHeader.refreshingText ?? '页面刷新中';
  }

  String get _refreshedText {
    // return widget.classicalHeader.refreshedText ?? 'Refresh completed';
    return widget.classicalHeader.refreshedText ?? '完成页面刷新';
  }

  String get _refreshFailedText {
    // return widget.classicalHeader.refreshFailedText ?? 'Refresh failed';
    return widget.classicalHeader.refreshFailedText ?? '页面刷新失败';
  }

  String get _noMoreText {
    // return widget.classicalHeader.noMoreText ?? 'noMore';
    return widget.classicalHeader.noMoreText ?? '暂无更多';
  }

  String get _infoText {
    // return widget.classicalHeader.infoText ?? 'updateAt';
    return widget.classicalHeader.infoText ?? '';
  }

  // 是否刷新完成
  bool _refreshFinish = false;

  set refreshFinish(bool finish) {
    if (_refreshFinish != finish) {
      if (finish && widget.float) {
        Future.delayed(widget.completeDuration - Duration(milliseconds: 400),
            () {
          if (mounted) {
            _floatBackController.forward();
          }
        });
        Future.delayed(widget.completeDuration, () {
          _floatBackDistance = null;
          _refreshFinish = false;
        });
      }
      _refreshFinish = finish;
    }
  }

  // 动画
  AnimationController _readyController;
  Animation<double> _readyAnimation;
  AnimationController _restoreController;
  Animation<double> _restoreAnimation;
  AnimationController _floatBackController;
  Animation<double> _floatBackAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 浮动时,收起距离
  double _floatBackDistance;

  // 显示文字
  String get _showText {
    if (widget.noMore) return _noMoreText;
    if (widget.enableInfiniteRefresh) {
      if (widget.refreshState == RefreshMode.refreshed ||
          widget.refreshState == RefreshMode.inactive ||
          widget.refreshState == RefreshMode.drag) {
        return _finishedText;
      } else {
        return _refreshingText;
      }
    }
    switch (widget.refreshState) {
      case RefreshMode.refresh:
        return _refreshingText;
      case RefreshMode.armed:
        return _refreshingText;
      case RefreshMode.refreshed:
        return _finishedText;
      case RefreshMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return _refreshReadyText;
        } else {
          return _refreshText;
        }
    }
  }

  // 刷新结束文字
  String get _finishedText {
    if (!widget.success) return _refreshFailedText;
    if (widget.noMore) return _noMoreText;
    return _refreshedText;
  }

  // 刷新结束图标
  IconData get _finishedIcon {
    if (!widget.success) return Icons.error_outline;
    if (widget.noMore) return Icons.hourglass_empty;
    return Icons.done;
  }

  // 更新时间
  DateTime _dateTime;

  // 获取更多信息
  String get _infoTextStr {
    if (widget.refreshState == RefreshMode.refreshed) {
      _dateTime = DateTime.now();
    }
    String fillChar = _dateTime.minute < 10 ? "0" : "";
    return _infoText.replaceAll(
        "%T", "${_dateTime.hour}:$fillChar${_dateTime.minute}");
  }

  @override
  void initState() {
    super.initState();
    // 初始化时间
    _dateTime = DateTime.now();
    // 准备动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    // 恢复动画
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
        new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
          ..addListener(() {
            setState(() {
              if (_restoreAnimation.status != AnimationStatus.dismissed) {
                _iconRotationValue = _restoreAnimation.value;
              }
            });
          });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
    // float收起动画
    _floatBackController = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _floatBackAnimation =
        new Tween(begin: widget.refreshIndicatorExtent, end: 0.0)
            .animate(_floatBackController)
              ..addListener(() {
                setState(() {
                  if (_floatBackAnimation.status != AnimationStatus.dismissed) {
                    _floatBackDistance = _floatBackAnimation.value;
                  }
                });
              });
    _floatBackAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _floatBackController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    _floatBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 是否为垂直方向
    bool isVertical = widget.axisDirection == AxisDirection.down ||
        widget.axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = widget.axisDirection == AxisDirection.up ||
        widget.axisDirection == AxisDirection.left;
    // 是否到达触发刷新距离
    overTriggerDistance = widget.refreshState != RefreshMode.inactive &&
        widget.pulledExtent >= widget.refreshTriggerPullDistance;
    if (widget.refreshState == RefreshMode.refreshed) {
      refreshFinish = true;
    }
    return Stack(
      children: <Widget>[
        Positioned(
          top: !isVertical
              ? 0.0
              : isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          bottom: !isVertical
              ? 0.0
              : !isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          left: isVertical
              ? 0.0
              : isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          right: isVertical
              ? 0.0
              : !isReverse
                  ? _floatBackDistance == null
                      ? 0.0
                      : (widget.refreshIndicatorExtent - _floatBackDistance)
                  : null,
          child: Container(
            alignment: widget.classicalHeader.alignment ?? isVertical
                ? isReverse
                    ? Alignment.topCenter
                    : Alignment.bottomCenter
                : !isReverse
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            width: isVertical
                ? double.infinity
                : _floatBackDistance == null
                    ? (widget.refreshIndicatorExtent > widget.pulledExtent
                        ? widget.refreshIndicatorExtent
                        : widget.pulledExtent)
                    : widget.refreshIndicatorExtent,
            height: isVertical
                ? _floatBackDistance == null
                    ? (widget.refreshIndicatorExtent > widget.pulledExtent
                        ? widget.refreshIndicatorExtent
                        : widget.pulledExtent)
                    : widget.refreshIndicatorExtent
                : double.infinity,
            color: widget.classicalHeader.bgColor,
            child: SizedBox(
              height:
                  isVertical ? widget.refreshIndicatorExtent : double.infinity,
              width:
                  !isVertical ? widget.refreshIndicatorExtent : double.infinity,
              child: isVertical
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  List<Widget> _buildContent(bool isVertical, bool isReverse) {
    return isVertical
        ? <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  right: 10.0,
                ),
                child: (widget.refreshState == RefreshMode.refresh ||
                            widget.refreshState == RefreshMode.armed) &&
                        !widget.noMore
                    ? Container(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(
                            widget.classicalHeader.textColor,
                          ),
                        ),
                      )
                    : widget.refreshState == RefreshMode.refreshed ||
                            widget.refreshState == RefreshMode.done ||
                            (widget.enableInfiniteRefresh &&
                                widget.refreshState != RefreshMode.refreshed) ||
                            widget.noMore
                        ? Icon(
                            _finishedIcon,
                            color: widget.classicalHeader.textColor,
                          )
                        : Transform.rotate(
                            child: Icon(
                              isReverse
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: widget.classicalHeader.textColor,
                            ),
                            angle: 2 * pi * _iconRotationValue,
                          ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _showText,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: widget.classicalHeader.textColor,
                    ),
                  ),
                  widget.classicalHeader.showInfo
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 2.0,
                          ),
                          child: Text(
                            _infoTextStr,
                            style: TextStyle(
                              fontSize: AppStyleConfig.textSize.sp,
                              color: widget.classicalHeader.infoColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(),
            ),
          ]
        : <Widget>[
            Container(
              child: widget.refreshState == RefreshMode.refresh ||
                      widget.refreshState == RefreshMode.armed
                  ? Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(
                          widget.classicalHeader.textColor,
                        ),
                      ),
                    )
                  : widget.refreshState == RefreshMode.refreshed ||
                          widget.refreshState == RefreshMode.done ||
                          (widget.enableInfiniteRefresh &&
                              widget.refreshState != RefreshMode.refreshed) ||
                          widget.noMore
                      ? new Text('1')
                      : Transform.rotate(
                          child: Icon(
                            isReverse ? Icons.arrow_back : Icons.arrow_forward,
                            color: widget.classicalHeader.textColor,
                          ),
                          angle: 2 * pi * _iconRotationValue,
                        ),
            )
          ];
  }
}

/// 首次刷新Header
class FirstRefreshHeader extends Header {
  /// 子组件
  final Widget child;

  FirstRefreshHeader(this.child)
      : super(
          extent: double.infinity,
          triggerDistance: 60.0,
          float: true,
          enableInfiniteRefresh: false,
          enableHapticFeedback: false,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    return (refreshState == RefreshMode.armed ||
                refreshState == RefreshMode.refresh) &&
            pulledExtent >
                refreshTriggerPullDistance + RefreshView.callOverExtent
        ? child
        : Container();
  }
}

/// 滚动焦点回调
/// focus为是否存在焦点(手指按下放开状态)
typedef ScrollFocusCallback = void Function(bool focus);

/// 滚动事件监听器
class ScrollNotificationListener extends StatefulWidget {
  const ScrollNotificationListener({
    Key key,
    @required this.child,
    this.onNotification,
    this.onFocus,
  }) : super(key: key);

  final Widget child;

  // 通知回调
  final NotificationListenerCallback<ScrollNotification> onNotification;

  // 滚动焦点回调
  final ScrollFocusCallback onFocus;

  @override
  ScrollNotificationListenerState createState() {
    return ScrollNotificationListenerState();
  }
}

class ScrollNotificationListenerState
    extends State<ScrollNotificationListener> {
  // 焦点状态
  bool _focusState = false;

  set _focus(bool focus) {
    _focusState = focus;
    if (widget.onFocus != null) widget.onFocus(_focusState);
  }

  // 处理滚动通知
  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      if (notification.dragDetails != null) {
        _focus = true;
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_focusState && notification.dragDetails == null) _focus = false;
    } else if (notification is ScrollEndNotification) {
      if (_focusState) _focus = false;
    }
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _handleScrollNotification(notification);
          return widget.onNotification == null
              ? true
              : widget.onNotification(notification);
        },
        child: widget.child,
      );
}

/// The current state of the refresh control.
///
/// Passed into the [RefreshControlBuilder] builder function so
/// users can show different UI in different modes.
enum RefreshMode {
  /// Initial state, when not being overscrolled into, or after the overscroll
  /// is canceled or after done and the sliver retracted away.
  inactive,

  /// While being overscrolled but not far enough yet to trigger the refresh.
  drag,

  /// Dragged far enough that the onRefresh callback will run and the dragged
  /// displacement is not yet at the final refresh resting state.
  armed,

  /// While the onRefresh task is running.
  refresh,

  /// 刷新完成
  refreshed,

  /// While the indicator is animating away after refreshing.
  done,
}

/// Signature for a builder that can create a different widget to show in the
/// refresh indicator space depending on the current state of the refresh
/// control and the space available.
///
/// The `refreshTriggerPullDistance` and `refreshIndicatorExtent` parameters are
/// the same values passed into the [RefreshViewSliverRefreshControl].
///
/// The `pulledExtent` parameter is the currently available space either from
/// overscrolling or as held by the sliver during refresh.
typedef RefreshControlBuilder = Widget Function(
    BuildContext context,
    RefreshMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
    AxisDirection axisDirection,
    bool float,
    Duration completeDuration,
    bool enableInfiniteRefresh,
    bool success,
    bool noMore);

/// A callback function that's invoked when the [RefreshViewSliverRefreshControl] is
/// pulled a `refreshTriggerPullDistance`. Must return a [Future]. Upon
/// completion of the [Future], the [RefreshViewSliverRefreshControl] enters the
/// [RefreshMode.done] state and will start to go away.

/// 结束刷新
/// success 为是否成功(为false时，noMore无效)
/// noMore 为是否有更多数据
typedef FinishRefresh = void Function({
  bool success,
  bool noMore,
});

/// 绑定刷新指示剂
typedef BindRefreshIndicator = void Function(
    FinishRefresh finishRefresh, VoidCallback resetRefreshState);

/// A sliver widget implementing the iOS-style pull to refresh content control.
///
/// When inserted as the first sliver in a scroll view or behind other slivers
/// that still lets the scrollable overscroll in front of this sliver (such as
/// the [CupertinoSliverNavigationBar], this widget will:
///
///  * Let the user draw inside the overscrolled area via the passed in [builder].
///  * Trigger the provided [onRefresh] function when overscrolled far enough to
///    pass [refreshTriggerPullDistance].
///  * Continue to hold [refreshIndicatorExtent] amount of space for the [builder]
///    to keep drawing inside of as the [Future] returned by [onRefresh] processes.
///  * Scroll away once the [onRefresh] [Future] completes.
///
/// The [builder] function will be informed of the current [RefreshMode]
/// when invoking it, except in the [RefreshMode.inactive] state when
/// no space is available and nothing needs to be built. The [builder] function
/// will otherwise be continuously invoked as the amount of space available
/// changes from overscroll, as the sliver scrolls away after the [onRefresh]
/// task is done, etc.
///
/// Only one refresh can be triggered until the previous refresh has completed
/// and the indicator sliver has retracted at least 90% of the way back.
///
/// Can only be used in downward-scrolling vertical lists that overscrolls. In
/// other words, refreshes can't be triggered with lists using
/// [ClampingScrollPhysics].
///
/// In a typical application, this sliver should be inserted between the app bar
/// sliver such as [CupertinoSliverNavigationBar] and your main scrollable
/// content's sliver.
///
/// See also:
///
///  * [CustomScrollView], a typical sliver holding scroll view this control
///    should go into.
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/refresh-content-controls/>
///  * [RefreshIndicator], a Material Design version of the pull-to-refresh
///    paradigm. This widget works differently than [RefreshIndicator] because
///    instead of being an overlay on top of the scrollable, the
///    [RefreshViewSliverRefreshControl] is part of the scrollable and actively occupies
///    scrollable space.
class RefreshViewSliverRefreshControl extends StatefulWidget {
  /// Create a new refresh control for inserting into a list of slivers.
  ///
  /// The [refreshTriggerPullDistance] and [refreshIndicatorExtent] arguments
  /// must not be null and must be >= 0.
  ///
  /// The [builder] argument may be null, in which case no indicator UI will be
  /// shown but the [onRefresh] will still be invoked. By default, [builder]
  /// shows a [CupertinoActivityIndicator].
  ///
  /// The [onRefresh] argument will be called when pulled far enough to trigger
  /// a refresh.
  const RefreshViewSliverRefreshControl({
    Key key,
    this.refreshTriggerPullDistance = _defaultRefreshTriggerPullDistance,
    this.refreshIndicatorExtent = _defaultRefreshIndicatorExtent,
    @required this.builder,
    this.completeDuration,
    this.onRefresh,
    this.focusNotifier,
    this.taskNotifier,
    this.callRefreshNotifier,
    this.taskIndependence,
    this.bindRefreshIndicator,
    this.enableControlFinishRefresh = false,
    this.enableInfiniteRefresh = false,
    this.enableHapticFeedback = false,
    this.headerFloat = false,
  })  : assert(refreshTriggerPullDistance != null),
        assert(refreshTriggerPullDistance > 0.0),
        assert(refreshIndicatorExtent != null),
        assert(refreshIndicatorExtent >= 0.0),
        assert(
            headerFloat || refreshTriggerPullDistance >= refreshIndicatorExtent,
            'The refresh indicator cannot take more space in its final state '
            'than the amount initially created by overscrolling.'),
        super(key: key);

  /// The amount of overscroll the scrollable must be dragged to trigger a reload.
  ///
  /// Must not be null, must be larger than 0.0 and larger than
  /// [refreshIndicatorExtent]. Defaults to 100px when not specified.
  ///
  /// When overscrolled past this distance, [onRefresh] will be called if not
  /// null and the [builder] will build in the [RefreshMode.armed] state.
  final double refreshTriggerPullDistance;

  /// The amount of space the refresh indicator sliver will keep holding while
  /// [onRefresh]'s [Future] is still running.
  ///
  /// Must not be null and must be positive, but can be 0.0, in which case the
  /// sliver will start retracting back to 0.0 as soon as the refresh is started.
  /// Defaults to 60px when not specified.
  ///
  /// Must be smaller than [refreshTriggerPullDistance], since the sliver
  /// shouldn't grow further after triggering the refresh.
  final double refreshIndicatorExtent;

  /// A builder that's called as this sliver's size changes, and as the state
  /// changes.
  ///
  /// A default simple Twitter-style pull-to-refresh indicator is provided if
  /// not specified.
  ///
  /// Can be set to null, in which case nothing will be drawn in the overscrolled
  /// space.
  ///
  /// Will not be called when the available space is zero such as before any
  /// overscroll.
  final RefreshControlBuilder builder;

  /// Callback invoked when pulled by [refreshTriggerPullDistance].
  ///
  /// If provided, must return a [Future] which will keep the indicator in the
  /// [RefreshMode.refresh] state until the [Future] completes.
  ///
  /// Can be null, in which case a single frame of [RefreshMode.armed]
  /// state will be drawn before going immediately to the [RefreshMode.done]
  /// where the sliver will start retracting.
  final OnRefreshCallback onRefresh;

  /// 完成延时
  final Duration completeDuration;

  /// 绑定刷新指示器
  final BindRefreshIndicator bindRefreshIndicator;

  /// 是否开启控制结束
  final bool enableControlFinishRefresh;

  /// 是否开启无限刷新
  final bool enableInfiniteRefresh;

  /// 开启震动反馈
  final bool enableHapticFeedback;

  /// 滚动状态
  final ValueNotifier<bool> focusNotifier;

  /// 触发刷新状态
  final ValueNotifier<bool> callRefreshNotifier;

  /// 任务状态
  final ValueNotifier<TaskState> taskNotifier;

  /// 是否任务独立
  final bool taskIndependence;

  /// Header浮动
  final bool headerFloat;

  static const double _defaultRefreshTriggerPullDistance = 100.0;
  static const double _defaultRefreshIndicatorExtent = 60.0;

  /// Retrieve the current state of the RefreshViewSliverRefreshControl. The same as the
  /// state that gets passed into the [builder] function. Used for testing.
  /*@visibleForTesting
  static RefreshMode state(BuildContext context) {
    final _RefreshViewSliverRefreshControlState state = context
        .findAncestorStateOfType<_RefreshViewSliverRefreshControlState>();
    return state.refreshState;
  }*/

  @override
  _RefreshViewSliverRefreshControlState createState() =>
      _RefreshViewSliverRefreshControlState();
}

class _RefreshViewSliverRefreshControlState
    extends State<RefreshViewSliverRefreshControl> {
  // Reset the state from done to inactive when only this fraction of the
  // original `refreshTriggerPullDistance` is left.
  static const double _inactiveResetOverscrollFraction = 0.1;

  RefreshMode refreshState;

  // [Future] returned by the widget's `onRefresh`.
  Future<void> _refreshTask;

  Future<void> get refreshTask => _refreshTask;

  bool get hasTask {
    return widget.taskIndependence
        ? _refreshTask != null
        : widget.taskNotifier.value.loading ||
            widget.taskNotifier.value.refreshing;
  }

  set refreshTask(Future<void> task) {
    _refreshTask = task;
    if (!widget.taskIndependence) {
      widget.taskNotifier.value =
          widget.taskNotifier.value.copy(refreshing: task != null);
    }
  }

  // The amount of space available from the inner indicator box's perspective.
  //
  // The value is the sum of the sliver's layout extent and the overscroll
  // (which partially gets transferred into the layout extent when the refresh
  // triggers).
  //
  // The value of latestIndicatorBoxExtent doesn't change when the sliver scrolls
  // away without retracting; it is independent from the sliver's scrollOffset.
  double latestIndicatorBoxExtent = 0.0;
  bool hasSliverLayoutExtent = false;

  // 滚动焦点
  bool get _focus => widget.focusNotifier.value;

  // 刷新完成
  bool _success;

  // 没有更多数据
  bool _noMore;

  // 列表方向
  ValueNotifier<AxisDirection> _axisDirectionNotifier;

  // 初始化
  @override
  void initState() {
    super.initState();
    refreshState = RefreshMode.inactive;
    _axisDirectionNotifier = ValueNotifier<AxisDirection>(AxisDirection.down);
    // 绑定刷新指示器
    if (widget.bindRefreshIndicator != null) {
      widget.bindRefreshIndicator(finishRefresh, resetRefreshState);
    }
  }

  // 销毁
  @override
  void dispose() {
    super.dispose();
  }

  // 完成刷新
  void finishRefresh({
    bool success,
    bool noMore,
  }) {
    _success = success;
    _noMore = _success == false ? false : noMore;
    if (widget.enableControlFinishRefresh && refreshTask != null) {
      if (widget.enableInfiniteRefresh) {
        refreshState = RefreshMode.inactive;
      }
      setState(() => refreshTask = null);
      refreshState = transitionNextState();
    }
  }

  // 恢复状态
  void resetRefreshState() {
    if (mounted) {
      setState(() {
        _success = true;
        _noMore = false;
        refreshState = RefreshMode.inactive;
        hasSliverLayoutExtent = false;
      });
    }
  }

  // 无限刷新
  void _infiniteRefresh() {
    if (!hasTask &&
        widget.enableInfiniteRefresh &&
        _noMore != true &&
        !widget.callRefreshNotifier.value) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
        refreshState = RefreshMode.refresh;
        refreshTask = widget.onRefresh()
          ..then((_) {
            if (mounted && !widget.enableControlFinishRefresh) {
              refreshState = RefreshMode.refresh;
              setState(() => refreshTask = null);
              // Trigger one more transition because by this time, BoxConstraint's
              // maxHeight might already be resting at 0 in which case no
              // calls to [transitionNextState] will occur anymore and the
              // state may be stuck in a non-inactive state.
              refreshState = transitionNextState();
            }
          });
        setState(() => hasSliverLayoutExtent = true);
      });
    }
  }

  // A state machine transition calculator. Multiple states can be transitioned
  // through per single call.
  RefreshMode transitionNextState() {
    RefreshMode nextState;

    // 判断是否没有更多
    if (_noMore == true && widget.enableInfiniteRefresh) {
      return refreshState;
    } else if (_noMore == true &&
        refreshState != RefreshMode.refresh &&
        refreshState != RefreshMode.refreshed &&
        refreshState != RefreshMode.done) {
      return refreshState;
    } else if (widget.enableInfiniteRefresh &&
        refreshState == RefreshMode.done) {
      return RefreshMode.inactive;
    }

    // 结束
    void goToDone() {
      nextState = RefreshMode.done;
      refreshState = RefreshMode.done;
      // Either schedule the RenderSliver to re-layout on the next frame
      // when not currently in a frame or schedule it on the next frame.
      if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
        setState(() => hasSliverLayoutExtent = false);
      } else {
        SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
          setState(() => hasSliverLayoutExtent = false);
        });
      }
    }

    // 完成
    RefreshMode goToFinish() {
      // 判断刷新完成
      RefreshMode state = RefreshMode.refreshed;
      // 添加延时
      if (widget.completeDuration == null || widget.enableInfiniteRefresh) {
        goToDone();
        return null;
      } else {
        Future.delayed(widget.completeDuration, () {
          if (mounted) {
            goToDone();
          }
        });
        return state;
      }
    }

    switch (refreshState) {
      case RefreshMode.inactive:
        if (latestIndicatorBoxExtent <= 0 ||
            (!_focus && !widget.callRefreshNotifier.value)) {
          return RefreshMode.inactive;
        } else {
          if (widget.callRefreshNotifier.value) {
            widget.callRefreshNotifier.value = false;
          }
          nextState = RefreshMode.drag;
        }
        continue drag;
      drag:
      case RefreshMode.drag:
        if (latestIndicatorBoxExtent == 0) {
          return RefreshMode.inactive;
        } else if (latestIndicatorBoxExtent <=
            widget.refreshTriggerPullDistance) {
          // 如果未触发刷新则取消固定高度
          if (hasSliverLayoutExtent && !hasTask) {
            SchedulerBinding.instance
                .addPostFrameCallback((Duration timestamp) {
              setState(() => hasSliverLayoutExtent = false);
            });
          }
          return RefreshMode.drag;
        } else {
          // 提前固定高度，防止列表回弹
          SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
            if (!hasSliverLayoutExtent) {
              setState(() => hasSliverLayoutExtent = true);
            }
          });
          if (widget.onRefresh != null && !hasTask) {
            if (!_focus) {
              if (widget.callRefreshNotifier.value) {
                widget.callRefreshNotifier.value = false;
              }
              if (widget.enableHapticFeedback) {
                HapticFeedback.mediumImpact();
              }
              // 触发刷新任务
              SchedulerBinding.instance
                  .addPostFrameCallback((Duration timestamp) {
                refreshTask = widget.onRefresh()
                  ..then((_) {
                    if (mounted && !widget.enableControlFinishRefresh) {
                      if (widget.enableInfiniteRefresh) {
                        refreshState = RefreshMode.inactive;
                      }
                      setState(() => refreshTask = null);
                      if (!widget.enableInfiniteRefresh)
                        refreshState = transitionNextState();
                    }
                  });
              });
              return RefreshMode.armed;
            }
            return RefreshMode.drag;
          }
          return RefreshMode.drag;
        }
        // Don't continue here. We can never possibly call onRefresh and
        // progress to the next state in one [computeNextState] call.
        break;
      case RefreshMode.armed:
        if (refreshState == RefreshMode.armed && !hasTask) {
          // 完成
          var state = goToFinish();
          if (state != null) return state;
          continue done;
        }

        if (latestIndicatorBoxExtent != widget.refreshIndicatorExtent) {
          return RefreshMode.armed;
        } else {
          nextState = RefreshMode.refresh;
        }
        continue refresh;
      refresh:
      case RefreshMode.refresh:
        if (refreshTask != null) {
          return RefreshMode.refresh;
        } else {
          // 完成
          var state = goToFinish();
          if (state != null) return state;
        }
        continue done;
      done:
      case RefreshMode.done:
        // Let the transition back to inactive trigger before strictly going
        // to 0.0 since the last bit of the animation can take some time and
        // can feel sluggish if not going all the way back to 0.0 prevented
        // a subsequent pull-to-refresh from starting.
        if (latestIndicatorBoxExtent >
            widget.refreshTriggerPullDistance *
                _inactiveResetOverscrollFraction) {
          return RefreshMode.done;
        } else {
          nextState = RefreshMode.inactive;
        }
        break;
      case RefreshMode.refreshed:
        nextState = refreshState;
        break;
      default:
        break;
    }

    return nextState;
  }

  @override
  Widget build(BuildContext context) {
    return _RefreshViewSliverRefresh(
      refreshIndicatorLayoutExtent: widget.refreshIndicatorExtent,
      hasLayoutExtent: hasSliverLayoutExtent,
      enableInfiniteRefresh: widget.enableInfiniteRefresh,
      infiniteRefresh: _infiniteRefresh,
      headerFloat: widget.headerFloat,
      axisDirectionNotifier: _axisDirectionNotifier,
      // A LayoutBuilder lets the sliver's layout changes be fed back out to
      // its owner to trigger state changes.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 判断是否有加载任务
          if (!widget.taskIndependence && widget.taskNotifier.value.loading) {
            return SizedBox();
          }
          // 是否为垂直方向
          bool isVertical =
              _axisDirectionNotifier.value == AxisDirection.down ||
                  _axisDirectionNotifier.value == AxisDirection.up;
          latestIndicatorBoxExtent =
              isVertical ? constraints.maxHeight : constraints.maxWidth;
          refreshState = transitionNextState();
          if (widget.builder != null && latestIndicatorBoxExtent >= 0) {
            return widget.builder(
              context,
              refreshState,
              latestIndicatorBoxExtent,
              widget.refreshTriggerPullDistance,
              widget.refreshIndicatorExtent,
              _axisDirectionNotifier.value,
              widget.headerFloat,
              widget.completeDuration,
              widget.enableInfiniteRefresh,
              _success ?? true,
              _noMore ?? false,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _RefreshViewSliverRefresh extends SingleChildRenderObjectWidget {
  const _RefreshViewSliverRefresh({
    Key key,
    this.refreshIndicatorLayoutExtent = 0.0,
    this.hasLayoutExtent = false,
    this.enableInfiniteRefresh = false,
    this.headerFloat = false,
    this.axisDirectionNotifier,
    @required this.infiniteRefresh,
    Widget child,
  })  : assert(refreshIndicatorLayoutExtent != null),
        assert(refreshIndicatorLayoutExtent >= 0.0),
        assert(hasLayoutExtent != null),
        super(key: key, child: child);

  // The amount of space the indicator should occupy in the sliver in a
  // resting state when in the refreshing mode.
  final double refreshIndicatorLayoutExtent;

  // _RenderRefreshViewSliverRefresh will paint the child in the available
  // space either way but this instructs the _RenderRefreshViewSliverRefresh
  // on whether to also occupy any layoutExtent space or not.
  final bool hasLayoutExtent;

  /// 是否开启无限刷新
  final bool enableInfiniteRefresh;

  /// 无限加载回调
  final VoidCallback infiniteRefresh;

  /// Header浮动
  final bool headerFloat;

  /// 列表方向
  final ValueNotifier<AxisDirection> axisDirectionNotifier;

  @override
  _RenderRefreshViewSliverRefresh createRenderObject(BuildContext context) {
    return _RenderRefreshViewSliverRefresh(
      refreshIndicatorExtent: refreshIndicatorLayoutExtent,
      hasLayoutExtent: hasLayoutExtent,
      enableInfiniteRefresh: enableInfiniteRefresh,
      infiniteRefresh: infiniteRefresh,
      headerFloat: headerFloat,
      axisDirectionNotifier: axisDirectionNotifier,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant _RenderRefreshViewSliverRefresh renderObject) {
    renderObject
      ..refreshIndicatorLayoutExtent = refreshIndicatorLayoutExtent
      ..hasLayoutExtent = hasLayoutExtent
      ..enableInfiniteRefresh = enableInfiniteRefresh
      ..headerFloat = headerFloat;
  }
}

// RenderSliver object that gives its child RenderBox object space to paint
// in the overscrolled gap and may or may not hold that overscrolled gap
// around the RenderBox depending on whether [layoutExtent] is set.
//
// The [layoutExtentOffsetCompensation] field keeps internal accounting to
// prevent scroll position jumps as the [layoutExtent] is set and unset.
class _RenderRefreshViewSliverRefresh extends RenderSliverSingleBoxAdapter {
  _RenderRefreshViewSliverRefresh({
    @required double refreshIndicatorExtent,
    @required bool hasLayoutExtent,
    @required bool enableInfiniteRefresh,
    @required this.infiniteRefresh,
    @required bool headerFloat,
    @required this.axisDirectionNotifier,
    RenderBox child,
  })  : assert(refreshIndicatorExtent != null),
        assert(refreshIndicatorExtent >= 0.0),
        assert(hasLayoutExtent != null),
        _refreshIndicatorExtent = refreshIndicatorExtent,
        _enableInfiniteRefresh = enableInfiniteRefresh,
        _hasLayoutExtent = hasLayoutExtent,
        _headerFloat = headerFloat {
    this.child = child;
  }

  // The amount of layout space the indicator should occupy in the sliver in a
  // resting state when in the refreshing mode.
  double get refreshIndicatorLayoutExtent => _refreshIndicatorExtent;
  double _refreshIndicatorExtent;

  set refreshIndicatorLayoutExtent(double value) {
    assert(value != null);
    assert(value >= 0.0);
    if (value == _refreshIndicatorExtent) return;
    _refreshIndicatorExtent = value;
    markNeedsLayout();
  }

  /// 列表方向
  final ValueNotifier<AxisDirection> axisDirectionNotifier;

  // The child box will be laid out and painted in the available space either
  // way but this determines whether to also occupy any
  // [SliverGeometry.layoutExtent] space or not.
  bool get hasLayoutExtent => _hasLayoutExtent;
  bool _hasLayoutExtent;

  set hasLayoutExtent(bool value) {
    assert(value != null);
    if (value == _hasLayoutExtent) return;
    _hasLayoutExtent = value;
    markNeedsLayout();
  }

  /// 是否开启无限刷新
  bool get enableInfiniteRefresh => _enableInfiniteRefresh;
  bool _enableInfiniteRefresh;

  set enableInfiniteRefresh(bool value) {
    assert(value != null);
    if (value == _enableInfiniteRefresh) return;
    _enableInfiniteRefresh = value;
    markNeedsLayout();
  }

  /// Header是否浮动
  bool get headerFloat => _headerFloat;
  bool _headerFloat;

  set headerFloat(bool value) {
    assert(value != null);
    if (value == _headerFloat) return;
    _headerFloat = value;
    markNeedsLayout();
  }

  /// 无限加载回调
  final VoidCallback infiniteRefresh;

  // 触发无限刷新
  bool _triggerInfiniteRefresh = false;

  // 获取子组件大小
  double get childSize =>
      constraints.axis == Axis.vertical ? child.size.height : child.size.width;

  // This keeps track of the previously applied scroll offsets to the scrollable
  // so that when [refreshIndicatorLayoutExtent] or [hasLayoutExtent] changes,
  // the appropriate delta can be applied to keep everything in the same place
  // visually.
  double layoutExtentOffsetCompensation = 0.0;

  @override
  double get centerOffsetAdjustment {
    // Header浮动时去掉越界
    if (headerFloat) {
      final RenderViewportBase renderViewport = parent;
      return max(0.0, -renderViewport.offset.pixels);
    }
    return super.centerOffsetAdjustment;
  }

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    // Header浮动时保持刷新
    if (headerFloat) {
      final RenderViewportBase renderViewport = parent;
      super.layout(
          (constraints as SliverConstraints)
              .copyWith(overlap: min(0.0, renderViewport.offset.pixels)),
          parentUsesSize: true);
    } else {
      super.layout(constraints, parentUsesSize: parentUsesSize);
    }
  }

  @override
  void performLayout() {
    // Only pulling to refresh from the top is currently supported.
    // 注释以支持reverse
    // assert(constraints.axisDirection == AxisDirection.down);
    axisDirectionNotifier.value = constraints.axisDirection;
    assert(constraints.growthDirection == GrowthDirection.forward);

    // 判断是否触发无限刷新
    if (enableInfiniteRefresh &&
        constraints.scrollOffset < _refreshIndicatorExtent &&
        constraints.userScrollDirection != ScrollDirection.idle) {
      if (!_triggerInfiniteRefresh) {
        _triggerInfiniteRefresh = true;
        infiniteRefresh();
      }
    } else {
      if (constraints.scrollOffset > _refreshIndicatorExtent) {
        if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
          _triggerInfiniteRefresh = false;
        } else {
          SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
            _triggerInfiniteRefresh = false;
          });
        }
      }
    }

    // The new layout extent this sliver should now have.
    final double layoutExtent =
        (_hasLayoutExtent || enableInfiniteRefresh ? 1.0 : 0.0) *
            _refreshIndicatorExtent;
    // If the new layoutExtent instructive changed, the SliverGeometry's
    // layoutExtent will take that value (on the next performLayout run). Shift
    // the scroll offset first so it doesn't make the scroll position suddenly jump.
    // 如果Header浮动则不用过渡
    if (!headerFloat) {
      if (layoutExtent != layoutExtentOffsetCompensation) {
        geometry = SliverGeometry(
          scrollOffsetCorrection: layoutExtent - layoutExtentOffsetCompensation,
        );
        layoutExtentOffsetCompensation = layoutExtent;
        // Return so we don't have to do temporary accounting and adjusting the
        // child's constraints accounting for this one transient frame using a
        // combination of existing layout extent, new layout extent change and
        // the overlap.
        return;
      }
    }
    final bool active = constraints.overlap < 0.0 || layoutExtent > 0.0;
    final double overscrolledExtent =
        constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;
    // Layout the child giving it the space of the currently dragged overscroll
    // which may or may not include a sliver layout extent space that it will
    // keep after the user lets go during the refresh process.
    // Header浮动时不用layoutExtent,不然会有跳动
    if (headerFloat) {
      child.layout(
        constraints.asBoxConstraints(
          maxExtent: _hasLayoutExtent
              ? overscrolledExtent > _refreshIndicatorExtent
                  ? overscrolledExtent
                  // 如果为double.infinity则占满列表
                  : _refreshIndicatorExtent == double.infinity
                      ? constraints.viewportMainAxisExtent
                      : _refreshIndicatorExtent
              : overscrolledExtent,
        ),
        parentUsesSize: true,
      );
    } else {
      child.layout(
        constraints.asBoxConstraints(
          maxExtent: layoutExtent
              // Plus only the overscrolled portion immediately preceding this
              // sliver.
              +
              overscrolledExtent,
        ),
        parentUsesSize: true,
      );
    }
    if (active) {
      // 判断Header是否浮动
      if (headerFloat) {
        geometry = SliverGeometry(
          scrollExtent: 0.0,
          paintOrigin: 0.0,
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: max(-constraints.scrollOffset, 0.0),
          visible: true,
          hasVisualOverflow: true,
        );
      } else {
        geometry = SliverGeometry(
          scrollExtent: layoutExtent,
          paintOrigin: -overscrolledExtent - constraints.scrollOffset,
          paintExtent: min(
              max(
                // Check child size (which can come from overscroll) because
                // layoutExtent may be zero. Check layoutExtent also since even
                // with a layoutExtent, the indicator builder may decide to not
                // build anything.
                max(childSize, layoutExtent) - constraints.scrollOffset,
                0.0,
              ),
              constraints.remainingPaintExtent),
          maxPaintExtent: max(
            max(childSize, layoutExtent) - constraints.scrollOffset,
            0.0,
          ),
          layoutExtent: max(layoutExtent - constraints.scrollOffset, 0.0),
        );
      }
    } else {
      // If we never started overscrolling, return no geometry.
      geometry = SliverGeometry.zero;
    }
  }

  @override
  void paint(PaintingContext paintContext, Offset offset) {
    if (constraints.overlap < 0.0 || constraints.scrollOffset + childSize > 0) {
      paintContext.paintChild(child, offset);
    }
  }

  // Nothing special done here because this sliver always paints its child
  // exactly between paintOrigin and paintExtent.
  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}
}

/// Header
abstract class Footer {
  /// Footer容器高度
  final double extent;

  /// 高度(超过这个高度触发加载)
  final double triggerDistance;
  @Deprecated('目前还没有找到方案,设置无效')
  final bool float;

  // 完成延时
  final Duration completeDuration;

  /// 是否开启无限加载
  final bool enableInfiniteLoad;

  /// 开启震动反馈
  final bool enableHapticFeedback;

  Footer({
    this.extent = 60.0,
    this.triggerDistance = 70.0,
    this.float = false,
    this.completeDuration,
    this.enableInfiniteLoad = true,
    this.enableHapticFeedback = false,
  });

  // 构造器
  Widget builder(
      BuildContext context,
      RefreshView easyRefresh,
      ValueNotifier<bool> focusNotifier,
      ValueNotifier<TaskState> taskNotifier,
      ValueNotifier<bool> callLoadNotifier) {
    return RefreshViewSliverLoadControl(
      loadIndicatorExtent: extent,
      loadTriggerPullDistance: triggerDistance,
      builder: contentBuilder,
      completeDuration: completeDuration,
      onLoad: easyRefresh.onLoad,
      focusNotifier: focusNotifier,
      taskNotifier: taskNotifier,
      callLoadNotifier: callLoadNotifier,
      taskIndependence: easyRefresh.taskIndependence,
      enableControlFinishLoad: easyRefresh.enableControlFinishLoad,
      enableInfiniteLoad: enableInfiniteLoad,
      //enableInfiniteLoad: enableInfiniteLoad && !float,
      enableHapticFeedback: enableHapticFeedback,
      //footerFloat: float,
      bindLoadIndicator: (finishLoad, resetLoadState) {
        if (easyRefresh.controller != null) {
          easyRefresh.controller.finishLoadCallBack = finishLoad;
          easyRefresh.controller.resetLoadStateCallBack = resetLoadState;
        }
      },
    );
  }

  // Header构造器
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore);
}

/// 通知器Footer
class NotificationFooter extends Footer {
  /// Footer
  final Footer footer;

  /// 通知器
  final LinkFooterNotifier notifier;

  NotificationFooter({
    @required this.footer,
    this.notifier,
  })  : assert(
          footer != null,
          'A non-null Footer must be provided to a NotifierFooter.',
        ),
        super(
          extent: footer.extent,
          triggerDistance: footer.triggerDistance,
          completeDuration: footer.completeDuration,
          enableInfiniteLoad: footer.enableInfiniteLoad,
          enableHapticFeedback: footer.enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    // 发起通知
    this.notifier?.contentBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);
    return footer.contentBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);
  }
}

typedef LoadControlBuilder = Widget Function(
    BuildContext context,
    LoadMode loadState,
    double pulledExtent,
    double loadTriggerPullDistance,
    double loadIndicatorExtent,
    AxisDirection axisDirection,
    bool float,
    Duration completeDuration,
    bool enableInfiniteLoad,
    bool success,
    bool noMore);

/// 通用Footer构造器
class CustomFooter extends Footer {
  /// Footer构造器
  final LoadControlBuilder footerBuilder;

  CustomFooter({
    extent = 60.0,
    triggerDistance = 70.0,
    float = false,
    completeDuration,
    enableInfiniteLoad = false,
    enableHapticFeedback = false,
    @required this.footerBuilder,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          completeDuration: completeDuration,
          enableInfiniteLoad: enableInfiniteLoad,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return footerBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);
  }
}

/// 链接通知器
class LinkFooterNotifier extends ChangeNotifier {
  BuildContext context;
  LoadMode loadState = LoadMode.inactive;
  double pulledExtent = 0.0;
  double loadTriggerPullDistance;
  double loadIndicatorExtent;
  AxisDirection axisDirection;
  bool float;
  Duration completeDuration;
  bool enableInfiniteLoad;
  bool success = true;
  bool noMore = false;

  void contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    this.context = context;
    this.loadState = loadState;
    this.pulledExtent = pulledExtent;
    this.loadTriggerPullDistance = loadTriggerPullDistance;
    this.loadIndicatorExtent = loadIndicatorExtent;
    this.axisDirection = axisDirection;
    this.float = float;
    this.completeDuration = completeDuration;
    this.enableInfiniteLoad = enableInfiniteLoad;
    this.success = success;
    this.noMore = noMore;
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      notifyListeners();
    });
  }
}

/// 经典Footer
class ClassicalFooter extends Footer {
  /// Key
  final Key key;

  /// 方位
  final AlignmentGeometry alignment;

  /// 提示加载文字
  final String loadText;

  /// 准备加载文字
  final String loadReadyText;

  /// 正在加载文字
  final String loadingText;

  /// 加载完成文字
  final String loadedText;

  /// 加载失败文字
  final String loadFailedText;

  /// 没有更多文字
  final String noMoreText;

  /// 显示额外信息(默认为时间)
  final bool showInfo;

  /// 更多信息
  final String infoText;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  ClassicalFooter({
    double extent = 60.0,
    double triggerDistance = 70.0,
    bool float = false,
    Duration completeDuration = const Duration(seconds: 1),
    bool enableInfiniteLoad = true,
    bool enableHapticFeedback = true,
    this.key,
    this.alignment,
    this.loadText,
    this.loadReadyText,
    this.loadingText,
    this.loadedText,
    this.loadFailedText,
    this.noMoreText,
    this.showInfo: true,
    this.infoText,
    this.bgColor: Colors.transparent,
    this.textColor: Colors.black,
    this.infoColor: Colors.teal,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: completeDuration,
          enableInfiniteLoad: enableInfiniteLoad,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return ClassicalFooterWidget(
      key: key,
      classicalFooter: this,
      loadState: loadState,
      pulledExtent: pulledExtent,
      loadTriggerPullDistance: loadTriggerPullDistance,
      loadIndicatorExtent: loadIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteLoad: enableInfiniteLoad,
      success: success,
      noMore: noMore,
    );
  }
}

enum LoadMode {
  /// Initial state, when not being overscrolled into, or after the overscroll
  /// is canceled or after done and the sliver retracted away.
  inactive,

  /// While being overscrolled but not far enough yet to trigger the refresh.
  drag,

  /// Dragged far enough that the onLoad callback will run and the dragged
  /// displacement is not yet at the final refresh resting state.
  armed,

  /// While the onLoad task is running.
  load,

  /// 刷新完成
  loaded,

  /// While the indicator is animating away after refreshing.
  done,
}

/// 经典Footer组件
class ClassicalFooterWidget extends StatefulWidget {
  final ClassicalFooter classicalFooter;
  final LoadMode loadState;
  final double pulledExtent;
  final double loadTriggerPullDistance;
  final double loadIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration completeDuration;
  final bool enableInfiniteLoad;
  final bool success;
  final bool noMore;

  ClassicalFooterWidget(
      {Key key,
      this.loadState,
      this.classicalFooter,
      this.pulledExtent,
      this.loadTriggerPullDistance,
      this.loadIndicatorExtent,
      this.axisDirection,
      this.float,
      this.completeDuration,
      this.enableInfiniteLoad,
      this.success,
      this.noMore})
      : super(key: key);

  @override
  ClassicalFooterWidgetState createState() => ClassicalFooterWidgetState();
}

class ClassicalFooterWidgetState extends State<ClassicalFooterWidget>
    with TickerProviderStateMixin<ClassicalFooterWidget> {
  // 是否到达触发加载距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
    }
    _overTriggerDistance = over;
  }

  /// 文本
  String get _loadText {
    return widget.classicalFooter.loadText ?? '上滑加载';
  }

  String get _loadReadyText {
    return widget.classicalFooter.loadReadyText ?? '松开加载';
  }

  String get _loadingText {
    return widget.classicalFooter.loadingText ?? '加载中';
  }

  String get _loadedText {
    return widget.classicalFooter.loadedText ?? '松开加载';
  }

  String get _loadFailedText {
    return widget.classicalFooter.loadFailedText ?? '页面加载失败';
  }

  /// 没有更多文字
  String get _noMoreText {
    return widget.classicalFooter.noMoreText ?? '暂无更多';
  }

  String get _infoText {
    return widget.classicalFooter.infoText ?? '';
  }

  // 动画
  AnimationController _readyController;
  Animation<double> _readyAnimation;
  AnimationController _restoreController;
  Animation<double> _restoreAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 显示文字
  String get _showText {
    if (widget.noMore) return _noMoreText;
    if (widget.enableInfiniteLoad) {
      if (widget.loadState == LoadMode.loaded ||
          widget.loadState == LoadMode.inactive ||
          widget.loadState == LoadMode.drag) {
        return _finishedText;
      } else {
        return _loadingText;
      }
    }
    switch (widget.loadState) {
      case LoadMode.load:
        return _loadingText;
      case LoadMode.armed:
        return _loadingText;
      case LoadMode.loaded:
        return _finishedText;
      case LoadMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return _loadReadyText;
        } else {
          return _loadText;
        }
    }
  }

  // 加载结束文字
  String get _finishedText {
    if (!widget.success) return _loadFailedText;
    if (widget.noMore) return _noMoreText;
    return _loadedText;
  }

  // 加载结束图标
  IconData get _finishedIconNew {
    if (!widget.success) return Icons.error_outline;
    if (widget.noMore) return Icons.hourglass_empty;
    return Icons.all_inclusive;
  }

  // 更新时间
  DateTime _dateTime;

  // 获取更多信息
  String get _infoTextStr {
    if (widget.loadState == LoadMode.loaded) {
      _dateTime = DateTime.now();
    }
    String fillChar = _dateTime.minute < 10 ? "0" : "";
    return _infoText.replaceAll(
        "%T", "${_dateTime.hour}:$fillChar${_dateTime.minute}");
  }

  @override
  void initState() {
    super.initState();
    // 初始化时间
    _dateTime = DateTime.now();
    // 初始化动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
        new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
          ..addListener(() {
            setState(() {
              if (_restoreAnimation.status != AnimationStatus.dismissed) {
                _iconRotationValue = _restoreAnimation.value;
              }
            });
          });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 是否为垂直方向
    bool isVertical = widget.axisDirection == AxisDirection.down ||
        widget.axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = widget.axisDirection == AxisDirection.up ||
        widget.axisDirection == AxisDirection.left;
    // 是否到达触发加载距离
    overTriggerDistance = widget.loadState != LoadMode.inactive &&
        widget.pulledExtent >= widget.loadTriggerPullDistance;
    return Stack(
      children: <Widget>[
        Positioned(
          top: !isVertical
              ? 0.0
              : !isReverse
                  ? 0.0
                  : null,
          bottom: !isVertical
              ? 0.0
              : isReverse
                  ? 0.0
                  : null,
          left: isVertical
              ? 0.0
              : !isReverse
                  ? 0.0
                  : null,
          right: isVertical
              ? 0.0
              : isReverse
                  ? 0.0
                  : null,
          child: Container(
            alignment: widget.classicalFooter.alignment ?? isVertical
                ? !isReverse
                    ? Alignment.topCenter
                    : Alignment.bottomCenter
                : isReverse
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            width: !isVertical
                ? widget.loadIndicatorExtent > widget.pulledExtent
                    ? widget.loadIndicatorExtent
                    : widget.pulledExtent
                : double.infinity,
            height: isVertical
                ? widget.loadIndicatorExtent > widget.pulledExtent
                    ? widget.loadIndicatorExtent
                    : widget.pulledExtent
                : double.infinity,
            color: widget.classicalFooter.bgColor,
            child: SizedBox(
              height: isVertical ? 60 : double.infinity,
              width: !isVertical ? widget.loadIndicatorExtent : double.infinity,
              child: isVertical
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(isVertical, isReverse),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  List<Widget> _buildContent(bool isVertical, bool isReverse) {
    return isVertical
        ? <Widget>[
            Icon(Icons.all_inclusive, color: AppStyleConfig.themColor),
            Container(width: 12, height: 12),
            Text(
              '加载更多',
              style: TextStyle(color: AppStyleConfig.themColor),
            ),
          ]
        : <Widget>[
            Container(
              child: widget.loadState == LoadMode.load ||
                      widget.loadState == LoadMode.armed
                  ? Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(
                          widget.classicalFooter.textColor,
                        ),
                      ),
                    )
                  : widget.loadState == LoadMode.loaded ||
                          widget.loadState == LoadMode.done ||
                          (widget.enableInfiniteLoad &&
                              widget.loadState != LoadMode.loaded) ||
                          widget.noMore
                      ? Icon(
                          _finishedIconNew,
                          color: widget.classicalFooter.textColor,
                        )
                      : Transform.rotate(
                          child: Icon(
                            !isReverse ? Icons.arrow_back : Icons.arrow_forward,
                            color: widget.classicalFooter.textColor,
                          ),
                          angle: 2 * pi * _iconRotationValue,
                        ),
            ),
          ];
  }
}

class _RefreshViewSliverLoad extends SingleChildRenderObjectWidget {
  const _RefreshViewSliverLoad({
    Key key,
    this.loadIndicatorLayoutExtent = 0.0,
    this.hasLayoutExtent = false,
    this.enableInfiniteLoad = true,
    this.footerFloat = false,
    this.axisDirectionNotifier,
    @required this.infiniteLoad,
    @required this.extraExtentNotifier,
    Widget child,
  })  : assert(loadIndicatorLayoutExtent != null),
        assert(loadIndicatorLayoutExtent >= 0.0),
        assert(hasLayoutExtent != null),
        super(key: key, child: child);

  // The amount of space the indicator should occupy in the sliver in a
  // resting state when in the refreshing mode.
  final double loadIndicatorLayoutExtent;

  // _RenderRefreshViewSliverLoad will paint the child in the available
  // space either way but this instructs the _RenderRefreshViewSliverLoad
  // on whether to also occupy any layoutExtent space or not.
  final bool hasLayoutExtent;

  /// 是否开启无限加载
  final bool enableInfiniteLoad;

  /// 无限加载回调
  final VoidCallback infiniteLoad;

  /// Footer浮动
  final bool footerFloat;

  /// 列表方向
  final ValueNotifier<AxisDirection> axisDirectionNotifier;

  // 列表为占满时多余长度
  final ValueNotifier<double> extraExtentNotifier;

  @override
  _RenderRefreshViewSliverLoad createRenderObject(BuildContext context) {
    return _RenderRefreshViewSliverLoad(
      loadIndicatorExtent: loadIndicatorLayoutExtent,
      hasLayoutExtent: hasLayoutExtent,
      enableInfiniteLoad: enableInfiniteLoad,
      infiniteLoad: infiniteLoad,
      extraExtentNotifier: extraExtentNotifier,
      footerFloat: footerFloat,
      axisDirectionNotifier: axisDirectionNotifier,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant _RenderRefreshViewSliverLoad renderObject) {
    renderObject
      ..loadIndicatorLayoutExtent = loadIndicatorLayoutExtent
      ..hasLayoutExtent = hasLayoutExtent
      ..enableInfiniteLoad = enableInfiniteLoad
      ..footerFloat = footerFloat;
  }
}

// RenderSliver object that gives its child RenderBox object space to paint
// in the overscrolled gap and may or may not hold that overscrolled gap
// around the RenderBox depending on whether [layoutExtent] is set.
//
// The [layoutExtentOffsetCompensation] field keeps internal accounting to
// prevent scroll position jumps as the [layoutExtent] is set and unset.
class _RenderRefreshViewSliverLoad extends RenderSliverSingleBoxAdapter {
  _RenderRefreshViewSliverLoad({
    @required double loadIndicatorExtent,
    @required bool hasLayoutExtent,
    @required bool enableInfiniteLoad,
    @required this.infiniteLoad,
    @required this.extraExtentNotifier,
    @required this.axisDirectionNotifier,
    @required bool footerFloat,
    RenderBox child,
  })  : assert(loadIndicatorExtent != null),
        assert(loadIndicatorExtent >= 0.0),
        assert(hasLayoutExtent != null),
        _loadIndicatorExtent = loadIndicatorExtent,
        _enableInfiniteLoad = enableInfiniteLoad,
        _hasLayoutExtent = hasLayoutExtent,
        _footerFloat = footerFloat {
    this.child = child;
  }

  /// 列表方向
  final ValueNotifier<AxisDirection> axisDirectionNotifier;

  // The amount of layout space the indicator should occupy in the sliver in a
  // resting state when in the refreshing mode.
  double get loadIndicatorLayoutExtent => _loadIndicatorExtent;
  double _loadIndicatorExtent;

  set loadIndicatorLayoutExtent(double value) {
    assert(value != null);
    assert(value >= 0.0);
    if (value == _loadIndicatorExtent) return;
    _loadIndicatorExtent = value;
    markNeedsLayout();
  }

  // The child box will be laid out and painted in the available space either
  // way but this determines whether to also occupy any
  // [SliverGeometry.layoutExtent] space or not.
  bool get hasLayoutExtent => _hasLayoutExtent;
  bool _hasLayoutExtent;

  set hasLayoutExtent(bool value) {
    assert(value != null);
    if (value == _hasLayoutExtent) return;
    _hasLayoutExtent = value;
    markNeedsLayout();
  }

  /// 是否开启无限加载
  bool get enableInfiniteLoad => _enableInfiniteLoad;
  bool _enableInfiniteLoad;

  set enableInfiniteLoad(bool value) {
    assert(value != null);
    if (value == _enableInfiniteLoad) return;
    _enableInfiniteLoad = value;
    markNeedsLayout();
  }

  /// Header是否浮动
  bool get footerFloat => _footerFloat;
  bool _footerFloat;

  set footerFloat(bool value) {
    assert(value != null);
    if (value == _footerFloat) return;
    _footerFloat = value;
    markNeedsLayout();
  }

  /// 无限加载回调
  final VoidCallback infiniteLoad;

  // 列表为占满时多余长度
  final ValueNotifier<double> extraExtentNotifier;

  // 触发无限加载
  bool _triggerInfiniteLoad = false;

  // 获取子组件大小
  double get childSize =>
      constraints.axis == Axis.vertical ? child.size.height : child.size.width;

  // This keeps track of the previously applied scroll offsets to the scrollable
  // so that when [loadIndicatorLayoutExtent] or [hasLayoutExtent] changes,
  // the appropriate delta can be applied to keep everything in the same place
  // visually.
  double layoutExtentOffsetCompensation = 0.0;

  @override
  void performLayout() {
    // 判断列表是否未占满,去掉未占满高度
    double extraExtent = 0.0;
    if (constraints.precedingScrollExtent <
        constraints.viewportMainAxisExtent) {
      extraExtent = constraints.viewportMainAxisExtent -
          constraints.precedingScrollExtent;
    }
    extraExtentNotifier.value = extraExtent;

    // Only pulling to refresh from the top is currently supported.
    // 注释以支持reverse
    // assert(constraints.axisDirection == AxisDirection.down);
    assert(constraints.growthDirection == GrowthDirection.forward);

    // 判断是否触发无限加载
    if ((enableInfiniteLoad &&
                extraExtentNotifier.value < constraints.remainingPaintExtent ||
            (extraExtentNotifier.value == constraints.remainingPaintExtent &&
                constraints.cacheOrigin < 0.0)) &&
        constraints.remainingPaintExtent > 1.0) {
      if (!_triggerInfiniteLoad) {
        _triggerInfiniteLoad = true;
        infiniteLoad();
      }
    } else {
      if (constraints.remainingPaintExtent <= 1.0 ||
          extraExtent > 0.0 ||
          (enableInfiniteLoad &&
              extraExtentNotifier.value == constraints.remainingPaintExtent)) {
        if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
          _triggerInfiniteLoad = false;
        } else {
          SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
            _triggerInfiniteLoad = false;
          });
        }
      }
    }

    // The new layout extent this sliver should now have.
    final double layoutExtent =
        (_hasLayoutExtent || enableInfiniteLoad ? 1.0 : 0.0) *
            _loadIndicatorExtent;
    // If the new layoutExtent instructive changed, the SliverGeometry's
    // layoutExtent will take that value (on the next performLayout run). Shift
    // the scroll offset first so it doesn't make the scroll position suddenly jump.
    /*if (layoutExtent != layoutExtentOffsetCompensation) {
      geometry = SliverGeometry(
        scrollOffsetCorrection: layoutExtent - layoutExtentOffsetCompensation,
      );
      layoutExtentOffsetCompensation = layoutExtent;
      // Return so we don't have to do temporary accounting and adjusting the
      // child's constraints accounting for this one transient frame using a
      // combination of existing layout extent, new layout extent change and
      // the overlap.
      return;
    }*/
    final bool active = (constraints.remainingPaintExtent > 1.0 ||
        layoutExtent > (enableInfiniteLoad ? 1.0 : 0.0) * _loadIndicatorExtent);
    // 如果列表已有范围不大于指示器的范围则加上滚动超出距离
    final double overscrolledExtent = max(
        constraints.remainingPaintExtent +
            (constraints.precedingScrollExtent < _loadIndicatorExtent
                ? constraints.scrollOffset
                : 0.0),
        0.0);
    // 是否反向
    bool isReverse = constraints.axisDirection == AxisDirection.up ||
        constraints.axisDirection == AxisDirection.left;
    axisDirectionNotifier.value = constraints.axisDirection;
    // Layout the child giving it the space of the currently dragged overscroll
    // which may or may not include a sliver layout extent space that it will
    // keep after the user lets go during the refresh process.
    child.layout(
      constraints.asBoxConstraints(
        maxExtent: isReverse
            ? overscrolledExtent
            : _hasLayoutExtent || enableInfiniteLoad
                ? _loadIndicatorExtent > overscrolledExtent
                    ? _loadIndicatorExtent
                    : overscrolledExtent
                : overscrolledExtent,
      ),
      parentUsesSize: true,
    );
    if (active) {
      geometry = SliverGeometry(
        scrollExtent: layoutExtent,
        paintOrigin: -constraints.scrollOffset,
        paintExtent: max(
          // Check child size (which can come from overscroll) because
          // layoutExtent may be zero. Check layoutExtent also since even
          // with a layoutExtent, the indicator builder may decide to not
          // build anything.
          min(max(childSize, layoutExtent), constraints.remainingPaintExtent) -
              constraints.scrollOffset,
          0.0,
        ),
        maxPaintExtent: max(
          min(max(childSize, layoutExtent), constraints.remainingPaintExtent) -
              constraints.scrollOffset,
          0.0,
        ),
        layoutExtent: min(max(layoutExtent - constraints.scrollOffset, 0.0),
            constraints.remainingPaintExtent),
      );
    } else {
      // If we never started overscrolling, return no geometry.
      geometry = SliverGeometry.zero;
    }
  }

  @override
  void paint(PaintingContext paintContext, Offset offset) {
    if (constraints.remainingPaintExtent > 0.0 ||
        constraints.scrollOffset + childSize > 0) {
      paintContext.paintChild(child, offset);
    }
  }

  // Nothing special done here because this sliver always paints its child
  // exactly between paintOrigin and paintExtent.
  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}
}

/// 结束加载
/// success 为是否成功(为false时，noMore无效)
/// noMore 为是否有更多数据
typedef FinishLoad = void Function({
  bool success,
  bool noMore,
});

/// 绑定加载指示剂
typedef BindLoadIndicator = void Function(
    FinishLoad finishLoad, VoidCallback resetLoadState);

class RefreshViewSliverLoadControl extends StatefulWidget {
  /// Create a new refresh control for inserting into a list of slivers.
  ///
  /// The [loadTriggerPullDistance] and [loadIndicatorExtent] arguments
  /// must not be null and must be >= 0.
  ///
  /// The [builder] argument may be null, in which case no indicator UI will be
  /// shown but the [onLoad] will still be invoked. By default, [builder]
  /// shows a [CupertinoActivityIndicator].
  ///
  /// The [onLoad] argument will be called when pulled far enough to trigger
  /// a refresh.
  const RefreshViewSliverLoadControl({
    Key key,
    this.loadTriggerPullDistance = _defaultLoadTriggerPullDistance,
    this.loadIndicatorExtent = _defaultLoadIndicatorExtent,
    @required this.builder,
    this.completeDuration,
    this.onLoad,
    this.focusNotifier,
    this.taskNotifier,
    this.callLoadNotifier,
    this.taskIndependence,
    this.bindLoadIndicator,
    this.enableControlFinishLoad = false,
    this.enableInfiniteLoad = true,
    this.enableHapticFeedback = false,
    this.footerFloat = false,
  })  : assert(loadTriggerPullDistance != null),
        assert(loadTriggerPullDistance > 0.0),
        assert(loadIndicatorExtent != null),
        assert(loadIndicatorExtent >= 0.0),
        assert(
            loadTriggerPullDistance >= loadIndicatorExtent,
            'The refresh indicator cannot take more space in its final state '
            'than the amount initially created by overscrolling.'),
        super(key: key);

  /// The amount of overscroll the scrollable must be dragged to trigger a reload.
  ///
  /// Must not be null, must be larger than 0.0 and larger than
  /// [loadIndicatorExtent]. Defaults to 100px when not specified.
  ///
  /// When overscrolled past this distance, [onLoad] will be called if not
  /// null and the [builder] will build in the [LoadMode.armed] state.
  final double loadTriggerPullDistance;

  /// The amount of space the refresh indicator sliver will keep holding while
  /// [onLoad]'s [Future] is still running.
  ///
  /// Must not be null and must be positive, but can be 0.0, in which case the
  /// sliver will start retracting back to 0.0 as soon as the refresh is started.
  /// Defaults to 60px when not specified.
  ///
  /// Must be smaller than [loadTriggerPullDistance], since the sliver
  /// shouldn't grow further after triggering the refresh.
  final double loadIndicatorExtent;

  /// A builder that's called as this sliver's size changes, and as the state
  /// changes.
  ///
  /// A default simple Twitter-style pull-to-refresh indicator is provided if
  /// not specified.
  ///
  /// Can be set to null, in which case nothing will be drawn in the overscrolled
  /// space.
  ///
  /// Will not be called when the available space is zero such as before any
  /// overscroll.
  final LoadControlBuilder builder;

  /// Callback invoked when pulled by [loadTriggerPullDistance].
  ///
  /// If provided, must return a [Future] which will keep the indicator in the
  /// [LoadMode.refresh] state until the [Future] completes.
  ///
  /// Can be null, in which case a single frame of [LoadMode.armed]
  /// state will be drawn before going immediately to the [LoadMode.done]
  /// where the sliver will start retracting.
  final OnLoadCallback onLoad;

  /// 完成延时
  final Duration completeDuration;

  /// 绑定加载指示器
  final BindLoadIndicator bindLoadIndicator;

  /// 是否开启控制结束
  final bool enableControlFinishLoad;

  /// 是否开启无限加载
  final bool enableInfiniteLoad;

  /// 开启震动反馈
  final bool enableHapticFeedback;

  /// 滚动状态
  final ValueNotifier<bool> focusNotifier;

  /// 任务状态
  final ValueNotifier<TaskState> taskNotifier;

  // 触发加载状态
  final ValueNotifier<bool> callLoadNotifier;

  /// 是否任务独立
  final bool taskIndependence;

  /// Footer浮动
  final bool footerFloat;

  static const double _defaultLoadTriggerPullDistance = 100.0;
  static const double _defaultLoadIndicatorExtent = 60.0;

  /// Retrieve the current state of the RefreshViewSliverLoadControl. The same as the
  /// state that gets passed into the [builder] function. Used for testing.
  /*@visibleForTesting
  static LoadMode state(BuildContext context) {
    final _RefreshViewSliverLoadControlState state =
        context.findAncestorStateOfType<_RefreshViewSliverLoadControlState>();
    return state.loadState;
  }*/

  @override
  _RefreshViewSliverLoadControlState createState() =>
      _RefreshViewSliverLoadControlState();
}

class _RefreshViewSliverLoadControlState
    extends State<RefreshViewSliverLoadControl> {
  // Reset the state from done to inactive when only this fraction of the
  // original `loadTriggerPullDistance` is left.
  static const double _inactiveResetOverscrollFraction = 0.1;

  LoadMode loadState;

  // [Future] returned by the widget's `onLoad`.
  Future<void> _loadTask;

  Future<void> get loadTask => _loadTask;

  bool get hasTask {
    return widget.taskIndependence
        ? _loadTask != null
        : widget.taskNotifier.value.refreshing ||
            widget.taskNotifier.value.loading;
  }

  set loadTask(Future<void> task) {
    _loadTask = task;
    if (!widget.taskIndependence)
      widget.taskNotifier.value =
          widget.taskNotifier.value.copy(loading: task != null);
  }

  // The amount of space available from the inner indicator box's perspective.
  //
  // The value is the sum of the sliver's layout extent and the overscroll
  // (which partially gets transferred into the layout extent when the refresh
  // triggers).
  //
  // The value of latestIndicatorBoxExtent doesn't change when the sliver scrolls
  // away without retracting; it is independent from the sliver's scrollOffset.
  double latestIndicatorBoxExtent = 0.0;
  bool hasSliverLayoutExtent = false;

  // 滚动焦点
  bool get _focus => widget.focusNotifier.value;

  // 刷新完成
  bool _success;

  // 没有更多数据
  bool _noMore;

  // 列表为占满时多余长度
  ValueNotifier<double> extraExtentNotifier;

  // 列表方向
  ValueNotifier<AxisDirection> _axisDirectionNotifier;

  // 初始化
  @override
  void initState() {
    super.initState();
    loadState = LoadMode.inactive;
    extraExtentNotifier = ValueNotifier<double>(0.0);
    _axisDirectionNotifier = ValueNotifier<AxisDirection>(AxisDirection.down);
    // 绑定加载指示器
    if (widget.bindLoadIndicator != null) {
      widget.bindLoadIndicator(finishLoad, resetLoadState);
    }
  }

  // 销毁
  @override
  void dispose() {
    super.dispose();
    extraExtentNotifier.dispose();
  }

  // 完成刷新
  void finishLoad({
    bool success = true,
    bool noMore = false,
  }) {
    _success = success;
    _noMore = _success == false ? false : noMore;
    if (widget.enableControlFinishLoad && loadTask != null) {
      if (widget.enableInfiniteLoad) {
        loadState = LoadMode.inactive;
      }
      setState(() => loadTask = null);
      loadState = transitionNextState();
    }
  }

  // 恢复状态
  void resetLoadState() {
    if (mounted) {
      setState(() {
        _success = true;
        _noMore = false;
        loadState = LoadMode.inactive;
        hasSliverLayoutExtent = false;
      });
    }
  }

  // 无限加载
  void _infiniteLoad() {
    if (!hasTask &&
        widget.enableInfiniteLoad &&
        _noMore != true &&
        !widget.callLoadNotifier.value) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
//      SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
//        loadState = LoadMode.load;
//        loadTask = widget.onLoad()
//          ..then((_) {
//            if (mounted && !widget.enableControlFinishLoad) {
//              loadState = LoadMode.load;
//              setState(() => loadTask = null);
//              // Trigger one more transition because by this time, BoxConstraint's
//              // maxHeight might already be resting at 0 in which case no
//              // calls to [transitionNextState] will occur anymore and the
//              // state may be stuck in a non-inactive state.
//              loadState = transitionNextState();
//            }
//          });
//        setState(() => hasSliverLayoutExtent = true);
//      });
    }
  }

  // A state machine transition calculator. Multiple states can be transitioned
  // through per single call.
  LoadMode transitionNextState() {
    LoadMode nextState;

    // 判断是否没有更多
    if (_noMore == true && widget.enableInfiniteLoad) {
      return loadState;
    } else if (_noMore == true &&
        loadState != LoadMode.load &&
        loadState != LoadMode.loaded &&
        loadState != LoadMode.done) {
      return loadState;
    } else if (widget.enableInfiniteLoad && loadState == LoadMode.done) {
      return LoadMode.inactive;
    }

    // 完成
    void goToDone() {
      nextState = LoadMode.done;
      loadState = LoadMode.done;
      // Either schedule the RenderSliver to re-layout on the next frame
      // when not currently in a frame or schedule it on the next frame.
      if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
        setState(() => hasSliverLayoutExtent = false);
      } else {
        SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
          setState(() => hasSliverLayoutExtent = false);
        });
      }
    }

    // 结束
    LoadMode goToFinish() {
      // 判断加载完成
      LoadMode state = LoadMode.loaded;
      // 添加延时
      if (widget.completeDuration == null || widget.enableInfiniteLoad) {
        goToDone();
        return null;
      } else {
        Future.delayed(widget.completeDuration, () {
          if (mounted) {
            goToDone();
          }
        });
        return state;
      }
    }

    switch (loadState) {
      case LoadMode.inactive:
        if (latestIndicatorBoxExtent <= 0 ||
            (!_focus && !widget.callLoadNotifier.value)) {
          return LoadMode.inactive;
        } else {
          nextState = LoadMode.drag;
        }
        continue drag;
      drag:
      case LoadMode.drag:
        if (latestIndicatorBoxExtent == 0) {
          return LoadMode.inactive;
        } else if (latestIndicatorBoxExtent <= widget.loadTriggerPullDistance) {
          // 如果未触发加载则取消固定高度
          if (hasSliverLayoutExtent && !hasTask) {
            SchedulerBinding.instance
                .addPostFrameCallback((Duration timestamp) {
              setState(() => hasSliverLayoutExtent = false);
            });
          }
          return LoadMode.drag;
        } else {
          // 提前固定高度，防止列表回弹
          SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
            setState(() => hasSliverLayoutExtent = true);
          });
          if (widget.onLoad != null && !hasTask) {
            if (!_focus) {
              if (widget.callLoadNotifier.value) {
                widget.callLoadNotifier.value = false;
              }
              if (widget.enableHapticFeedback) {
                HapticFeedback.mediumImpact();
              }
              // 触发加载任务
              SchedulerBinding.instance
                  .addPostFrameCallback((Duration timestamp) {
                loadTask = widget.onLoad()
                  ..then((_) {
                    if (mounted && !widget.enableControlFinishLoad) {
                      if (widget.enableInfiniteLoad) {
                        loadState = LoadMode.inactive;
                      }
                      setState(() => loadTask = null);
                      if (!widget.enableInfiniteLoad)
                        loadState = transitionNextState();
                    }
                  });
              });
              return LoadMode.armed;
            }
            return LoadMode.drag;
          }
          return LoadMode.drag;
        }
        // Don't continue here. We can never possibly call onLoad and
        // progress to the next state in one [computeNextState] call.
        break;
      case LoadMode.armed:
        if (loadState == LoadMode.armed && !hasTask) {
          // 结束
          var state = goToFinish();
          if (state != null) return state;
          continue done;
        }

        if (latestIndicatorBoxExtent > widget.loadIndicatorExtent) {
          return LoadMode.armed;
        } else {
          nextState = LoadMode.load;
        }
        continue refresh;
      refresh:
      case LoadMode.load:
        if (loadTask != null) {
          return LoadMode.load;
        } else {
          // 结束
          var state = goToFinish();
          if (state != null) return state;
        }
        continue done;
      done:
      case LoadMode.done:
        // Let the transition back to inactive trigger before strictly going
        // to 0.0 since the last bit of the animation can take some time and
        // can feel sluggish if not going all the way back to 0.0 prevented
        // a subsequent pull-to-refresh from starting.
        if (latestIndicatorBoxExtent >
            widget.loadTriggerPullDistance * _inactiveResetOverscrollFraction) {
          return LoadMode.done;
        } else {
          nextState = LoadMode.inactive;
        }
        break;
      case LoadMode.loaded:
        nextState = loadState;
        break;
      default:
        break;
    }

    return nextState;
  }

  @override
  Widget build(BuildContext context) {
    return _RefreshViewSliverLoad(
      loadIndicatorLayoutExtent: widget.loadIndicatorExtent,
      hasLayoutExtent: hasSliverLayoutExtent,
      enableInfiniteLoad: widget.enableInfiniteLoad,
      infiniteLoad: _infiniteLoad,
      extraExtentNotifier: extraExtentNotifier,
      footerFloat: widget.footerFloat,
      axisDirectionNotifier: _axisDirectionNotifier,
      // A LayoutBuilder lets the sliver's layout changes be fed back out to
      // its owner to trigger state changes.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 判断是否有刷新任务
          if (!widget.taskIndependence &&
              widget.taskNotifier.value.refreshing) {
            return SizedBox();
          }
          // 是否为垂直方向
          bool isVertical =
              _axisDirectionNotifier.value == AxisDirection.down ||
                  _axisDirectionNotifier.value == AxisDirection.up;
          // 是否反向
          bool isReverse = _axisDirectionNotifier.value == AxisDirection.up ||
              _axisDirectionNotifier.value == AxisDirection.left;
          latestIndicatorBoxExtent =
              (isVertical ? constraints.maxHeight : constraints.maxWidth) -
                  extraExtentNotifier.value;
          loadState = transitionNextState();
          // 列表未占满时恢复一下状态
          if (extraExtentNotifier.value > 0.0 &&
              loadState == LoadMode.loaded &&
              loadTask == null) {
            loadState = LoadMode.inactive;
          }
          if (widget.builder != null && latestIndicatorBoxExtent >= 0) {
            Widget child = widget.builder(
              context,
              loadState,
              latestIndicatorBoxExtent,
              widget.loadTriggerPullDistance,
              widget.loadIndicatorExtent,
              _axisDirectionNotifier.value,
              widget.footerFloat,
              widget.completeDuration,
              widget.enableInfiniteLoad,
              _success ?? true,
              _noMore ?? false,
            );
            // 顶出列表未占满多余部分
            return isVertical
                ? Column(
                    children: <Widget>[
                      isReverse
                          ? SizedBox()
                          : Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                      Container(
                        height: latestIndicatorBoxExtent,
                        child: child,
                      ),
                      !isReverse
                          ? SizedBox()
                          : Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      isReverse
                          ? SizedBox()
                          : Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                      Container(
                        width: latestIndicatorBoxExtent,
                        child: child,
                      ),
                      !isReverse
                          ? SizedBox()
                          : Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                    ],
                  );
          }
          return Container();
        },
      ),
    );
  }
}

/// 空视图
class EmptyWidget extends StatefulWidget {
  /// 子组件
  final Widget child;

  EmptyWidget({Key key, this.child}) : super(key: key);

  @override
  EmptyWidgetState createState() {
    return EmptyWidgetState();
  }
}

class EmptyWidgetState extends State<EmptyWidget> {
  // 列表配置通知器
  ValueNotifier<SliverConfig> _notifier;

  @override
  void initState() {
    _notifier = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SliverEmpty(
      child: widget.child,
      notifier: _notifier,
    );
  }
}

/// 空视图Sliver组件
class _SliverEmpty extends SingleChildRenderObjectWidget {
  final ValueNotifier<SliverConfig> notifier;

  const _SliverEmpty({
    Key key,
    @required Widget child,
    @required this.notifier,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSliverEmpty(
      notifier: this.notifier,
    );
  }
}

class _RenderSliverEmpty extends RenderSliverSingleBoxAdapter {
  final ValueNotifier<SliverConfig> notifier;

  _RenderSliverEmpty({
    RenderBox child,
    @required this.notifier,
  }) {
    this.child = child;
  }

  @override
  void performLayout() {
    // 判断Sliver配置是否改变
    SliverConfig sliverConfig = SliverConfig(
      remainingPaintExtent: constraints.remainingPaintExtent,
      crossAxisExtent: constraints.crossAxisExtent,
      axis: constraints.axis,
    );
    if (notifier.value != sliverConfig) {
      notifier.value = sliverConfig;
      child.layout(
        constraints.asBoxConstraints(
          maxExtent: constraints.remainingPaintExtent,
        ),
        parentUsesSize: true,
      );
      geometry = SliverGeometry(
        paintExtent: constraints.remainingPaintExtent,
        maxPaintExtent: constraints.remainingPaintExtent,
        layoutExtent: constraints.remainingPaintExtent,
      );
    } else {
      double remainingPaintExtent = notifier.value.remainingPaintExtent;
      double childExtent = remainingPaintExtent;
      final double paintedChildSize =
          calculatePaintOffset(constraints, from: 0.0, to: childExtent);
      final double cacheExtent =
          calculateCacheOffset(constraints, from: 0.0, to: childExtent);
      child.layout(
        constraints.asBoxConstraints(
          maxExtent: remainingPaintExtent,
        ),
        parentUsesSize: true,
      );
      geometry = SliverGeometry(
        scrollExtent: childExtent,
        paintExtent: paintedChildSize,
        cacheExtent: cacheExtent,
        maxPaintExtent: remainingPaintExtent,
        layoutExtent: paintedChildSize,
        hitTestExtent: paintedChildSize,
        hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
            constraints.scrollOffset > 0.0,
      );
      setChildParentData(child, constraints, geometry);
    }
  }
}

// 列表属性
class SliverConfig {
  final double remainingPaintExtent;
  final double crossAxisExtent;
  final Axis axis;

  SliverConfig({this.remainingPaintExtent, this.crossAxisExtent, this.axis});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SliverConfig &&
          runtimeType == other.runtimeType &&
          crossAxisExtent == other.crossAxisExtent &&
          axis == other.axis;

  @override
  int get hashCode => crossAxisExtent.hashCode ^ axis.hashCode;
}

const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

/// 质感设计Header
class MaterialHeader extends Header {
  final Key key;
  final double displacement;

  /// 颜色
  final Animation<Color> valueColor;

  /// 背景颜色
  final Color backgroundColor;

  final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();

  MaterialHeader({
    this.key,
    this.displacement = 40.0,
    this.valueColor,
    this.backgroundColor,
    completeDuration = const Duration(milliseconds: 300),
    bool enableHapticFeedback = false,
  }) : super(
          float: true,
          extent: 70.0,
          triggerDistance: 70.0,
          completeDuration: completeDuration == null
              ? Duration(
                  milliseconds: 300,
                )
              : completeDuration +
                  Duration(
                    milliseconds: 300,
                  ),
          enableInfiniteRefresh: false,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
    return MaterialHeaderWidget(
      key: key,
      displacement: displacement,
      valueColor: valueColor,
      backgroundColor: backgroundColor,
      linkNotifier: linkNotifier,
    );
  }
}

/// 质感设计Header组件
class MaterialHeaderWidget extends StatefulWidget {
  final double displacement;

  // 颜色
  final Animation<Color> valueColor;

  // 背景颜色
  final Color backgroundColor;
  final LinkHeaderNotifier linkNotifier;

  const MaterialHeaderWidget({
    Key key,
    this.displacement,
    this.valueColor,
    this.backgroundColor,
    this.linkNotifier,
  }) : super(key: key);

  @override
  MaterialHeaderWidgetState createState() {
    return MaterialHeaderWidgetState();
  }
}

class MaterialHeaderWidgetState extends State<MaterialHeaderWidget>
    with TickerProviderStateMixin<MaterialHeaderWidget> {
  static final Animatable<double> _oneToZeroTween =
      Tween<double>(begin: 1.0, end: 0.0);

  RefreshMode get _refreshState => widget.linkNotifier.refreshState;

  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  double get _riggerPullDistance =>
      widget.linkNotifier.refreshTriggerPullDistance;

  Duration get _completeDuration => widget.linkNotifier.completeDuration;

  AxisDirection get _axisDirection => widget.linkNotifier.axisDirection;

  bool get _noMore => widget.linkNotifier.noMore;

  // 动画
  AnimationController _scaleController;
  Animation<double> _scaleFactor;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  // 是否刷新完成
  bool _refreshFinish = false;

  set refreshFinish(bool finish) {
    if (_refreshFinish != finish) {
      if (finish) {
        Future.delayed(_completeDuration - Duration(milliseconds: 300), () {
          if (mounted) {
            _scaleController.animateTo(1.0, duration: _kIndicatorScaleDuration);
          }
        });
        Future.delayed(_completeDuration, () {
          if (mounted) {
            _refreshFinish = false;
            _scaleController.animateTo(0.0,
                duration: Duration(milliseconds: 10));
          }
        });
      }
      _refreshFinish = finish;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_noMore) return Container();
    // 是否为垂直方向
    bool isVertical = _axisDirection == AxisDirection.down ||
        _axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = _axisDirection == AxisDirection.up ||
        _axisDirection == AxisDirection.left;
    // 计算进度值
    double indicatorValue = _pulledExtent / _riggerPullDistance;
    indicatorValue = indicatorValue < 1.0 ? indicatorValue : 1.0;
    // 判断是否刷新结束
    if (_refreshState == RefreshMode.refreshed) {
      refreshFinish = true;
    }
    return Container(
      height: isVertical
          ? _refreshState == RefreshMode.inactive
              ? 0.0
              : _pulledExtent
          : double.infinity,
      width: !isVertical
          ? _refreshState == RefreshMode.inactive
              ? 0.0
              : _pulledExtent
          : double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: isVertical
                ? isReverse
                    ? 0.0
                    : null
                : 0.0,
            bottom: isVertical
                ? !isReverse
                    ? 0.0
                    : null
                : 0.0,
            left: !isVertical
                ? isReverse
                    ? 0.0
                    : null
                : 0.0,
            right: !isVertical
                ? !isReverse
                    ? 0.0
                    : null
                : 0.0,
            child: Container(
              padding: EdgeInsets.only(
                top: isVertical
                    ? isReverse
                        ? 0.0
                        : widget.displacement
                    : 0.0,
                bottom: isVertical
                    ? !isReverse
                        ? 0.0
                        : widget.displacement
                    : 0.0,
                left: !isVertical
                    ? isReverse
                        ? 0.0
                        : widget.displacement
                    : 0.0,
                right: !isVertical
                    ? !isReverse
                        ? 0.0
                        : widget.displacement
                    : 0.0,
              ),
              alignment: isVertical
                  ? isReverse
                      ? Alignment.topCenter
                      : Alignment.bottomCenter
                  : isReverse
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
              child: ScaleTransition(
                scale: _scaleFactor,
                child: RefreshProgressIndicator(
                  value: _refreshState == RefreshMode.armed ||
                          _refreshState == RefreshMode.refresh ||
                          _refreshState == RefreshMode.refreshed ||
                          _refreshState == RefreshMode.done
                      ? null
                      : indicatorValue,
                  valueColor: widget.valueColor,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 质感设计Footer
class MaterialFooter extends Footer {
  final Key key;
  final double displacement;

  /// 颜色
  final Animation<Color> valueColor;

  /// 背景颜色
  final Color backgroundColor;

  final LinkFooterNotifier linkNotifier = LinkFooterNotifier();

  MaterialFooter({
    this.key,
    this.displacement = 40.0,
    this.valueColor,
    this.backgroundColor,
    completeDuration = const Duration(seconds: 1),
    bool enableHapticFeedback = false,
    bool enableInfiniteLoad = true,
  }) : super(
          float: true,
          extent: 0.0,
          triggerDistance: 52.0,
          completeDuration: completeDuration == null
              ? Duration(
                  milliseconds: 300,
                )
              : completeDuration +
                  Duration(
                    milliseconds: 300,
                  ),
          enableHapticFeedback: enableHapticFeedback,
          enableInfiniteLoad: enableInfiniteLoad,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);
    return MaterialFooterWidget(
      key: key,
      displacement: displacement,
      valueColor: valueColor,
      backgroundColor: backgroundColor,
      linkNotifier: linkNotifier,
    );
  }
}

/// 质感设计Footer组件
class MaterialFooterWidget extends StatefulWidget {
  final double displacement;

  // 颜色
  final Animation<Color> valueColor;

  // 背景颜色
  final Color backgroundColor;
  final LinkFooterNotifier linkNotifier;

  const MaterialFooterWidget({
    Key key,
    this.displacement,
    this.valueColor,
    this.backgroundColor,
    this.linkNotifier,
  }) : super(key: key);

  @override
  MaterialFooterWidgetState createState() {
    return MaterialFooterWidgetState();
  }
}

class MaterialFooterWidgetState extends State<MaterialFooterWidget> {
  LoadMode get _refreshState => widget.linkNotifier.loadState;

  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  double get _riggerPullDistance => widget.linkNotifier.loadTriggerPullDistance;

  AxisDirection get _axisDirection => widget.linkNotifier.axisDirection;

  bool get _noMore => widget.linkNotifier.noMore;

  @override
  Widget build(BuildContext context) {
    if (_noMore) return Container();
    // 是否为垂直方向
    bool isVertical = _axisDirection == AxisDirection.down ||
        _axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = _axisDirection == AxisDirection.up ||
        _axisDirection == AxisDirection.left;
    // 计算进度值
    double indicatorValue = _pulledExtent / _riggerPullDistance;
    indicatorValue = indicatorValue < 1.0 ? indicatorValue : 1.0;
    return Stack(
      children: <Widget>[
        Positioned(
          top: isVertical
              ? !isReverse
                  ? 0.0
                  : null
              : 0.0,
          bottom: isVertical
              ? isReverse
                  ? 0.0
                  : null
              : 0.0,
          left: !isVertical
              ? !isReverse
                  ? 0.0
                  : null
              : 0.0,
          right: !isVertical
              ? isReverse
                  ? 0.0
                  : null
              : 0.0,
          child: Container(
            alignment: isVertical
                ? !isReverse
                    ? Alignment.topCenter
                    : Alignment.bottomCenter
                : !isReverse
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
            child: RefreshProgressIndicator(
              value: _refreshState == LoadMode.armed ||
                      _refreshState == LoadMode.load ||
                      _refreshState == LoadMode.loaded ||
                      _refreshState == LoadMode.done
                  ? null
                  : indicatorValue,
              valueColor: widget.valueColor,
              backgroundColor: widget.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
