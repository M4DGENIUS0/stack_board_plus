// Action-related helpers for StackBoardPlus
import 'package:flutter/material.dart';
import '../core/stack_board_plus_item/stack_item.dart';
import '../core/stack_board_plus_item/stack_item_content.dart';

// Enum for item types
enum StackItemType {
  drawing,
  text,
  image,
  shape,
  all,
}

// Helper to get item type
StackItemType getItemType(StackItem<StackItemContent> item) {
  final type = item.runtimeType.toString();
  if (type == 'StackDrawItem') return StackItemType.drawing;
  if (type == 'StackTextItem') return StackItemType.text;
  if (type == 'StackImageItem') return StackItemType.image;
  if (type == 'StackShapeItem') return StackItemType.shape;
  return StackItemType.all;
}

typedef CustomActionConfig = ({
  IconData icon,
  VoidCallback onTap,
  Set<StackItemType> types,
});

List<Widget> simpleCustomActionsBuilder(
  StackItem<StackItemContent> item,
  BuildContext context,
  List<CustomActionConfig> configs,
) {
  final type = getItemType(item);
   

  return configs
      .where((config) => config.types.contains(type) || config.types.contains(StackItemType.all))
      .map((config) => MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: config.onTap,
              child: Icon(config.icon),
            ),
          ))
      .toList();
} 