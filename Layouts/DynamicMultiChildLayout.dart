// ignore_for_file: file_names

import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import "package:flutter_layout_descriptive/Widgets/NinftyConstraints.dart";

abstract class DynamicMultiChildDelegate {
  DynamicMultiChildDelegate({Listenable? relayout}) : _relayout = relayout;

  final Listenable? _relayout;

  Map<Object, RenderBox>? _idToChild;
  Set<RenderBox>? _debugChildrenNeedingLayout;
  double? _width;
  double? _height;
  bool hasBeenLaidOut = false;

  bool hasChild(Object childId) => _idToChild![childId] != null;

  Size layoutChild(Object childId, BoxConstraints constraints) {
    final RenderBox? child = _idToChild![childId];
    assert(() {
      if (child == null) {
        throw FlutterError(
          'The $this custom multichild layout delegate tried to lay out a non-existent child.\n'
          'There is no child with the id "$childId".',
        );
      }
      if (!_debugChildrenNeedingLayout!.remove(child)) {
        throw FlutterError(
          'The $this custom multichild layout delegate tried to lay out the child with id "$childId" more than once.\n'
          'Each child must be laid out exactly once.',
        );
      }
      try {
        assert(constraints.debugAssertIsValid(isAppliedConstraint: true));
      } on AssertionError catch (exception) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'The $this custom multichild layout delegate provided invalid box constraints for the child with id "$childId".'),
          DiagnosticsProperty<AssertionError>('Exception', exception,
              showName: false),
          ErrorDescription(
            'The minimum width and height must be greater than or equal to zero.\n'
            'The maximum width must be greater than or equal to the minimum width.\n'
            'The maximum height must be greater than or equal to the minimum height.',
          ),
        ]);
      }
      return true;
    }());
    //constraints
    child!.layout(constraints, parentUsesSize: true);
    return child.size;
  }

  void positionChild(Object childId, Offset offset) {
    final RenderBox? child = _idToChild![childId];
    assert(() {
      if (child == null) {
        throw FlutterError(
          'The $this custom multichild layout delegate tried to position out a non-existent child:\n'
          'There is no child with the id "$childId".',
        );
      }
      return true;
    }());
    final MultiChildLayoutParentData childParentData =
        child!.parentData! as MultiChildLayoutParentData;
    childParentData.offset = offset;
  }

  DiagnosticsNode _debugDescribeChild(RenderBox child) {
    final MultiChildLayoutParentData childParentData =
        child.parentData! as MultiChildLayoutParentData;
    return DiagnosticsProperty<RenderBox>('${childParentData.id}', child);
  }

  void _callPerformLayout(RenderBox? firstChild) {
    Size size;
    final Map<Object, RenderBox>? previousIdToChild = _idToChild;

    Set<RenderBox>? debugPreviousChildrenNeedingLayout;
    assert(() {
      debugPreviousChildrenNeedingLayout = _debugChildrenNeedingLayout;
      _debugChildrenNeedingLayout = <RenderBox>{};
      return true;
    }());

    try {
      _idToChild = <Object, RenderBox>{};
      RenderBox? child = firstChild;
      while (child != null) {
        final MultiChildLayoutParentData childParentData =
            child.parentData! as MultiChildLayoutParentData;
        assert(() {
          if (childParentData.id == null) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary(
                  'Every child of a RenderCustomMultiChildLayoutBox must have an ID in its parent data.'),
              child!.describeForError('The following child has no ID'),
            ]);
          }
          return true;
        }());
        _idToChild![childParentData.id!] = child;
        assert(() {
          _debugChildrenNeedingLayout!.add(child!);
          return true;
        }());
        child = childParentData.nextSibling;
      }
      size = performLayout();
      assert(() {
        if (_debugChildrenNeedingLayout!.isNotEmpty) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('Each child must be laid out exactly once.'),
            DiagnosticsBlock(
              name: 'The $this custom multichild layout delegate forgot '
                  'to lay out the following '
                  '${_debugChildrenNeedingLayout!.length > 1 ? 'children' : 'child'}',
              properties: _debugChildrenNeedingLayout!
                  .map<DiagnosticsNode>(_debugDescribeChild)
                  .toList(),
            ),
          ]);
        }
        return true;
      }());
    } finally {
      _idToChild = previousIdToChild;
      assert(() {
        _debugChildrenNeedingLayout = debugPreviousChildrenNeedingLayout;
        return true;
      }());
    }
    hasBeenLaidOut = true;
    _width = size.width;
    _height = size.height;
  }

  Size performLayout();
  //void performLayout(Size size);

  Size getSize(BoxConstraints constraints) {
    return NinftyConstraints(constraints)
        .constrain(Size(_width ?? 0.0, _height ?? 0.0));
  }

  bool shouldRelayout(covariant DynamicMultiChildDelegate oldDelegate);

  @override
  String toString() => objectRuntimeType(this, 'TreeDelegate');
}

class RenderDynamicMultiChildLayoutBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  RenderDynamicMultiChildLayoutBox({
    List<RenderBox>? children,
    required DynamicMultiChildDelegate delegate,
  }) : _delegate = delegate {
    addAll(children);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  /// The delegate that controls the layout of the children.
  DynamicMultiChildDelegate get delegate => _delegate;
  DynamicMultiChildDelegate _delegate;

  set delegate(DynamicMultiChildDelegate newDelegate) {
    if (_delegate == newDelegate) {
      return;
    }
    final DynamicMultiChildDelegate oldDelegate = _delegate;
    if (newDelegate.runtimeType != oldDelegate.runtimeType ||
        newDelegate.shouldRelayout(oldDelegate)) {
      markNeedsLayout();
    }
    _delegate = newDelegate;
    if (attached) {
      oldDelegate._relayout?.removeListener(markNeedsLayout);
      newDelegate._relayout?.addListener(markNeedsLayout);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _delegate._relayout?.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _delegate._relayout?.removeListener(markNeedsLayout);
    super.detach();
  }

  //////////////////////
  //SUBTRACIONAL START//
  //////////////////////

  Size _getSize(BoxConstraints constraints) {
    assert(constraints.debugAssertIsValid());
    if (_delegate.hasBeenLaidOut == false) {
      _delegate._callPerformLayout(firstChild);
    }
    return _delegate.getSize(constraints);
  }

  // TO DO LIST: It's a bit dubious to be using the getSize function from the delegate to
  // figure out the intrinsic dimensions. We really should either not support intrinsics,
  // or we should expose intrinsic delegate callbacks and throw if they're not implemented.

  @override
  double computeMinIntrinsicWidth(double height) {
    final double width =
        _getSize(BoxConstraints.tightForFinite(height: height)).width;
    if (width.isFinite) {
      return width;
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double width =
        _getSize(BoxConstraints.tightForFinite(height: height)).width;
    if (width.isFinite) {
      return width;
    }
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double height =
        _getSize(BoxConstraints.tightForFinite(width: width)).height;
    if (height.isFinite) {
      return height;
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double height =
        _getSize(BoxConstraints.tightForFinite(width: width)).height;
    if (height.isFinite) {
      return height;
    }
    return 0.0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _getSize(constraints);
  }

  /////////////////////
  //SUBTRACTIONAL END//
  /////////////////////

  /// ** Now we assign the size of the renderbox to the accumulated size of whole children.**
  @override
  void performLayout() {
    // sets the size of the whole widget after laying out every widget
    size = _getSize(constraints);
    //delegate._callPerformLayout(size, firstChild);
    //delegate._callPerformLayout(firstChild);
    //size = _delegate.getSize(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

class DynamicMultiChildLayout extends MultiChildRenderObjectWidget {
  final DynamicMultiChildDelegate delegate;

  const DynamicMultiChildLayout({
    super.key,
    required this.delegate,
    super.children,
  });

  @override
  RenderDynamicMultiChildLayoutBox createRenderObject(BuildContext context) {
    return RenderDynamicMultiChildLayoutBox(delegate: delegate);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderDynamicMultiChildLayoutBox renderObject) {
    renderObject.delegate = delegate;
  }
}
