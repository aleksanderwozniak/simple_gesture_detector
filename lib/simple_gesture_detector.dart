//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

library simple_gesture_detector;

import 'package:flutter/material.dart';

/// Easy to use, reliable Gesture detection Widget. Exposes simple API for basic Gestures.
class SimpleGestureDetector extends StatefulWidget {
  /// Widget to be augmented with Gesture detection.
  final Widget child;

  /// Configuration for Swipe Gesture.
  final SimpleSwipeConfig swipeConfig;

  /// Behavior used for hit testing. Set to `HitTestBehavior.deferToChild` by default.
  final HitTestBehavior behavior;

  /// Callback to be run when Widget is Swiped up.
  final VoidCallback onSwipeUp;

  /// Callback to be run when Widget is Swiped down.
  final VoidCallback onSwipeDown;

  /// Callback to be run when Widget is Swiped left.
  final VoidCallback onSwipeLeft;

  /// Callback to be run when Widget is Swiped right.
  final VoidCallback onSwipeRight;

  const SimpleGestureDetector({
    Key key,
    @required this.child,
    this.swipeConfig = const SimpleSwipeConfig(),
    this.behavior = HitTestBehavior.deferToChild,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
  })  : assert(child != null),
        assert(swipeConfig != null),
        super(key: key);

  @override
  _SimpleGestureDetectorState createState() => _SimpleGestureDetectorState();
}

class _SimpleGestureDetectorState extends State<SimpleGestureDetector> {
  Offset _initialSwipeOffset;
  Offset _finalSwipeOffset;

  void _onVerticalDragStart(DragStartDetails details) {
    _initialSwipeOffset = details.globalPosition;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _finalSwipeOffset = details.globalPosition;

    if (widget.swipeConfig.swipeDetectionMoment == SwipeDetectionMoment.onUpdate) {
      if (_initialSwipeOffset != null) {
        final offsetDifference = _initialSwipeOffset.dy - _finalSwipeOffset.dy;

        if (offsetDifference.abs() > widget.swipeConfig.verticalThreshold) {
          _initialSwipeOffset = null;
          final isSwipeUp = offsetDifference > 0;
          if (isSwipeUp) {
            widget.onSwipeUp();
          } else {
            widget.onSwipeDown();
          }
        }
      }
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (widget.swipeConfig.swipeDetectionMoment == SwipeDetectionMoment.onUpdate) {
      return;
    }

    if (_initialSwipeOffset != null) {
      final offsetDifference = _initialSwipeOffset.dy - _finalSwipeOffset.dy;

      if (offsetDifference.abs() > widget.swipeConfig.verticalThreshold) {
        _initialSwipeOffset = null;
        final isSwipeUp = offsetDifference > 0;
        if (isSwipeUp) {
          widget.onSwipeUp();
        } else {
          widget.onSwipeDown();
        }
      }
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _initialSwipeOffset = details.globalPosition;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _finalSwipeOffset = details.globalPosition;

    if (widget.swipeConfig.swipeDetectionMoment == SwipeDetectionMoment.onUpdate) {
      if (_initialSwipeOffset != null) {
        final offsetDifference = _initialSwipeOffset.dx - _finalSwipeOffset.dx;

        if (offsetDifference.abs() > widget.swipeConfig.horizontalThreshold) {
          _initialSwipeOffset = null;
          final isSwipeLeft = offsetDifference > 0;
          if (isSwipeLeft) {
            widget.onSwipeLeft();
          } else {
            widget.onSwipeRight();
          }
        }
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.swipeConfig.swipeDetectionMoment == SwipeDetectionMoment.onUpdate) {
      return;
    }

    if (_initialSwipeOffset != null) {
      final offsetDifference = _initialSwipeOffset.dx - _finalSwipeOffset.dx;

      if (offsetDifference.abs() > widget.swipeConfig.horizontalThreshold) {
        _initialSwipeOffset = null;
        final isSwipeLeft = offsetDifference > 0;
        if (isSwipeLeft) {
          widget.onSwipeLeft();
        } else {
          widget.onSwipeRight();
        }
      }
    }
  }

  bool _canSwipeVertically() {
    return widget.onSwipeUp != null || widget.onSwipeDown != null;
  }

  bool _canSwipeHorizontally() {
    return widget.onSwipeLeft != null || widget.onSwipeRight != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      child: widget.child,
      onVerticalDragStart: _canSwipeVertically() ? _onVerticalDragStart : null,
      onVerticalDragUpdate: _canSwipeVertically() ? _onVerticalDragUpdate : null,
      onVerticalDragEnd: _canSwipeVertically() ? _onVerticalDragEnd : null,
      onHorizontalDragStart: _canSwipeHorizontally() ? _onHorizontalDragStart : null,
      onHorizontalDragUpdate: _canSwipeHorizontally() ? _onHorizontalDragUpdate : null,
      onHorizontalDragEnd: _canSwipeHorizontally() ? _onHorizontalDragEnd : null,
    );
  }
}

/// Moments describing when Swipe callbacks will run.
enum SwipeDetectionMoment { onEnd, onUpdate }

/// Configuration class for Swipe gesture.
class SimpleSwipeConfig {
  /// Amount of offset needed to overcome to detect vertical Swipe.
  final double verticalThreshold;

  /// Amount of offset needed to overcome to detect horizontal Swipe.
  final double horizontalThreshold;

  /// Moment when Swipe callbacks will run.
  /// Use `SwipeDetectionMoment.onUpdate` for more reactive behavior.
  ///
  /// * `SwipeDetectionMoment.onEnd` - Swipe callbacks will run when Swipe gesture is fully complete.
  /// * `SwipeDetectionMoment.onUpdate` - Swipe callbacks will run as soon as Swipe movement is above given threshold.
  final SwipeDetectionMoment swipeDetectionMoment;

  const SimpleSwipeConfig({
    this.verticalThreshold = 50.0,
    this.horizontalThreshold = 50.0,
    this.swipeDetectionMoment = SwipeDetectionMoment.onEnd,
  })  : assert(verticalThreshold != null),
        assert(horizontalThreshold != null),
        assert(swipeDetectionMoment != null);
}
