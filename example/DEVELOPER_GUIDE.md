# StackBoardPlus Developer Guide

## Quick Start

### 1. Add Dependency

Add StackBoardPlus to your `pubspec.yaml`:

```yaml
dependencies:
  stack_board_plus:
    path: ../  # For local development
    # git: https://github.com/M4DGENIUS0/stack_board_plus.git  # For git dependency
```

### 2. Import and Initialize

```dart
import 'package:stack_board_plus/stack_board_plus.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlexBoardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlexBoardController();
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFlexBoard(
      controller: _controller,
      config: const FlexBoardConfig(
        enableMultiSelect: true,
        enableSnapToGrid: true,
        gridSize: 20,
        showGrid: true,
      ),
      onItemSelected: (item) {
        print('Selected: ${item.id}');
      },
    );
  }
}
```

## Core Components

### FlexBoardController

The main controller that manages all items on the board.

**Key Methods:**
- `addItem(FlexBoardItem item)` - Add a new item
- `removeItem(String id)` - Remove an item by ID
- `updateItem(String id, FlexBoardItem item)` - Update an existing item
- `selectItem(String id)` - Select an item
- `deselectAll()` - Clear all selections
- `clear()` - Remove all items

### FlexBoardConfig

Configuration object for customizing board behavior.

**Key Properties:**
- `enableMultiSelect: bool` - Allow multiple item selection
- `enableSnapToGrid: bool` - Snap items to grid
- `gridSize: double` - Grid size in pixels
- `showGrid: bool` - Show grid lines
- `minItemSize: double` - Minimum item size
- `maxItemSize: double` - Maximum item size

### Item Types

#### TextFlexItem

```dart
TextFlexItem(
  id: 'text_1',
  position: const Offset(100, 100),
  size: const Size(200, 50),
  textContent: 'Hello World',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  textAlignment: TextAlign.center,
)
```

#### ShapeFlexItem

```dart
ShapeFlexItem(
  id: 'shape_1',
  position: const Offset(150, 150),
  size: const Size(100, 100),
  shape: ShapeType.circle,
  shapeColor: Colors.blue,
  strokeColor: Colors.blue.shade800,
  strokeWidth: 3,
)
```

#### ImageFlexItem

```dart
ImageFlexItem(
  id: 'image_1',
  position: const Offset(200, 200),
  size: const Size(120, 80),
  imageProvider: NetworkImage('https://example.com/image.jpg'),
  fit: BoxFit.cover,
  imageBorderColor: Colors.white,
  imageBorderWidth: 4,
  imageBorderRadius: 8,
)
```

## Event Handling

### Selection Events

```dart
EnhancedFlexBoard(
  controller: _controller,
  onItemSelected: (item) {
    // Handle single item selection
    setState(() {
      selectedItem = item;
    });
  },
  onItemsChanged: (items) {
    // Handle when items list changes
    print('Total items: ${items.length}');
  },
)
```

### Interaction Events

```dart
EnhancedFlexBoard(
  controller: _controller,
  onItemTap: (item) {
    // Handle item tap
    print('Tapped: ${item.id}');
  },
  onItemDoubleTap: (item) {
    // Handle item double tap
    if (item.type == ItemType.text) {
      _editTextItem(item);
    }
  },
)
```

## Advanced Features

### Custom Background

```dart
EnhancedFlexBoard(
  controller: _controller,
  background: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade50, Colors.purple.shade50],
      ),
    ),
  ),
)
```

### Item Manipulation

```dart
// Move an item
_controller.moveItem(itemId, Offset(deltaX, deltaY));

// Resize an item
_controller.resizeItem(itemId, Size(newWidth, newHeight));

// Rotate an item
_controller.rotateItem(itemId, angleInRadians);

// Update item properties
final updatedItem = item.copyWith(
  position: newPosition,
  size: newSize,
  rotation: newRotation,
);
_controller.updateItem(item.id, updatedItem);
```

### Multi-Selection

```dart
// Enable multi-selection in config
FlexBoardConfig(enableMultiSelect: true)

// Select multiple items
_controller.selectMultiple(['item1', 'item2', 'item3']);

// Get selected items
final selectedItems = _controller.selectedItems;
```

## Best Practices

### Performance

1. **Limit Items**: For better performance, limit the number of items on the board
2. **Image Optimization**: Use appropriately sized images
3. **Update Efficiently**: Use `copyWith()` for partial updates instead of recreating items

### User Experience

1. **Visual Feedback**: Provide visual feedback for selections and interactions
2. **Consistent Sizing**: Set appropriate min/max sizes for items
3. **Grid Alignment**: Use snap-to-grid for better alignment

### Code Organization

1. **Separate Controllers**: Use separate controllers for different boards
2. **Type Safety**: Use proper typing for item-specific properties
3. **Error Handling**: Handle edge cases like invalid positions or sizes

## Common Patterns

### Creating Items Dynamically

```dart
void createTextItem(String text, Offset position) {
  final item = TextFlexItem(
    id: 'text_${DateTime.now().millisecondsSinceEpoch}',
    position: position,
    size: const Size(150, 40),
    textContent: text,
    style: const TextStyle(fontSize: 16),
  );
  _controller.addItem(item);
}
```

### Property Panels

```dart
Widget buildPropertyPanel(FlexBoardItem selectedItem) {
  return Column(
    children: [
      Slider(
        value: selectedItem.position.dx,
        onChanged: (value) {
          final updated = selectedItem.copyWith(
            position: Offset(value, selectedItem.position.dy),
          );
          _controller.updateItem(selectedItem.id, updated);
        },
      ),
      // More property controls...
    ],
  );
}
```

### Keyboard Shortcuts

```dart
Widget buildKeyboardListener() {
  return Focus(
    autofocus: true,
    onKey: (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.delete) {
        if (selectedItem != null) {
          _controller.removeItem(selectedItem!.id);
        }
      }
      return KeyEventResult.handled;
    },
    child: EnhancedFlexBoard(controller: _controller),
  );
}
```

## Troubleshooting

### Common Issues

1. **Items not appearing**: Check if the position is within the visible area
2. **Selection not working**: Ensure the item is not locked
3. **Performance issues**: Reduce the number of items or optimize images
4. **Layout issues**: Check size constraints and container dimensions

### Debugging

```dart
// Enable debug output
_controller.addListener(() {
  print('Items: ${_controller.items.length}');
  print('Selected: ${_controller.selectedItem?.id}');
});
```
