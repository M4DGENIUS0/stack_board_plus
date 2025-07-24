# StackItemActionHelper Usage Guide

The `StackItemActionHelper` provides a consistent way to create custom actions for stack items while maintaining the same visual design as the built-in controls.

## Overview

The helper solves the problem of accessing `CaseStyle` and creating properly styled action buttons outside of the `StackItemCase` widget. It provides the same `_caseStyle` functionality you requested along with utility methods for common actions.

## Key Features

### 1. Access to CaseStyle (Your Main Request)

```dart
// Get the case style from context (same as StackItemCase._caseStyle)
CaseStyle style = StackItemActionHelper.getCaseStyle(context, caseStyle: widget.caseStyle);

// Check if item should show custom actions in toolbar
bool shouldShow = StackItemActionHelper.shouldShowCustomActionsInToolbar(item, style);
```

### 2. Automated Custom Actions Building

The helper automatically handles the size check logic you mentioned:

```dart
// This replaces your manual check:
// if ((item.size.width + item.size.height < style.buttonSize * 6) == false && widget.customActionsBuilder != null)

List<Widget> actions = StackItemActionHelper.buildCustomActions(
  item: item,
  context: context,
  customActionsBuilder: widget.customActionsBuilder,
  caseStyle: widget.caseStyle,
);
```

### 3. Pre-built Action Buttons

```dart
// Duplicate action
Widget duplicateButton = StackItemActionHelper.createDuplicateAction(
  item: item,
  context: context,
  onDuplicate: () => duplicateItem(item),
);

// Lock/unlock action
Widget lockButton = StackItemActionHelper.createLockAction(
  item: item,
  context: context,
  onToggleLock: () => toggleLock(item),
);

// Custom action with proper styling
Widget customButton = StackItemActionHelper.createCustomActionButton(
  context: context,
  icon: Icon(Icons.settings),
  onTap: () => showSettings(),
  tooltip: 'Settings',
);
```

## Integration with StackItemCase

The helper is already integrated into `StackItemCase._toolsCase()` method:

```dart
// In StackItemCase._toolsCase() - ALREADY IMPLEMENTED
children: [
  // Your custom actions using the helper
  ...StackItemActionHelper.buildCustomActions(
    item: item,
    context: context,
    customActionsBuilder: widget.customActionsBuilder,
    caseStyle: widget.caseStyle,
  ),
  // Built-in actions (rotate, move, delete)
  // ...
]
```

## Example Usage in Your App

```dart
StackBoardPlus(
  controller: controller,
  customActionsBuilder: (item, context) {
    return [
      // Duplicate button for specific item types
      if (item is StackTextItem || item is StackDrawItem)
        StackItemActionHelper.createDuplicateAction(
          item: item,
          context: context,
          onDuplicate: () => _duplicateItem(item),
        ),
      
      // Lock toggle for all items
      StackItemActionHelper.createLockAction(
        item: item,
        context: context,
        onToggleLock: () => _toggleItemLock(item),
      ),
      
      // Custom settings for drawing items
      if (item is StackDrawItem)
        StackItemActionHelper.createCustomActionButton(
          context: context,
          icon: Icon(Icons.brush),
          onTap: () => showDrawingSettings(item),
          tooltip: 'Drawing Settings',
        ),
    ];
  },
)
```

## Advanced Usage

### Creating Custom Tool Cases

```dart
// Create a custom tool button that matches the design system
Widget customTool = StackItemActionHelper.createToolCase(
  context,
  StackItemActionHelper.getCaseStyle(context),
  Icon(Icons.custom_icon),
);
```

### Manual Size Checking

```dart
// Check if item is large enough for toolbar actions
final style = StackItemActionHelper.getCaseStyle(context);
if (StackItemActionHelper.shouldShowCustomActionsInToolbar(item, style)) {
  // Show actions in toolbar
} else {
  // Handle small items differently
}
```

## Helper Methods Available

- `getCaseStyle(context, caseStyle)` - Get the effective case style
- `shouldShowCustomActionsInToolbar(item, style)` - Size check logic
- `buildCustomActions(...)` - Automated action building with size check
- `createToolCase(context, style, child)` - Create styled tool buttons
- `createCustomActionButton(...)` - Create custom action buttons
- `createDuplicateAction(...)` - Pre-built duplicate action
- `createLockAction(...)` - Pre-built lock/unlock action
- `createVisibilityAction(...)` - Pre-built visibility toggle

## Benefits

1. **Consistent Styling**: All custom actions match the built-in design
2. **Access to CaseStyle**: Solve your original problem of accessing `_caseStyle`
3. **Size Logic Handled**: Automatic handling of the size check condition
4. **Reusable Components**: Pre-built common actions
5. **Type Safety**: Proper TypeScript-like typing for all parameters
6. **Tooltip Support**: Built-in tooltip support for accessibility

This helper provides exactly what you needed - access to the `_caseStyle` logic and proper integration with the size-based action display logic you highlighted!
