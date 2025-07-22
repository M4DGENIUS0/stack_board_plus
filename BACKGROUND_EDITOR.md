# Background Editor for StackBoardPlus

The StackBoardPlus example now includes a comprehensive background editor that allows you to customize the canvas background dynamically.

## Features

✅ **Color Backgrounds**: Choose from predefined colors or solid backgrounds
✅ **Gradient Backgrounds**: Apply beautiful gradient presets
✅ **Image Backgrounds**: Use images from gallery or camera as background
✅ **Size Control**: Adjust canvas width and height with sliders and presets
✅ **Image Fitting**: Control how background images fit within the canvas
✅ **Crop Support**: Crop background images (when image_cropper is installed)

## How to Use

### Accessing the Background Editor

1. Look for the wallpaper icon (🖼️) in the app bar
2. Tap the icon to open the Background Editor dialog
3. Use the tabs to navigate between different customization options

### Tab Overview

#### 🎨 Color Tab
- Preview your selected background color
- Choose from 12 predefined quick colors
- Colors include: White, Black, Red, Green, Blue, Yellow, Purple, Orange, Pink, Teal, Grey, Brown

#### 🌈 Gradient Tab
- Select from 6 beautiful gradient presets:
  - Blue to Purple
  - Orange to Red
  - Green to Teal
  - Pink to Purple
  - Yellow to Orange
  - Indigo to Blue

#### 🖼️ Image Tab
- **Image Selection**: Choose from Gallery or Camera
- **Image Preview**: See how your background image looks
- **Fit Options**: Choose how the image fits the canvas:
  - `cover`: Fill the entire canvas (may crop)
  - `contain`: Fit entire image within canvas
  - `fill`: Stretch to fill canvas
  - `fitWidth`: Fit image width
  - `fitHeight`: Fit image height
  - `scaleDown`: Scale down if too large
- **Crop Function**: Crop images to perfect size (requires image_cropper package)
- **Remove Option**: Clear the background image

#### 📏 Size Tab
- **Dimension Control**: Adjust width and height with sliders (300px - 2000px)
- **Real-time Preview**: See exact dimensions as you adjust
- **Preset Sizes**: Quick selection for common formats:
  - **HD**: 1280 × 720 pixels
  - **Full HD**: 1920 × 1080 pixels
  - **Square**: 800 × 800 pixels
  - **A4**: 794 × 1123 pixels
  - **Letter**: 816 × 1056 pixels

## Implementation Details

### Background State Management

The background editor manages several state variables:

```dart
Color _backgroundColor = Colors.white;           // Solid color
Gradient? _backgroundGradient;                   // Gradient background
File? _backgroundImage;                          // Image file
double _backgroundWidth = 800.0;                 // Canvas width
double _backgroundHeight = 600.0;                // Canvas height
BoxFit _backgroundFit = BoxFit.cover;           // Image fit mode
bool _useGradient = true;                       // Use gradient flag
bool _useImage = false;                         // Use image flag
```

### Priority System

The background rendering follows this priority:
1. **Image** (if `_useImage = true` and image exists)
2. **Gradient** (if `_useGradient = true` and gradient exists)
3. **Solid Color** (fallback)

### Dynamic Background Building

```dart
Widget _buildBackground() {
  if (_useImage && _backgroundImage != null) {
    // Render image background
    return Container(/* image decoration */);
  } else if (_useGradient && _backgroundGradient != null) {
    // Render gradient background
    return Container(/* gradient decoration */);
  } else {
    // Render solid color background
    return Container(/* color decoration */);
  }
}
```

## Usage Examples

### Setting a Solid Color Background

1. Open Background Editor
2. Go to **Color** tab
3. Tap any color from the quick colors
4. Press **Apply**

### Creating a Gradient Background

1. Open Background Editor
2. Go to **Gradient** tab
3. Tap any gradient preset
4. Press **Apply**

### Using an Image Background

1. Open Background Editor
2. Go to **Image** tab
3. Tap **Gallery** or **Camera**
4. Select your image
5. Choose the **Image Fit** option
6. Optionally **Crop** the image
7. Press **Apply**

### Adjusting Canvas Size

1. Open Background Editor
2. Go to **Size** tab
3. Use sliders to adjust width/height
4. Or tap a preset size button
5. Press **Apply**

## Adding Crop Functionality

To enable image cropping, install the `image_cropper` package:

```yaml
dependencies:
  image_cropper: ^7.1.0
```

Then uncomment the crop implementation in `_cropImage()` method:

```dart
final croppedFile = await ImageCropper().cropImage(
  sourcePath: _selectedImage!.path,
  uiSettings: [
    AndroidUiSettings(
      toolbarTitle: 'Crop Background',
      toolbarColor: Colors.blue,
      toolbarWidgetColor: Colors.white,
    ),
    IOSUiSettings(
      title: 'Crop Background',
    ),
  ],
);
```

## Customization Options

### Adding More Gradient Presets

Modify the `gradients` list in `_buildGradientTab()`:

```dart
final gradients = [
  const LinearGradient(colors: [Colors.blue, Colors.purple]),
  const LinearGradient(colors: [Colors.orange, Colors.red]),
  // Add your custom gradients here
  const RadialGradient(colors: [Colors.cyan, Colors.blue]),
];
```

### Adding More Preset Sizes

Modify the preset sizes in `_buildSizeTab()`:

```dart
children: [
  {'name': 'HD', 'width': 1280.0, 'height': 720.0},
  {'name': 'Full HD', 'width': 1920.0, 'height': 1080.0},
  // Add your custom sizes here
  {'name': 'Instagram', 'width': 1080.0, 'height': 1080.0},
  {'name': 'Twitter', 'width': 1200.0, 'height': 675.0},
].map(/* ... */)
```

### Adding Color Picker

For advanced color selection, you can integrate a color picker package like `flutter_colorpicker`.

## Best Practices

1. **Performance**: Large background images may impact performance on lower-end devices
2. **Memory**: Consider image size and resolution for mobile devices
3. **Ratios**: Use appropriate aspect ratios for your use case
4. **Quality**: Balance image quality with app performance
5. **User Experience**: Provide visual feedback during image loading/processing

## Troubleshooting

**Background not updating**: Make sure to call `setState()` after background changes
**Image not displaying**: Check file permissions and path validity
**Crop not working**: Ensure image_cropper package is properly installed
**Performance issues**: Consider reducing image size or using lower resolution
