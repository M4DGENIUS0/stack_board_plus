# Text Customization Features

This document describes the comprehensive text customization features added to the StackBoardPlus text items.

## Overview

The text customization system provides a rich set of features for styling and formatting text items, including Google Fonts integration, advanced styling options, effects, and layout controls.

## Features

### 1. Font Management
- **Google Fonts Integration**: 20 popular Google Fonts available
  - Roboto, Open Sans, Lato, Montserrat, Oswald
  - Source Sans Pro, Raleway, Poppins, Merriweather, Ubuntu
  - Playfair Display, Nunito, PT Sans, Crimson Text, Libre Baskerville
  - Dancing Script, Pacifico, Lobster, Great Vibes, Indie Flower
- **Font Size**: Adjustable from 8px to 100px with slider control
- **Font Weight**: 8 weight options (100-900)

### 2. Text Formatting
- **Bold**: Toggle bold formatting
- **Italic**: Toggle italic formatting  
- **Underline**: Toggle underline decoration
- **Text Color**: 
  - Solid colors with 12 preset options
  - Gradient colors with 6 beautiful preset gradients
- **Opacity**: Adjustable from 10% to 100%

### 3. Text Effects
- **Stroke**: 
  - Adjustable width (0-10px)
  - Customizable stroke color
- **Shadow**:
  - Blur radius (0-20px)
  - Spread radius (0-10px)
  - Offset X and Y (-10 to +10px)
  - Shadow color selection
- **Arc Text**: Curve text from -180° to +180°
- **Letter Spacing**: Adjust character spacing (-5 to +10px)
- **Word Spacing**: Adjust word spacing (-5 to +10px)
- **Line Height**: Control line spacing (0.5x to 3.0x)

### 4. Layout and Background
- **Background Color**: Optional background with transparency options
- **Border**: 
  - Adjustable width (0-10px)
  - Customizable border color
- **Padding**: Internal spacing control
- **Margin**: External spacing control

### 5. Advanced Transformations
- **Skew Transform**:
  - Skew X axis (-1.0 to +1.0)
  - Skew Y axis (-1.0 to +1.0)
- **Text Alignment**:
  - Horizontal: Left, Center, Right
  - Vertical: Start, Center, End
- **Flip Effects**:
  - Flip Horizontally
  - Flip Vertically

## Usage

### Opening the Text Customization Dialog

1. Add a text item to the board
2. Tap on the text item to open the customization dialog
3. Use the tabbed interface to access different customization categories

### Dialog Tabs

1. **Font Tab**: Font family, size, and weight selection
2. **Style Tab**: Formatting, colors, and opacity
3. **Effects Tab**: Stroke, shadow, arc, and spacing
4. **Layout Tab**: Background, border, padding, alignment, and transforms

### Live Preview

The dialog includes a real-time preview that shows all applied effects, making it easy to see changes before applying them.

## Implementation Details

### Enhanced Properties

The `TextItemContent` class has been extended with the following properties:

```dart
// Font properties
String? fontFamily;
double fontSize;
FontWeight? fontWeight;
FontStyle? fontStyle;
bool isUnderlined;

// Color and effects
Color? textColor;
Gradient? textGradient;
Color? strokeColor;
double strokeWidth;
Color? shadowColor;
Offset? shadowOffset;
double shadowBlurRadius;
double shadowSpreadRadius;

// Layout and spacing
double arcDegree;
double letterSpacing;
double wordSpacing;
Color? backgroundColor;
Color? borderColor;
double borderWidth;
double opacity;
EdgeInsets? padding;
EdgeInsets? margin;

// Transforms and alignment
double skewX;
double skewY;
TextAlign horizontalAlignment;
MainAxisAlignment verticalAlignment;
bool flipHorizontally;
bool flipVertically;
double lineHeight;
```

### Enhanced Rendering

The `_EnhancedStackTextCase` widget provides:

- Google Fonts integration with fallback support
- Gradient text rendering using `ShaderMask`
- Advanced transformations using `Transform` widget
- Shadow effects through `TextStyle.shadows`
- Container styling for background and borders
- Responsive layout with proper alignment

### JSON Serialization

All new properties are fully serializable, allowing text customizations to be saved and restored through the export/import functionality.

## Dependencies

- `google_fonts: ^6.2.1` - For Google Fonts integration

## Example Usage

```dart
// Create a customized text item
final textItem = StackTextItem(
  size: const Size(300, 100),
  content: TextItemContent(
    data: 'Custom Text',
    fontFamily: 'Pacifico',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    textColor: Colors.blue,
    shadowColor: Colors.black54,
    shadowBlurRadius: 4.0,
    shadowOffset: const Offset(2, 2),
    arcDegree: 15.0,
    letterSpacing: 1.5,
  ),
);

// Add to board
boardController.addItem(textItem);
```

## Tips and Best Practices

1. **Font Selection**: Choose fonts that match your design aesthetic
2. **Readability**: Ensure sufficient contrast between text and background
3. **Performance**: Use shadows and effects sparingly for better performance
4. **Consistency**: Maintain consistent styling across related text elements
5. **Preview**: Always use the preview to verify appearance before applying changes

This comprehensive text customization system provides professional-grade typography controls while maintaining ease of use through an intuitive interface.
