import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:chat_hub/widget/spin_kit.dart';

Widget easyRefresh({Widget Function(BuildContext context, ScrollPhysics physics)? childBuilder, 
                      EasyRefreshController? refreshController, 
                      bool refreshOnStart=false, 
                      Function? onLoad, 
                      Function? onRefresh}) {
  return EasyRefresh.builder(
    onLoad: (onLoad!=null) ? (){onLoad();} : null,
    onRefresh: (onRefresh!=null) ? (){onRefresh();} : null,
    refreshOnStart: refreshOnStart,
    controller: refreshController,
    footer: const BallPulseFooter(backgroundColor: Colors.blueGrey),
    header: const BallPulseHeader(backgroundColor: Colors.blueGrey),
    childBuilder: childBuilder
  );
}

class BallPulseHeader extends Header {

  final Key? key;

  /// Show the ball during the pull.
  final bool showBalls;

  /// Spin widget.
  final Widget? spinWidget;

  /// No more widget.
  final Widget? noMoreWidget;

  /// Spin widget builder.
  final BezierSpinBuilder? spinBuilder;

  /// Foreground color.
  final Color? foregroundColor;

  /// Background color.
  final Color? backgroundColor;

  const BallPulseHeader({
    this.key,
    double triggerOffset = 50,
    bool clamping = false,
    double? infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
    this.showBalls = true,
    this.spinWidget,
    this.noMoreWidget,
    this.spinBuilder,
    this.foregroundColor,
    this.backgroundColor,
    IndicatorPosition position = IndicatorPosition.above,
  }) : super(
    triggerOffset: triggerOffset,
    clamping: clamping,
    infiniteOffset: infiniteOffset,
    hitOver: hitOver,
    infiniteHitOver: infiniteHitOver,
    hapticFeedback: hapticFeedback,
    position: position,
  );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return Container(
      height: state.offset,
      alignment: Alignment.center,
      child: SpinKit.threeBounce(
        color: backgroundColor,
        size: state.offset>triggerOffset/2 
          ? triggerOffset / 2 
          : state.offset * 0.68,
      )
    );
  }
}

/// Classic footer.
class BallPulseFooter extends Footer {
  final Key? key;

  /// Show the ball during the pull.
  final bool showBalls;

  /// Spin widget.
  final Widget? spinWidget;

  /// No more widget.
  final Widget? noMoreWidget;

  /// Spin widget builder.
  final BezierSpinBuilder? spinBuilder;

  /// Foreground color.
  final Color? foregroundColor;

  /// Background color.
  final Color? backgroundColor;

  const BallPulseFooter({
    this.key,
    double triggerOffset = 50,
    bool clamping = false,
    double? infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
    this.showBalls = true,
    this.spinWidget,
    this.noMoreWidget,
    this.spinBuilder,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(
    triggerOffset: triggerOffset,
    clamping: clamping,
    infiniteOffset: infiniteOffset,
    hitOver: hitOver,
    infiniteHitOver: infiniteHitOver,
    hapticFeedback: hapticFeedback,
  );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return Container(
      height: state.offset,
      alignment: Alignment.center,
      child: SpinKit.threeBounce(
        color: backgroundColor,
        size: state.offset>triggerOffset/2 
          ? triggerOffset / 2 
          : state.offset * 0.68,
      )
    );
  }
}