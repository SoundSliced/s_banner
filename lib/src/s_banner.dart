import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A corner banner you can overlay on top of a required [child].
///
/// - [bannerContent] renders inside the angled ribbon (defaults to an empty Text).
/// - [child] is required: the base widget the banner overlays, similar to a Stack.
/// - [isActive] toggles whether the banner is shown; when false, this widget
///   simply returns [child] without additional layout cost.
/// - [clipBannerToChild] controls whether the banner is clipped to the child's
///   rectangular bounds (default: true). Set to false for stylistic overflow.
class SBanner extends StatelessWidget {
  const SBanner({
    Key? key,
    this.bannerPosition = SBannerPosition.topLeft,
    this.bannerColor = const Color.fromARGB(255, 1, 143, 1),
    this.elevation = 5,
    this.shadowColor = const Color.fromARGB(167, 0, 0, 0),
    this.bannerContent = const Text('Banner'),
    required this.child,
    this.isActive = true,
    this.clipBannerToChild = true,
  }) : super(key: key);

  /// The position where the banner is displayed.
  final SBannerPosition bannerPosition;

  /// The color of the banner, which appears behind the [bannerContent] content.
  final Color bannerColor;

  /// The elevation of the banner, which impacts the size of the shadow.
  final double elevation;

  /// The color of the shadow beneath the banner.
  final Color shadowColor;

  /// The content to draw inside the ribbon.
  final Widget bannerContent;

  /// The base widget to overlay the banner on.
  final Widget child;

  /// Whether the banner is visible. If false, returns [child] directly.
  final bool isActive;

  /// If true, clips the banner to the child's bounds. If false, allows
  /// the ribbon to paint outside the child (no clipping).
  final bool clipBannerToChild;

  @override
  Widget build(BuildContext context) {
    final banner = _BannerBox(
      bannerPosition: bannerPosition,
      bannerColor: bannerColor,
      elevation: elevation,
      shadowColor: shadowColor,
      bannerContent: bannerContent,
    );

    // If not active, avoid any extra layout/wrapping cost.
    if (!isActive) return child;

    return Stack(
      // Clip according to preference. When false, the ribbon can overflow.
      clipBehavior: clipBannerToChild ? Clip.hardEdge : Clip.none,
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: _alignmentFor(bannerPosition),
            child: banner,
          ),
        ),
      ],
    );
  }

  Alignment _alignmentFor(SBannerPosition pos) {
    if (identical(pos, SBannerPosition.topLeft)) return Alignment.topLeft;
    if (identical(pos, SBannerPosition.topRight)) return Alignment.topRight;
    if (identical(pos, SBannerPosition.bottomLeft)) return Alignment.bottomLeft;
    if (identical(pos, SBannerPosition.bottomRight))
      return Alignment.bottomRight;
    // Fallback (should not happen): default to topLeft.
    return Alignment.topLeft;
  }
}

/// Private render-object widget that draws the ribbon and lays out `bannerContent`.
class _BannerBox extends SingleChildRenderObjectWidget {
  const _BannerBox({
    Key? key,
    required this.bannerPosition,
    required this.bannerColor,
    required this.elevation,
    required this.shadowColor,
    required Widget bannerContent,
  }) : super(key: key, child: bannerContent);

  final SBannerPosition bannerPosition;
  final Color bannerColor;
  final double elevation;
  final Color shadowColor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBanner(
      bannerPosition: bannerPosition,
      bannerColor: bannerColor,
      elevation: elevation,
      shadowColor: shadowColor,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderBanner)
      ..bannerPosition = bannerPosition
      ..bannerColor = bannerColor
      ..elevation = elevation
      ..shadowColor = shadowColor;
  }
}

class _RenderBanner extends RenderBox with RenderObjectWithChildMixin {
  _RenderBanner({
    required SBannerPosition bannerPosition,
    required Color bannerColor,
    required double elevation,
    required Color shadowColor,
  })  : _bannerPosition = bannerPosition,
        _bannerColor = bannerColor,
        _elevation = elevation,
        _shadowColor = shadowColor;

