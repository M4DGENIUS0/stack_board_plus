## 0.0.5

* **New Feature: Shape Items**
  - Added `StackShapeItem`, `StackShapeData`, and related classes to support geometric shapes (rectangle, circle, rounded rectangle, line, star, polygon, heart, half-moon).
  - Shape items support fill color, stroke color, stroke width, opacity, tilt, flipping, and endpoints (for polygons/stars).
  - Shape items are fully integrated with the stack board system and support all item management features.
  - Extensible shape editing interface via `StackShapeCase` and custom editor builder.
  - Example app updated to demonstrate adding and editing shape items.

## 0.0.4

* **New Feature: Drawing Mode**
  - Added `StackDrawItem`, `StackDrawContent`, and `StackDrawCase` to support a fully customizable drawing/canvas mode.
  - Drawing items support undo, redo, clear, export/import as JSON, and full DrawingBoard configuration (pan, zoom, background, border, gradient, etc.).
  - Drawing mode is integrated with the stack board system and supports all item management features.
  - Example and documentation updated to demonstrate drawing import/export and customization.

* **Enhanced Import/Export**
  - Improved JSON serialization for drawing and other stack items.
  - Added placeholder and structure for robust import/export of drawing data (with future extensibility for deserialization).

* **Bug Fixes & Improvements**
  - Fixed and cleaned up import statements across the codebase for better modularity and package structure.
  - Refactored helper files and removed unused/duplicate files.
  - Improved type safety and null handling in helpers.
  - Enhanced action helpers for stack items, including better type detection and custom action support.

* **Documentation**
  - Added/updated guides for drawing customization, enhanced movement, and text customization.
  - Improved code comments and usage examples for new features.


## 0.0.3

* Updated The Readme with Pre-Views.


## 0.0.2

* Bug Fixed for Some imports/exports.


## 0.0.1

* Initial release of stack_board_plus.
* Upgraded version of stack_board with enhanced features and capabilities.
* Comprehensive SVG support (string, network, asset, gallery).
* Layer management system with z-order control.
* JSON serialization for extra export/import functionality
* Cross-platform support (Android, iOS, Web, Desktop).
* Complete documentation and example application.
* [Example] Advanced text customization with Google Fonts integration (20 fonts).
* [Example] Dynamic background editor with 4-tab interface .
* [Example] Text effects: stroke, shadow, arc transformation, spacing controls.
* [Example] Transform effects: skew, flip, opacity with modern withValues(alpha:).
* [Example] Interactive double-click text editing with real-time preview.
