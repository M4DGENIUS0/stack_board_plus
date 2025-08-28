## 0.0.7

* **Bug Fixes**
  - Fixed item position jump when updating an item; preserves original position/size/rotation reliably in `StackItemCase` interactions.
  - Fixed background resizing behavior in the example so width/height updates apply correctly.
  - Removed stray shadows from item cases in the example for a cleaner default look.

* **New**
  - Added `elevation` to `StackBoardPlus` to control the canvas Material elevation. Default is `1.0`.
  - Example updated with Background Settings slider to adjust canvas elevation live.
  - Added layering APIs in controller:
    - `moveItemOnTop`, `moveItemToBottom`, `moveItemForward`, `moveItemBackward`, `moveItemToIndex`.
  - Example now includes a Layers drawer showing a live, visual layer list with per-layer actions (to top/bottom, up/down) and item previews (text, image, color, drawing, shape).


## 0.0.6

* **Bug Fixes**
  - Fixed the bug where double-clicking on shape items directly opened the dialog box - now properly handles dynamic shape interaction behavior.

* **Code Refactoring & Architecture**
  - Completely refactored example application from a massive 3311-line single file into a clean, modular architecture.
  - Organized codebase into logical directories: `models/`, `pages/`, `dialogs/`, `widgets/`, `mixins/`, and `utils/`.
  - Improved code maintainability and debugging experience with clear separation of concerns.
  - Enhanced project structure for better development workflow and team collaboration.

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