  SBannerPosition _bannerPosition;
  set bannerPosition(SBannerPosition newPosition) {
    if (newPosition != _bannerPosition) {
      _bannerPosition = newPosition;
      markNeedsPaint();
    }
  }

  Color _bannerColor;
  set bannerColor(Color newColor) {
    if (newColor != _bannerColor) {
      _bannerColor = newColor;
      markNeedsPaint();
    }
  }

  double _elevation;
  set elevation(double newElevation) {
    if (newElevation != _elevation) {
      _elevation = newElevation;
      markNeedsPaint();
    }
  }

  Color _shadowColor;
  set shadowColor(Color newColor) {
    if (newColor != _shadowColor) {
      _shadowColor = newColor;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.constrain(Size.zero);
      return;
    }

    child!.layout(constraints, parentUsesSize: true);

    final childSize = (child as RenderBox).size;
    final dimension =
        _bannerPosition.calculateDistanceToFarBannerEdge(childSize);
    // Respect incoming constraints from parent (e.g., when overlaid on a child)
    // by clamping the banner's square size to the available space.
    size = constraints.constrain(Size.square(dimension));
  }

  @override
  void paint(PaintingContext paintingContext, Offset offset) {
    if (child == null) {
      return;
    }

    final childSize = (child as RenderBox).size;

    // Paint the banner.
    final bannerPath = _bannerPosition.createBannerPath(
      bannerBoundingBoxTopLeft: offset,
      contentSize: childSize,
    );

    paintingContext.canvas
      ..drawShadow(
        bannerPath,
        _shadowColor,
        _elevation,
        false,
      )
      ..drawPath(
        bannerPath,
        Paint()
          ..color = _bannerColor
          ..style = PaintingStyle.fill,
      );

    // Orient the canvas to paint the child.
    paintingContext.canvas.save();
    _bannerPosition.positionCanvasToDrawContent(
        paintingContext.canvas, offset, childSize);

    // Paint the child.
    child!.paint(paintingContext, Offset.zero);
    paintingContext.canvas.restore();
  }
}

class SBannerPosition {
  static const SBannerPosition topLeft = SBannerPosition._(_Corner.topLeft);
  static const SBannerPosition topRight = SBannerPosition._(_Corner.topRight);
  static const SBannerPosition bottomLeft =
      SBannerPosition._(_Corner.bottomLeft);
  static const SBannerPosition bottomRight =
      SBannerPosition._(_Corner.bottomRight);

  const SBannerPosition._(_Corner corner) : _corner = corner;

  final _Corner _corner;

  /// Creates the path for a banner that fits into the corner of
  /// this [SBannerPosition].
  ///
  /// [bannerBoundingBoxTopLeft] is the global screen-space offset for the top
  /// left corner of the banner's bounding box.
  Path createBannerPath({
    required Offset bannerBoundingBoxTopLeft,
    required Size contentSize,
  }) {
    final distanceToNearEdge = calculateDistanceToNearBannerEdge(contentSize);
    final distanceToFarEdge = calculateDistanceToFarBannerEdge(contentSize);

    late Path relativePath;
    switch (_corner) {
      case _Corner.topLeft:
        relativePath = Path()
          ..moveTo(0, distanceToNearEdge)
          ..lineTo(distanceToNearEdge, 0)
          ..lineTo(distanceToFarEdge, 0)
          ..lineTo(0, distanceToFarEdge)
          ..close();
        break;
      case _Corner.topRight:
        relativePath = Path()
          ..moveTo(0, 0)
          ..lineTo(distanceToFarEdge - distanceToNearEdge, 0)
          ..lineTo(distanceToFarEdge, distanceToNearEdge)
          ..lineTo(distanceToFarEdge, distanceToFarEdge)
          ..close();
        break;
      case _Corner.bottomLeft:
        relativePath = Path()
          ..moveTo(0, 0)
          ..lineTo(distanceToFarEdge, distanceToFarEdge)
          ..lineTo(distanceToNearEdge, distanceToFarEdge)
          ..lineTo(0, distanceToFarEdge - distanceToNearEdge)
          ..close();
        break;
      case _Corner.bottomRight:
        relativePath = Path()
          ..moveTo(0, distanceToFarEdge)
          ..lineTo(distanceToFarEdge, 0)
          ..lineTo(distanceToFarEdge, distanceToFarEdge - distanceToNearEdge)
          ..lineTo(distanceToFarEdge - distanceToNearEdge, distanceToFarEdge)
          ..close();
        break;
    }

    return relativePath.shift(bannerBoundingBoxTopLeft);
  }

