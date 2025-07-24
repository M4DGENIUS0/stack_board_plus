# Drawing Customization Guide

The `StackDrawItem` now supports full customization of the underlying `DrawingBoard` widget. This allows you to control every aspect of the drawing experience.

## Basic Usage

```dart
final drawItem = StackDrawItem(
  size: Size(400, 400),
  content: StackDrawContent(controller: DrawingController()),
);
```

## Available Customization Options

### Display Options

- **`showDefaultActions`** (bool, default: false): Show/hide default action buttons
- **`showDefaultTools`** (bool, default: false): Show/hide default tool palette
- **`alignment`** (AlignmentGeometry, default: Alignment.topCenter): How to align the drawing content

### Interaction Options

- **`boardPanEnabled`** (bool, default: true): Enable/disable panning the canvas
- **`boardScaleEnabled`** (bool, default: true): Enable/disable zooming the canvas
- **`maxScale`** (double, default: 20): Maximum zoom level
- **`minScale`** (double, default: 0.2): Minimum zoom level
- **`boardScaleFactor`** (double, default: 200.0): Zoom sensitivity
- **`panAxis`** (PanAxis, default: PanAxis.free): Restrict panning to specific axes

### Rendering Options

- **`clipBehavior`** (Clip, default: Clip.antiAlias): How to clip the drawing area
- **`boardClipBehavior`** (Clip, default: Clip.hardEdge): How to clip the board
- **`boardConstrained`** (bool, default: false): Whether to constrain drawing to board bounds
- **`boardBoundaryMargin`** (EdgeInsets?, default: null): Margin around the board boundary

### Background Decoration Options

- **`backgroundColor`** (Color?, default: null): Background color of the drawing area
- **`backgroundImage`** (DecorationImage?, default: null): Background image for the drawing area
- **`border`** (BoxBorder?, default: null): Border around the drawing area
- **`borderRadius`** (BorderRadiusGeometry?, default: null): Rounded corners for the drawing area
- **`boxShadow`** (List<BoxShadow>?, default: null): Drop shadows for the drawing area
- **`gradient`** (Gradient?, default: null): Background gradient instead of solid color
- **`backgroundBlendMode`** (BlendMode?, default: null): How to blend background elements
- **`shape`** (BoxShape, default: BoxShape.rectangle): Shape of the drawing area (rectangle or circle)

### Event Callbacks

- **`onPointerDown`**: Called when user starts drawing
- **`onPointerMove`**: Called during drawing
- **`onPointerUp`**: Called when user stops drawing
- **`onInteractionStart`**: Called when scale/pan interaction starts
- **`onInteractionUpdate`**: Called during scale/pan interaction
- **`onInteractionEnd`**: Called when scale/pan interaction ends

### Advanced Options

- **`transformationController`**: External controller for transformations
- **`defaultToolsBuilder`**: Custom function to build default tools

## Example: Customized Drawing Canvas

```dart
void addCustomDrawingItem() {
  final drawingController = DrawingController();
  final drawContent = StackDrawContent(controller: drawingController);
  
  final drawItem = StackDrawItem(
    size: const Size(500, 400),
    content: drawContent,
    
    // Enable interactive features
    boardPanEnabled: true,
    boardScaleEnabled: true,
    maxScale: 8.0,
    minScale: 0.3,
    boardScaleFactor: 150.0,
    
    // Visual customization
    clipBehavior: Clip.antiAlias,
    boardClipBehavior: Clip.hardEdge,
    alignment: Alignment.center,
    boardConstrained: false,
    
    // Event handling
    onPointerDown: (event) {
      print('Started drawing at: ${event.localPosition}');
    },
    onPointerMove: (event) {
      print('Drawing at: ${event.localPosition}');
    },
    onPointerUp: (event) {
      print('Finished drawing at: ${event.localPosition}');
    },
    
    // Scale interaction callbacks
    onInteractionStart: (details) {
      print('Scale interaction started at: ${details.focalPoint}');
    },
    onInteractionUpdate: (details) {
      print('Scale: ${details.scale}, Rotation: ${details.rotation}');
    },
    onInteractionEnd: (details) {
      print('Scale interaction ended with velocity: ${details.velocity}');
    },
  );
  
  boardController.addItem(drawItem);
}
```

## Example: Touch-optimized Drawing

