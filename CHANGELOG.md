## 2.1.0
- `s_packages` dependency upgraded to ^1.3.0
- Added `onTap` callback
- Added `gradient` for gradient background support
- Added `animateVisibility` to animate show/hide transitions

## 2.0.0
- package no longer holds the source code for it, but exports/exposes the `s_packages` package instead, which will hold this package's latest source code.
- The only future changes to this package will be made via `s_packages` package dependency upgrades, in order to bring the new fixes or changes to this package
- dependent on `s_packages`: ^1.1.2


## 1.0.4 - 2025-11-29

- pubspec.yaml's package description updated

## 1.0.3 - 2025-11-29

- README updated: new screenshots (icon banners)

## 1.0.2 - 2025-11-29

- README updated

## 1.0.1

- README updated to show exmaple screenshots


## 1.0.0 - 2025-11-29

- Initial stable release.
- Adds `SBanner` widget: overlay ribbon with configurable position, color, elevation and custom content.
- Includes example usage and basic widget tests.
- Add visual example assets and more robust geometry/orientation tests.
- Support for circular child widgets via `isChildCircular` parameter.
- Banner shape adapts with curved edges to naturally wrap around circular children using quadratic Bezier curves and arcs.
- Semi-circular banners sit fully inside circular children and align their curved edge with the child's border radius.
- `childBorderRadius` parameter to override the detected radius when needed.
- Circular banners measure the child at runtime to adapt to any size changes automatically.
- Updated painter to draw smooth annular quadrants with thickness derived from the child's bounds.
- Add comprehensive test suite for circular child support.
- Update example app with circular child toggle option.
- Update README with circular child usage examples and tips.
- Initial prototype and experiments.
