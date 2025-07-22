# Comprehensive SVG Support in StackBoardPlus

StackBoardPlus now includes full SVG support for all image sources using the `flutter_svg` package. You can add SVG graphics from strings, network URLs, assets, and local files.

## Features

- ✅ **Multiple SVG Sources**: String content, network URLs, assets, and files
- ✅ **Automatic Detection**: SVG files are automatically detected by extension
- ✅ **Interactive SVG Items**: Full drag, resize, and rotate support
- ✅ **Color Tinting**: Apply color filters to SVG graphics
- ✅ **Fit Options**: Control how SVG scales within its bounds
- ✅ **Loading Indicators**: Progress indicators for network SVGs
- ✅ **Accessibility**: Semantic labels for screen readers
- ✅ **Serialization**: Save and load SVG items to/from JSON

## Usage Examples

### 1. SVG from String Content

```dart
final svgStringItem = StackImageItem.svg(
  svgString: '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L14.09 8.26L22 9L16 14.74L17.18 22.5L12 19.77L6.82 22.5L8 14.74L2 9L9.91 8.26L12 2Z" 
        fill="#FFD700" stroke="#FF6B35" stroke-width="2"/>
</svg>''',
  size: const Size(150, 150),
  fit: BoxFit.contain,
  semanticLabel: 'Golden Star',
);
```

### 2. SVG from Network URL

```dart
final svgNetworkItem = StackImageItem.svgNetwork(
  url: 'https://www.svgrepo.com/show/13654/heart.svg',
  size: const Size(120, 120),
  fit: BoxFit.contain,
  color: Colors.red,
  semanticLabel: 'Heart Icon',
);
```

### 3. SVG from Assets

```dart
// First, add SVG to pubspec.yaml assets:
// assets:
//   - assets/icons/

final svgAssetItem = StackImageItem.svgAsset(
  assetName: 'assets/icons/my_icon.svg',
  size: const Size(100, 100),
  fit: BoxFit.contain,
  color: Colors.blue,
  semanticLabel: 'Custom Icon',
);
```

### 4. SVG from File (Gallery/File System)

```dart
// From image picker or file system
final svgFileItem = StackImageItem.svgFile(
  file: File('/path/to/file.svg'),
  size: const Size(200, 200),
  fit: BoxFit.contain,
  color: Colors.green,
  semanticLabel: 'SVG from File',
);
```

### 5. Using Content Factories

```dart
// Alternative approach using content factories
final svgContent = ImageItemContent.svgNetwork(
  url: 'https://example.com/icon.svg',
  width: 100,
  height: 100,
  color: Colors.purple,
  fit: BoxFit.contain,
);

final svgItem = StackImageItem(
  size: const Size(100, 100),
  content: svgContent,
);
```

## Automatic SVG Detection

StackBoardPlus automatically detects SVG files by their extension:

```dart
// These will automatically render as SVG:
final networkSvg = StackImageItem(
  size: const Size(100, 100),
  content: ImageItemContent(url: 'https://example.com/image.svg'),
);

final assetSvg = StackImageItem(
  size: const Size(100, 100),
  content: ImageItemContent(assetName: 'assets/icon.svg'),
);

final fileSvg = StackImageItem(
  size: const Size(100, 100),
  content: ImageItemContent(file: File('/path/to/file.svg')),
);
```

## Mixed Usage in Gallery Picker

```dart
Future<void> _addFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) return;

  final File file = File(pickedFile.path);
  
  StackImageItem item;
  if (file.path.toLowerCase().endsWith('.svg')) {
    // Handle as SVG
    item = StackImageItem.svgFile(
      file: file,
      size: const Size(200, 200),
      fit: BoxFit.contain,
    );
  } else {
    // Handle as regular image
    item = StackImageItem(
      size: const Size(200, 200),
      content: ImageItemContent(file: file),
    );
  }

  boardController.addItem(item);
}
```

## Detection Properties

Check what type of SVG you're working with:

```dart
final content = item.content;

if (content.isSvg) {
  print('This is an SVG item');
  
  if (content.isSvgString) {
    print('SVG from string content');
  } else if (content.isSvgUrl) {
    print('SVG from URL');
  } else if (content.isSvgAsset) {
    print('SVG from assets');
  } else if (content.isSvgFile) {
    print('SVG from file');
  }
}
```

## Styling Options

All SVG types support the same styling options:

```dart
final styledSvg = StackImageItem.svgNetwork(
  url: 'https://example.com/icon.svg',
  size: const Size(150, 150),
  
  // Size and fit
  width: 120,
  height: 120,
  fit: BoxFit.contain,
  
  // Color styling
  color: Colors.blue,
  colorBlendMode: BlendMode.srcIn,
  
  // Accessibility
  semanticLabel: 'Custom Icon',
  excludeFromSemantics: false,
  
  // Text direction
  matchTextDirection: true,
  
  // Quality
  filterQuality: FilterQuality.high,
);
```

## Network SVG Features

Network SVGs include additional features:

- **Loading Indicators**: Automatic progress indicators while loading
- **Error Handling**: Graceful fallback for failed loads
- **Caching**: Automatic caching of network SVGs

## Performance Tips

1. **Local Assets**: Use assets for icons and frequently used SVGs
2. **String Content**: Use string content for simple, static SVGs
3. **Network Caching**: Network SVGs are automatically cached
4. **File Validation**: Always validate file extensions before processing
5. **Size Optimization**: Use appropriate `width` and `height` values

## Common Use Cases

### Icon Libraries
```dart
// Use SVG assets for app icons
final iconItem = StackImageItem.svgAsset(
  assetName: 'assets/icons/star.svg',
  size: const Size(48, 48),
  color: Theme.of(context).primaryColor,
);
```

### Dynamic Icons
```dart
// Load SVG icons from network
final dynamicIcon = StackImageItem.svgNetwork(
  url: 'https://api.iconify.design/mdi:heart.svg',
  size: const Size(64, 64),
  color: Colors.red,
);
```

### User Content
```dart
// Handle user-uploaded SVG files
final userSvg = StackImageItem.svgFile(
  file: userSelectedFile,
  size: const Size(300, 300),
  fit: BoxFit.contain,
);
```

### Generated Graphics
```dart
// Use programmatically generated SVG
final generatedSvg = StackImageItem.svg(
  svgString: generateSvgChart(data),
  size: const Size(400, 200),
  fit: BoxFit.contain,
);
```

## Troubleshooting

### Common Issues

**SVG not rendering:**
- Verify the SVG string/file is valid
- Check that `flutter_svg` is in dependencies
- Ensure proper `viewBox` in SVG content

**Colors not applying:**
- SVG elements with explicit colors may override filters
- Use `currentColor` in SVG for better control
- Check `colorBlendMode` settings

**Network loading issues:**
- Verify internet connectivity
- Check CORS policies for web apps
- Validate URL accessibility

**File not found:**
- Verify file paths are correct
- Check file permissions
- Ensure assets are properly declared in pubspec.yaml
