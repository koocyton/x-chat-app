import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NestedPageViewScrollUtils {

  PageController? firstPageController;
  PageController? secondPageController;
  final int pageCount;
  Drag? _drag;
  ScrollDirection _direction = ScrollDirection.idle;

  NestedPageViewScrollUtils(this.pageCount);

  bool handleNotification(ScrollNotification notification, Function(bool)? onCall) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.idle) {
        if (_direction==ScrollDirection.reverse || _direction==ScrollDirection.forward) {
          int toPage = firstPageController!.page!.toInt();
          toPage = _direction==ScrollDirection.reverse ? toPage + 1 : toPage - 1;
          firstPageController!.animateToPage(
            toPage, 
            duration: const Duration(milliseconds: 250), 
            curve: Curves.ease
          );
        }
        _direction = ScrollDirection.idle;
      }
      else if (notification.direction == ScrollDirection.reverse && secondPageController!.page! >= pageCount-1) {
        _direction = ScrollDirection.reverse;
      }
      else if (notification.direction == ScrollDirection.forward && secondPageController!.page! <= 0) {
        _direction = ScrollDirection.forward;
      }
      if (_direction == ScrollDirection.forward || _direction == ScrollDirection.reverse) {
        _drag = firstPageController!.position.drag(DragStartDetails(), () {
          _drag = null;
        });
      }
    }
    if (notification is OverscrollNotification) {
      if (notification.dragDetails != null && _drag != null) {
        _drag!.update(notification.dragDetails!);
      }
    }
    if (notification is ScrollEndNotification) {
      if (notification.dragDetails != null && _drag != null) {
        _drag!.end(notification.dragDetails!);
      }
    }
    return true;
  }
}

class FastBouncingScrollPhysics extends BouncingScrollPhysics {

  const FastBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  FastBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}

// ignore: must_be_immutable
class FastClampingScrollPhysics extends ClampingScrollPhysics {

  NestedPageViewScrollUtils? pageUtils;

  // final EasyRefreshController refreshController = EasyRefreshController();

  FastClampingScrollPhysics({ScrollPhysics? parent, this.pageUtils}):super(parent: parent);

  @override
  FastClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastClampingScrollPhysics(pageUtils:pageUtils, parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80,
    stiffness: 100,
    damping: 1,
  );

  // @override
  // bool shouldAcceptUserOffset(ScrollMetrics position) {
  //   log(">>>>>>");log(pageUtils);
  //   if (pageUtils!=null && pageUtils!.inDrag) {
  //     log(pageUtils!.inDrag);
  //     return false;
  //   }
  //   return super.shouldAcceptUserOffset(position);
  // }

  // @override
  // bool get allowImplicitScrolling => (pageUtils!=null && pageUtils!.inDrag) ? false : true;
}

class NoSplashFactory extends InteractiveInkFeatureFactory {

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return _NoInteractiveInkFeature(controller, referenceBox, color);
  }
}

class _NoInteractiveInkFeature extends InteractiveInkFeature {
  _NoInteractiveInkFeature(
     MaterialInkController controller,
     RenderBox referenceBox,
     Color color,
  ) : super(controller: controller, referenceBox: referenceBox, color:color);

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}

class _NullWidget extends StatelessWidget {
  const _NullWidget();

  @override
  Widget build(BuildContext context) {
    throw FlutterError(
      'Widgets that mix AutomaticKeepAliveClientMixin into their State must '
      'call super.build() but must ignore the return value of the superclass.',
    );
  }
}


Widget mySliverPersistentHeader({bool? pinned, bool? floating, double? maxExtent, double? minExtent, Widget? child}) {
  return SliverPersistentHeader(
    pinned: pinned??true,
    floating : floating??true,
    delegate: MySliverPersistentHeaderDelegate(
      maxExtent: maxExtent??51,
      minExtent: minExtent??51,
      child: child??Container(height: minExtent),
    ),
  );
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {

  final Widget child;

  @override
  final double maxExtent;

  @override
  final double minExtent;

  MySliverPersistentHeaderDelegate({required this.child, required this.maxExtent, required this.minExtent});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}