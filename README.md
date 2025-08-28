<p align="center">
  <h1 align="center">StackBoardPlus</h1>
  <p align="center">
    An advanced, stable tool for building photo editing and canvas-based apps with layers, transformations, and interactive elements.
  </p>

  <p align="center">
    <a href="https://github.com/M4DGENIUS0/stack_board_plus">
      <img src="https://img.shields.io/github/last-commit/M4DGENIUS0/stack_board_plus?style=flat&color=brightgreen" alt="Last Commit">
    </a>
    <a href="https://github.com/M4DGENIUS0/stack_board_plus">
      <img src="https://img.shields.io/github/languages/top/M4DGENIUS0/stack_board_plus?style=flat&color=blue" alt="Top Language">
    </a>
    <a href="https://github.com/M4DGENIUS0/stack_board_plus">
      <img src="https://img.shields.io/github/languages/count/M4DGENIUS0/stack_board_plus?style=flat&color=orange" alt="Languages Count">
    </a>
    <a href="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/LICENSE">
      <img src="https://img.shields.io/github/license/M4DGENIUS0/stack_board_plus?style=flat&color=blueviolet" alt="License">
    </a>
  </p>
</p>


## Features


- **Free Movement System**: Smooth, unrestricted item positioning without grid constraints
- **Interactive Elements**: Text, shapes, images, SVG graphics, and custom items
- **Shape Item Support**: Add geometric shapes (rectangle, circle, rounded rectangle, line, star, polygon, heart, half-moon) with customizable fill, stroke, opacity, tilt, and more. Enhanced interaction handling for better user experience.
- **Transform Operations**: Drag, resize, rotate with intuitive handles
- **Multi-Selection**: Select and manipulate multiple items simultaneously
- **Layer Management**: Z-index control for proper layering, plus visual Layers drawer in example
- **Grid System**: Optional snap-to-grid functionality
- **Export Capabilities**: Export canvas to various formats
- **Professional UI**: Modern, color-coded handles with visual feedback
- **Touch & Mouse Support**: Optimized for both touch and mouse interactions
- **SVG Support**: Native SVG rendering with flutter_svg integration
- **Drawing Mode**: Add freehand drawing/canvas items with full customization, undo/redo, and import/export as JSON. Drawing items support pan, zoom, background, border, gradients, and more.

Below are real examples of what you can build with StackBoardPlus:

---

<p align="center">
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/add_text.gif?raw=true" alt="Add Text" width="250"/>
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/asset_image.gif?raw=true" alt="Asset Image" width="250"/>
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/clean.gif?raw=true" alt="Clean Canvas" width="250"/>
</p>

<p align="center">
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/image_from_gallery.gif?raw=true" alt="Gallery Image" width="250"/>
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/import_export.gif?raw=true" alt="Import Export" width="250"/>
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/network_image.gif?raw=true" alt="Network Image" width="250"/>
</p>

<p align="center">
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/svg.gif?raw=true" alt="SVG Handling" width="250"/>
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/draw_feature.gif?raw=true" alt="Draw on Board" width="250"/>
  <img src="https://github.com/M4DGENIUS0/stack_board_plus/blob/main/example/assets/readme/shape.gif?raw=true" alt="Add Shapes" width="250"/>
</p>



## Enhanced Movement System

StackBoardPlus features a completely redesigned movement system that provides:

- ✅ **Smooth Free Movement** - No grid constraints during drag operations
- ✅ **Professional Handles** - Color-coded, modern design with shadows
- ✅ **Smart Interaction** - Dynamic cursors and visual feedback
- ✅ **Adaptive UI** - Handles that adapt to item size and context
- ✅ **Responsive Design** - Optimized for both desktop and mobile

See [ENHANCED_MOVEMENT.md](ENHANCED_MOVEMENT.md) for detailed information.

## Getting Started

### Installation

Add StackBoardPlus to your `pubspec.yaml`:

```yaml
dependencies:
  stack_board_plus: ^0.0.7
```
OR
```yaml
dependencies:
  stack_board_plus:
    git: https://github.com/M4DGENIUS0/stack_board_plus.git
```

### Basic Usage

```dart
import 'package:stack_board_plus/stack_board_plus.dart';

class MyCanvasApp extends StatefulWidget {
  @override
  _MyCanvasAppState createState() => _MyCanvasAppState();
}

class _MyCanvasAppState extends State<MyCanvasApp> {
  late StackBoardPlusController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StackBoardPlusController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StackBoardPlus(
        controller: _controller,
        elevation: 6.0, 
        onItemSelected: (item) {
          print('Selected: ${item.id}');
        },
      ),
    );
  }
}
```

## Examples

