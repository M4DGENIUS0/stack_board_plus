# example

# StackBoardPlus Example

This example demonstrates how to use the StackBoardPlus package to create an interactive canvas-based application with draggable, resizable, and rotatable items.

## Features Demonstrated

- **Text Items**: Add and edit text elements with customizable styling
- **Shape Items**: Create geometric shapes (circles, rectangles, triangles, arrows)
- **Image Items**: Display images from network sources
- **Interactive Controls**: 
  - Drag items around the canvas
  - Resize items using handles
  - Rotate items
  - Select and delete items
  - Multi-selection support
- **Grid System**: Optional snap-to-grid functionality
- **Export Capabilities**: Framework for exporting the canvas

## Getting Started

1. Ensure you have Flutter installed on your system
2. Navigate to the example directory:
   ```bash
   cd example
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the example:
   ```bash
   flutter run
   ```

## Usage

### Adding Items

The example provides three types of items you can add:

- **Text**: Click "Add Text" to add a text element
- **Shape**: Click "Add Shape" to add geometric shapes
- **Image**: Click "Add Image" to add images (using placeholder images from picsum.photos)

### Interacting with Items

- **Select**: Tap on any item to select it
- **Move**: Drag selected items around the canvas
- **Delete**: Select an item and click the delete button in the app bar
- **Edit Text**: Double-tap on text items to edit their content
- **Clear All**: Use the "Clear Board" button to remove all items

### Configuration Options

The example shows how to configure the StackBoardPlus with various options:

```dart
FlexBoardConfig(
  enableMultiSelect: true,     // Allow multiple item selection
  enableSnapToGrid: true,      // Snap items to a grid
  gridSize: 20,               // Grid size in pixels
  showGrid: true,             // Show grid lines
  minItemSize: 20,            // Minimum item size
  maxItemSize: 400,           // Maximum item size
)
```

## Code Structure

- `main.dart`: Main application entry point and demo implementation
- Demonstrates proper initialization and usage of:
  - `FlexBoardController`: Main controller for managing items
  - `EnhancedFlexBoard`: The main widget for the canvas
  - `TextFlexItem`, `ShapeFlexItem`, `ImageFlexItem`: Different item types

## Customization

You can extend this example by:

1. **Adding Custom Items**: Create custom widgets and add them to the board
2. **Enhanced Text Editing**: Implement inline text editing
3. **File Import/Export**: Add functionality to save/load canvas state
4. **Additional Shape Types**: Extend the shape system with custom shapes
5. **Layer Management**: Add layer controls for z-index management
6. **Undo/Redo**: Implement undo/redo functionality
7. **Property Panels**: Add UI for editing item properties (color, size, etc.)

## Tips

- Items automatically gain selection handles when selected
- The grid system helps with precise positioning
- Network images are used for demonstration - replace with your own image sources
- The example uses placeholder images that require internet connectivity

## Next Steps

Explore the StackBoardPlus package documentation for advanced features like:
- Export to different formats (PNG, SVG, PDF)
- Custom item types
- Advanced gesture handling
- Performance optimization for large numbers of items