```dart
// For touch devices, you might want different settings
final touchOptimizedDrawItem = StackDrawItem(
  size: Size(600, 400),
  content: StackDrawContent(controller: DrawingController()),
  
  // Optimize for touch
  boardScaleEnabled: true,
  boardPanEnabled: true,
  maxScale: 4.0,          // Don't allow too much zoom
  minScale: 0.8,          // Don't allow too much zoom out
  boardScaleFactor: 100.0, // Less sensitive scaling
  panAxis: PanAxis.free,   // Allow free movement
  
  // Better touch feedback
  onPointerDown: (event) => HapticFeedback.lightImpact(),
);
```

## Example: Constrained Drawing Area

```dart
// For precise drawing within bounds
final constrainedDrawItem = StackDrawItem(
  size: Size(300, 300),
  content: StackDrawContent(controller: DrawingController()),
  
  // Constrain drawing
  boardConstrained: true,
  boardBoundaryMargin: EdgeInsets.all(20),
  clipBehavior: Clip.hardEdge,
  boardClipBehavior: Clip.hardEdge,
  
  // Disable pan/zoom for precise control
  boardPanEnabled: false,
  boardScaleEnabled: false,
  
  alignment: Alignment.center,
);
```

## Example: Styled Drawing Canvas with Background Decoration

```dart
// Beautiful drawing canvas with custom styling
final styledDrawItem = StackDrawItem(
  size: Size(400, 300),
  content: StackDrawContent(controller: DrawingController()),
  
  // Background styling
  backgroundColor: Colors.grey[50],
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.blue.withOpacity(0.05),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
  border: Border.all(
    color: Colors.blue.withOpacity(0.2),
    width: 1.5,
  ),
  
  // Interactive features
  boardPanEnabled: true,
  boardScaleEnabled: true,
  maxScale: 3.0,
  minScale: 0.8,
);
```

## Example: Gradient Background Canvas

```dart
// Drawing canvas with gradient background
final gradientDrawItem = StackDrawItem(
  size: Size(400, 400),
  content: StackDrawContent(controller: DrawingController()),
  
  // Gradient background instead of solid color
  gradient: LinearGradient(
    colors: [Colors.white, Colors.blue[50]!],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.blue.withOpacity(0.2),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ],
  
  // Smooth interactions
  boardPanEnabled: true,
  boardScaleEnabled: true,
  clipBehavior: Clip.antiAlias,
);
```

## Example: Textured Background Canvas

```dart
// Drawing canvas with background image/texture
final texturedDrawItem = StackDrawItem(
  size: Size(500, 400),
  content: StackDrawContent(controller: DrawingController()),
  
  // Background texture/image
  backgroundImage: DecorationImage(
    image: AssetImage('assets/paper_texture.png'),
    fit: BoxFit.cover,
    opacity: 0.15, // Subtle texture
  ),
  backgroundColor: Colors.white,
  
  // Paper-like styling
  borderRadius: BorderRadius.circular(8),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: Offset(2, 2),
    ),
  ],
  border: Border.all(
    color: Colors.grey[300]!,
    width: 1,
  ),
);
```

## Example: Circular Drawing Area

```dart
// Circular drawing canvas
final circularDrawItem = StackDrawItem(
  size: Size(300, 300), // Make sure width and height are equal for perfect circle
  content: StackDrawContent(controller: DrawingController()),
  
  // Circular shape
  shape: BoxShape.circle,
  backgroundColor: Colors.grey[100],
  
  // Circle styling
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ],
  border: Border.all(
    color: Colors.blue,
    width: 2,
  ),
  
  // Constrain drawing to circle bounds
  boardConstrained: true,
  clipBehavior: Clip.antiAlias,
);
```

## Example: Dark Theme Drawing Canvas

```dart
// Dark theme drawing canvas
final darkDrawItem = StackDrawItem(
  size: Size(400, 350),
  content: StackDrawContent(controller: DrawingController()),
  
  // Dark theme styling
  backgroundColor: Colors.grey[900],
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
    color: Colors.grey[700]!,
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ],
  
  // Dark theme interactions
  boardPanEnabled: true,
  boardScaleEnabled: true,
  clipBehavior: Clip.antiAlias,
  
  // Event handling for dark theme feedback
  onPointerDown: (event) {
    // Could trigger haptic feedback or visual effects
    HapticFeedback.lightImpact();
  },
);
```

## Integration with StackBoardPlus

All these options work seamlessly with the existing StackBoardPlus features:

- **Resize handles**: Users can still resize the drawing area using the corner handles
- **Rotation**: Drawing items can still be rotated
- **Layering**: Drawing items respect the z-order system
- **Selection**: Drawing items can be selected and edited
- **Export/Import**: All customization options are preserved during save/load

The drawing customization options only affect the drawing canvas behavior, not the item management features.
