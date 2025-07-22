# Shimmer Loading Effects

This document describes the shimmer loading effects implemented for image content in StackBoardPlus.

## Overview

The shimmer loading effect provides visual feedback to users while images are loading, creating a better user experience by indicating that content is being processed. This is especially important for network images, SVG content, and file-based images that may take time to load.

## Features

### Smart Loading Detection
- **Network Images**: Shows shimmer while downloading and processing
- **File Images**: Shows shimmer while verifying file existence and loading
- **SVG Content**: Shows shimmer for network and asset SVG files
- **Asset Images**: Minimal shimmer for very fast loading assets
- **Memory Images**: Quick shimmer for byte array processing

### Shimmer Characteristics
- **Base Color**: Light grey (`Colors.grey[300]`)
- **Highlight Color**: Very light grey (`Colors.grey[100]`)
- **Animation**: Smooth sliding shimmer effect
- **Shape**: Rounded corners matching image container
- **Size**: Matches the expected image dimensions

## Implementation

### Core Loading Methods

#### Network Images
```dart
// Uses built-in loadingBuilder for seamless integration
Image(
  image: NetworkImage(url),
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return shimmerPlaceholder;
  },
)
```

#### File Images
```dart
// Uses FutureBuilder to check file existence
FutureBuilder<bool>(
  future: _checkFileExists(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return shimmerPlaceholder;
    }
    return actualImage;
  },
)
```

#### SVG Content
```dart
// Different handling based on SVG source
if (svgString != null) {
  // Direct SVG string - no loading needed
  return svgWidget;
} else {
  // Network/asset SVG - show shimmer while loading
  return FutureBuilder<bool>(
    future: _checkSvgLoaded(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return shimmerPlaceholder;
      }
      return svgWidget;
    },
  );
}
```

### Error Handling

#### Network Error Recovery
- Automatic fallback to error icon on network failure
- Maintains shimmer during retry attempts
- Clear error indication with red error icon

#### File Not Found
- File existence verification before loading
- Graceful degradation to error state
- No infinite loading loops

#### SVG Parse Errors
- Catches SVG parsing exceptions
- Falls back to error container
- Maintains consistent error UI

## Usage Examples

### Adding Network Images with Shimmer
```dart
final networkItem = StackImageItem.url(
  url: 'https://example.com/image.jpg',
  size: const Size(200, 200),
);

// Shimmer will automatically show while loading
_boardController.add(networkItem);
```

### Adding SVG Content with Shimmer
```dart
final svgItem = StackImageItem.url(
  url: 'https://example.com/icon.svg',
  size: const Size(100, 100),
);

// Shimmer appears during SVG download and parse
_boardController.add(svgItem);
```

### File Images with Loading State
```dart
final fileItem = StackImageItem.file(
  file: File('/path/to/image.png'),
  size: const Size(150, 150),
);

// Shimmer shows during file verification and loading
_boardController.add(fileItem);
```

## Customization

### Shimmer Colors
The shimmer colors can be customized by modifying the `_buildWidgetWithShimmer()` method:

```dart
Widget shimmerPlaceholder = Container(
  width: width,
  height: height,
  child: Shimmer.fromColors(
    baseColor: Colors.grey[300]!,      // Customize base color
    highlightColor: Colors.grey[100]!, // Customize highlight color
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0), // Customize border radius
      ),
    ),
  ),
);
```

### Loading Duration
For SVG content, you can adjust the loading check duration:

```dart
Future<bool> _checkSvgLoaded() async {
  await Future.delayed(const Duration(milliseconds: 100)); // Customize delay
  return true;
}
```

## Benefits

### User Experience
- **Visual Feedback**: Users know content is loading
- **Perceived Performance**: Shimmer makes loading feel faster
- **Professional Look**: Modern loading pattern
- **Consistent Interface**: Same loading pattern across all image types

### Technical Advantages
- **Non-Blocking**: UI remains responsive during loading
- **Error Resilient**: Graceful handling of failed loads
- **Resource Efficient**: Lightweight shimmer implementation
- **Platform Consistent**: Works on all Flutter platforms

## Dependencies

This feature requires the following package:

```yaml
dependencies:
  shimmer: ^3.0.0
```

## Compatibility

- **Flutter**: 3.0.0 and above
- **Dart**: 2.17.0 and above
- **Platforms**: iOS, Android, Web, Desktop
- **Image Types**: JPEG, PNG, GIF, SVG, WebP

## Performance Considerations

### Memory Usage
- Shimmer effect is lightweight and doesn't impact memory significantly
- No additional image caching overhead
- Efficient cleanup when loading completes

### Animation Performance
- Uses Flutter's optimized Shimmer widget
- Hardware accelerated on supported devices
- Smooth 60fps animation

### Network Efficiency
- No impact on network requests
- Shimmer is purely UI-based
- Works with existing Flutter image caching

## Best Practices

### When to Use Shimmer
- Always use for network images
- Use for file images that might be large
- Use for SVG content from network sources
- Consider for local assets on slower devices

### When Shimmer Might Not Be Needed
- Very small local assets
- Images already in memory cache
- Direct SVG string content (instant rendering)

### Optimization Tips
- Keep shimmer placeholder size close to expected image size
- Use appropriate border radius for your design
- Consider shorter delays for local content
- Maintain consistent error handling patterns

## Troubleshooting

### Shimmer Not Appearing
- Check that shimmer package is properly imported
- Verify network connectivity for network images
- Ensure file paths are correct for file images

### Long Loading Times
- Check network connectivity and server response times
- Verify file sizes aren't excessively large
- Consider implementing timeout handling

### Memory Issues
- Monitor image sizes and quantities
- Implement proper image disposal
- Use appropriate image quality settings

## Future Enhancements

Potential improvements for future versions:
- Customizable shimmer patterns
- Progress indicators for large downloads
- Configurable timeout handling
- Advanced caching strategies
- Adaptive loading based on connection speed
