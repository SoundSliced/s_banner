# s_banner Example

This is a simple demo that showcases the `SBanner` widget and how to use it in a Flutter app.

How to run
1. Fetch dependencies:

```bash
cd example
flutter pub get
```

2. Run the example on your connected device or emulator:

```bash
flutter run
```

Screenshots
- Placeholder screenshots are included under `example/assets/` as `banner_top_left.png`, `banner_top_right.png`, `banner_bottom_left.png`, and `banner_bottom_right.png`.
  - These images were generated programmatically and illustrate a simple ribbon placed in each corner.

  Passing URL params to configure the example

  You can configure the `SBanner` position and whether it's active directly via URL parameters. The following query parameters are supported:
  - `position`: `topLeft|topRight|bottomLeft|bottomRight`
  - `active`: `true|false`

  Examples:

  ```
  http://localhost:8080/?position=topLeft&active=true
  http://localhost:8080/?position=bottomRight&active=false
  ```
  - Replace them with screenshots captured from a real device for a more representative image.

Creating your own screenshots
- Open the example app and capture screenshots on your device.
- Replace the PNG files in the `example/assets/` folder and commit the changes.

Regenerate example images programmatically

The repository includes a small helper script `example/generate_images.py` that will generate placeholder images. This requires Pillow.

```bash
# If you're using the project's venv, activate it first. Otherwise install Pillow globally or for your user:
python3 -m pip install --user Pillow
python3 example/generate_images.py
```

Note: If you run this script from the project root, it will populate `example/assets/` with images used in the README.
This folder contains a minimal Flutter application that demonstrates the `SBanner` widget.

To run the example locally, from the `example` directory run:

```bash
flutter pub get
flutter run -d <device-id>
```

The example allows you to toggle the banner on and off and change its corner position.