  /// Translates and rotates the canvas such that the top-left corner of
  /// the content is drawn at the desired location on the screen, and
  /// that content is angled 45 degrees in the appropriate direction
  /// for this banner position.
  void positionCanvasToDrawContent(
      Canvas canvas, Offset paintingOffset, Size contentSize) {
    final contentOrigin = _calculateContentOrigin(paintingOffset, contentSize);
    switch (_corner) {
      case _Corner.topLeft:
        canvas
          ..translate(contentOrigin.dx, contentOrigin.dy)
          ..rotate(-pi / 4);
        break;
      case _Corner.topRight:
        canvas
          ..translate(contentOrigin.dx, contentOrigin.dy)
          ..rotate(pi / 4);
        break;
      case _Corner.bottomLeft:
        canvas
          ..translate(contentOrigin.dx, contentOrigin.dy)
          ..rotate(pi / 4);
        break;
      case _Corner.bottomRight:
        canvas
          ..translate(contentOrigin.dx, contentOrigin.dy)
          ..rotate(-pi / 4);
        break;
    }
  }

  /// Calculates the global translation that should be applied before
  /// drawing the content such that (0,0) in the content space corresponds
  /// to the top-left corner of the content in the global screen space.
  Offset _calculateContentOrigin(Offset paintingOffset, Size contentSize) {
    late Offset relativeOrigin;
    switch (_corner) {
      case _Corner.topLeft:
        relativeOrigin =
            Offset(0, calculateDistanceToNearBannerEdge(contentSize));
        break;
      case _Corner.topRight:
        relativeOrigin = Offset(
          (calculateDistanceToFarBannerEdge(contentSize) -
              calculateDistanceToNearBannerEdge(contentSize)),
          0,
        );
        break;
      case _Corner.bottomLeft:
        final leftBottomBannerCorner = Offset(
            0,
            calculateDistanceToFarBannerEdge(contentSize) -
                calculateDistanceToNearBannerEdge(contentSize));
        relativeOrigin = leftBottomBannerCorner +
            Offset(contentSize.height * sin(pi / 4),
                -contentSize.height * sin(pi / 4));
        break;
      case _Corner.bottomRight:
        final distanceToNearEdge =
            calculateDistanceToNearBannerEdge(contentSize);
        final distanceToFarEdge = calculateDistanceToFarBannerEdge(contentSize);
        final bottomRightBannerCorner =
            Offset(distanceToFarEdge - distanceToNearEdge, distanceToFarEdge);
        relativeOrigin = bottomRightBannerCorner +
            Offset(-contentSize.height * sin(pi / 4),
                -contentSize.height * sin(pi / 4));
        break;
    }

    return relativeOrigin + paintingOffset;
  }

  /// Distance from the corner to the nearest edge of the banner along
  /// the vertical or horizontal axis (the two distances are equal because
  /// the angle is 45 degrees).
  double calculateDistanceToNearBannerEdge(Size contentSize) {
    return (contentSize.width * sin(-pi / 4)).abs();
  }

  /// Distance from the corner to the furthest edge of the banner along
  /// the vertical or horizontal axis (the two distances are equal because
  /// the angle is 45 degrees).
  double calculateDistanceToFarBannerEdge(Size contentSize) {
    return calculateDistanceToNearBannerEdge(contentSize) +
        (contentSize.height / sin(-pi / 4)).abs();
  }
}

enum _Corner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
