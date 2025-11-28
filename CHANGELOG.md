## 2.0.0

* Version 2.0.0

## 1.4.0 - 2025-11-25

- **NEW**: Semi-circular banners now sit fully inside circular children and align their curved edge with the child's border radius.
- **NEW**: Added `childBorderRadius` parameter to override the detected radius when needed.
- Circular banners now measure the child at runtime to adapt to any size changes automatically.
- Updated painter to draw smooth annular quadrants with thickness derived from the child's bounds.
- Added tests to cover the new CustomPaint sizing behavior.

## 1.3.0 - 2025-11-25

- **NEW**: Add `isChildCircular` parameter to support circular child widgets
- **NEW**: Banner shape now adapts with curved edges to naturally wrap around circular children
- Improved rendering for circular shapes using quadratic Bezier curves and arcs
- Add comprehensive test suite for circular child support (9 new tests)
- Update example app with circular child toggle option
- Update README with circular child usage examples and tips

## 1.2.0 - 2025-11-25

- **BREAKING**: Remove circular child widget support (`childShape` and `circularInset` parameters)
- Simplify widget back to StatelessWidget for better performance
- Focus on rectangular children only for more reliable rendering

## 1.1.0 - 2025-11-25

- **NEW**: Add support for circular child widgets via `childShape` parameter
- **NEW**: Add `circularInset` parameter to control banner positioning on circular children
- Add `SBannerChildShape` enum with `rectangle` and `circle` options
- Improve circular rendering by clipping only the child, disabling stack clipping, and aligning the ribbon via `circularInset`
- Update example app to demonstrate both rectangular and circular children
- Add comprehensive tests for circular child support
- Update README with circular child usage examples

## 1.0.0 - 2025-11-25

- Initial stable release.
- Adds `SBanner` widget: overlay ribbon with configurable position, color, elevation and custom content.
- Includes example usage and basic widget tests.
- Add visual example assets and more robust geometry/orientation tests.

## 0.0.1 - 2025-01-01

- Initial prototype and experiments.