Check out the comprehensive examples in the `example/` directory:

- **Professional Demo** (`main.dart`): Clean, modular interface with all item types and tools
- **Modular Architecture**: Organized into `models/`, `pages/`, `dialogs/`, `widgets/`, `mixins/`, and `utils/` for easy debugging and maintenance
- **Developer Guide** (`DEVELOPER_GUIDE.md`): Technical documentation
- **Reorganization Guide** (`REORGANIZATION_README.md`): Details about the new modular structure


To run the example:

```bash
cd example
flutter pub get
flutter run
```

Or use the provided scripts:
- Windows: `run_example.bat`
- PowerShell: `run_example.ps1`

## Item Types

### Text Items
```dart
final textItem = TextStackItem(
  id: 'text_1',
  position: const Offset(100, 100),
  size: const Size(200, 50),
  textContent: 'Hello StackBoardPlus!',
  style: const TextStyle(fontSize: 18, color: Colors.black),
);
controller.addItem(textItem);
```

### Shape Items
```dart
final shapeItem = StackShapeItem(
  data: StackShapeData(
    type: StackShapeType.circle, // or rectangle, roundedRectangle, star, polygon, heart, halfMoon
    fillColor: Colors.blue,
    strokeColor: Colors.blue.shade800,
    strokeWidth: 3,
    opacity: 1.0,
    tilt: 0.0,
    width: 100,
    height: 100,
    flipHorizontal: false,
    flipVertical: false,
    endpoints: 5, // for star/polygon
  ),
  size: const Size(100, 100),
);
controller.addItem(shapeItem);
```

### Image Items
```dart
final imageItem = ImageStackItem(
  id: 'image_1',
  position: const Offset(200, 200),
  size: const Size(120, 80),
  imageProvider: NetworkImage('https://example.com/image.jpg'),
);
controller.addItem(imageItem);
```

### SVG Items
StackBoardPlus now supports comprehensive SVG rendering from multiple sources!

```dart
// 1. SVG from string content
final svgItem = StackImageItem.svg(
  svgString: '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L14.09 8.26L22 9L16 14.74L17.18 22.5L12 19.77L6.82 22.5L8 14.74L2 9L9.91 8.26L12 2Z" 
        fill="#FFD700" stroke="#FF6B35" stroke-width="2"/>
</svg>''',
  size: const Size(150, 150),
  fit: BoxFit.contain,
  semanticLabel: 'Golden Star',
);

// 2. SVG from network URL
final svgNetworkItem = StackImageItem.svgNetwork(
  url: 'https://example.com/icon.svg',
  size: const Size(120, 120),
  color: Colors.blue, // Tint color
);

// 3. SVG from assets
final svgAssetItem = StackImageItem.svgAsset(
  assetName: 'assets/icons/my_icon.svg',
  size: const Size(100, 100),
  fit: BoxFit.contain,
);

// 4. SVG from file (e.g., from gallery)
final svgFileItem = StackImageItem.svgFile(
  file: File('/path/to/file.svg'),
  size: const Size(200, 200),
  color: Colors.red,
);

// Add to board
controller.addItem(svgItem);
```

**SVG Features:**
- ✅ String content, Network URLs, Assets, and Files
- ✅ Color tinting and blend modes
- ✅ Automatic SVG detection by file extension
- ✅ Loading indicators for network SVGs
- ✅ Full transform support (drag, resize, rotate)
- ✅ Accessibility support

## Configuration

```dart
StackBoardPlusConfig(
  enableMultiSelect: true,     // Allow multiple item selection
  enableSnapToGrid: false,     // Disable for free movement
  showGrid: false,             // Hide grid for clean appearance
  minItemSize: 20,             // Minimum item size
  maxItemSize: 500,            // Maximum item size
  backgroundColor: Colors.white, // Canvas background
)
```

## Advanced Features

- **Layer Management**: Control item z-index and stacking order
  - Controller APIs: `moveItemOnTop`, `moveItemToBottom`, `moveItemForward`, `moveItemBackward`, `moveItemToIndex`
  - Example Layers drawer with previews and quick actions
- **Export System**: Export canvas to PNG, SVG, or custom formats
- **Undo/Redo**: Built-in history management
- **Custom Items**: Create your own interactive elements
- **Property Editing**: Real-time property modification
- **Keyboard Shortcuts**: Customizable key bindings

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📋 [Issues](https://github.com/M4DGENIUS0/stack_board_plus/issues) - Report bugs or request features
- 💬 [Discussions](https://github.com/M4DGENIUS0/stack_board_plus/discussions) - Community support

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and updates.

---

**StackBoardPlus** - Building the future of interactive canvas applications in Flutter 🚀
