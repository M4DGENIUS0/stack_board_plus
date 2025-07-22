import 'package:flutter/material.dart';
import 'package:stack_board_plus/stack_board_plus_item.dart';
import 'package:stack_board_plus/stack_items.dart';

class StackImageCase extends StatelessWidget {
  const StackImageCase({
    Key? key,
    required this.item,
  }) : super(key: key);

  final StackImageItem item;

  ImageItemContent get content => item.content!;

  @override
  Widget build(BuildContext context) {
    return item.status == StackItemStatus.editing
        ? Center(
            child: TextFormField(
              initialValue: content.svgString ?? content.url ?? content.assetName ?? content.file?.path ?? '',
              onChanged: (String value) {
                // Determine which source to update based on current content
                if (content.svgString != null) {
                  item.setSvgString(value);
                } else if (content.assetName != null) {
                  item.setAssetName(value);
                } else {
                  item.setUrl(value);
                }
              },
            ),
          )
        : content.buildWidget(); // Use the enhanced buildWidget method with shimmer loading
  }}