import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stack_board_plus/stack_board_plus.dart';

class StackConfig {
  StackConfig({
    required this.data,
    required this.indexMap,
  });

  factory StackConfig.init() => StackConfig(
        data: <StackItem<StackItemContent>>[],
        indexMap: <String, int>{},
      );

  final List<StackItem<StackItemContent>> data;

  final Map<String, int> indexMap;

  StackItem<StackItemContent> operator [](String id) => data[indexMap[id]!];

  StackConfig copyWith({
    List<StackItem<StackItemContent>>? data,
    Map<String, int>? indexMap,
  }) {
    return StackConfig(
      data: data ?? this.data,
      indexMap: indexMap ?? this.indexMap,
    );
  }

  @override
  String toString() {
    return 'StackConfig(data: $data, indexMap: $indexMap)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StackConfig &&
        other.data.length == data.length &&
        other.indexMap.length == indexMap.length &&
        listEquals(other.data, data) &&
        mapEquals(other.indexMap, indexMap);
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(data),
      Object.hashAll(indexMap.entries),
    );
  }
}

@immutable
// ignore: must_be_immutable
class StackBoardPlusController extends SafeValueNotifier<StackConfig> {
  StackBoardPlusController({String? tag})
      : assert(tag != 'def', 'tag can not be "def"'),
        _tag = tag,
        super(StackConfig.init());

  factory StackBoardPlusController.def() => _defaultController;

  final String? _tag;

  final Map<String, int> _indexMap = <String, int>{};

  static final StackBoardPlusController _defaultController =
      StackBoardPlusController(tag: 'def');

  List<StackItem<StackItemContent>> get innerData => value.data;

  Map<String, int> get _newIndexMap => Map<String, int>.from(_indexMap);

  /// * get item by id
  StackItem<StackItemContent>? getById(String id) {
    if (!_indexMap.containsKey(id)) return null;
    return innerData[_indexMap[id]!];
  }

  /// * get index by id
  int getIndexById(String id) {
    return _indexMap[id]!;
  }

  /// * reorder index
  List<StackItem<StackItemContent>> _reorder(
      List<StackItem<StackItemContent>> data) {
    for (int i = 0; i < data.length; i++) {
      _indexMap[data[i].id] = i;
    }

    return data;
  }

  /// * add item
  void addItem(StackItem<StackItemContent> item, {bool selectIt = false}) {
    if (innerData.contains(item)) {
      print('StackBoardController addItem: item already exists');
      return;
    }

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    // Initial offset
    // `TODO`: transform this to parameters
    const double baseOffset = 50;
    const double deltaOffset = 10;
    double deltaOffsetMultiplicator = 1;

    // Set items status to idle
    data.asMap().forEach((int index, StackItem<StackItemContent> item) {
      data[index] = item.copyWith(status: StackItemStatus.idle);
    });

    // If the item has no offset, calculate the offset in order to prevent overlapping
    if (item.offset == Offset.zero) {
      for (final StackItem<StackItemContent> item in data) {
        if (item.offset.dx -
                    (item.size.width / 2) -
                    item.offset.dy -
                    (item.size.height / 2) <
                10 &&
            (item.offset.dx - item.size.width / 2) % deltaOffset < 10) {
          deltaOffsetMultiplicator =
              ((item.offset.dx - (item.size.width / 2)) / deltaOffset) + 1;
        }
      }

      data.add(item.copyWith(
          offset: Offset(
              item.size.width / 2 +
                  baseOffset +
                  deltaOffsetMultiplicator * deltaOffset,
              item.size.height / 2 +
                  baseOffset +
                  deltaOffsetMultiplicator * deltaOffset)));
    } else {
      data.add(item);
    }

    _indexMap[item.id] = data.length - 1;

    value = value.copyWith(data: data, indexMap: _newIndexMap);
  }

  /// * remove item
  void removeItem(StackItem<StackItemContent> item) {
    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    data.remove(item);
    _indexMap.remove(item.id);

    _reorder(data);

    value = value.copyWith(data: data, indexMap: _newIndexMap);
  }

  /// * remove item by id
  void removeById(String id) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    data.removeAt(_indexMap[id]!);
    _indexMap.remove(id);

    _reorder(data);

    value = value.copyWith(data: data, indexMap: _newIndexMap);
  }

  /// * select only item
  void selectOne(String id, {bool forceMoveToTop = false}) {
    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    for (int i = 0; i < data.length; i++) {
      final StackItem<StackItemContent> item = data[i];
      final bool selectedOne = item.id == id;
      // Update the status only if the item is not locked
      if (item.status != StackItemStatus.locked || selectedOne) {
        data[i] = item.copyWith(
            status:
                selectedOne ? StackItemStatus.selected : StackItemStatus.idle);
      }
    }

    if (_indexMap.containsKey(id)) {
      final StackItem<StackItemContent> item = data[_indexMap[id]!];
      if (!item.lockZOrder || forceMoveToTop) {
        data.removeAt(_indexMap[id]!);
        data.add(item);
      }
    }

    _reorder(data);

    value = value.copyWith(data: data, indexMap: _newIndexMap);
  }

  /// * update one item status
  void setItemStatus(String id, StackItemStatus status) {
    if (!_indexMap.containsKey(id)) return;

    final int index = _indexMap[id]!;

    final StackItem<StackItemContent> item = innerData[index];

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    data[index] = item.copyWith(status: status);

    value = value.copyWith(data: data);
  }

  /// * update all item status
  void setAllItemStatuses(StackItemStatus status) {
    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    for (int i = 0; i < data.length; i++) {
      final StackItem<StackItemContent> item = data[i];
      data[i] = item.copyWith(status: status);
    }

    value = value.copyWith(data: data, indexMap: _newIndexMap);
  }

  /// * move item on top
  void moveItemOnTop(String id, {bool force = false}) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final StackItem<StackItemContent> item = data[_indexMap[id]!];

    if (!item.lockZOrder || force) {
      data.removeAt(_indexMap[id]!);
      data.add(item);
    }

    _reorder(data);

    value = value.copyWith(data: data, indexMap: _newIndexMap);
  }

  /// * unselect all items
  void unSelectAll() {
    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    for (int i = 0; i < data.length; i++) {
      final StackItem<StackItemContent> item = data[i];
      if (item.status != StackItemStatus.locked) {
        data[i] = item.copyWith(
            status: item.status == StackItemStatus.editing
                ? StackItemStatus.selected
                : StackItemStatus.idle);
      }
    }

    value = value.copyWith(data: data);
  }

  /// * update basic config
  void updateBasic(String id,
      {Size? size, Offset? offset, double? angle, StackItemStatus? status}) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    data[_indexMap[id]!] = data[_indexMap[id]!].copyWith(
      size: size,
      offset: offset,
      angle: angle,
      status: status,
    );

    value = value.copyWith(data: data);
  }

  /// * update item
  void updateItem(StackItem<StackItemContent> item) {
    if (!_indexMap.containsKey(item.id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    data[_indexMap[item.id]!] = item;

    value = value.copyWith(data: data);
  }

  /// * update item content while preserving position and other properties
  void updateItemContent(String id, StackItemContent newContent) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final StackItem<StackItemContent> currentItem = data[_indexMap[id]!];
    
    // Create new item with updated content but preserve all other properties
    final StackItem<StackItemContent> updatedItem = currentItem.copyWith(
      content: newContent,
      // Preserve all existing properties
      size: currentItem.size,
      offset: currentItem.offset,
      angle: currentItem.angle,
      status: currentItem.status,
      lockZOrder: currentItem.lockZOrder,
    );

    data[_indexMap[id]!] = updatedItem;

    value = value.copyWith(data: data);
    notifyListeners();
  }

  /// * update text item content specifically
  void updateTextItemContent(String id, TextItemContent newContent) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final StackItem<StackItemContent> currentItem = data[_indexMap[id]!];
    
    if (currentItem is StackTextItem) {
      // Create new StackTextItem with updated content but preserve all other properties
      final StackTextItem updatedItem = currentItem.copyWith(
        content: newContent,
        // Preserve all existing properties
        size: currentItem.size,
        offset: currentItem.offset,
        angle: currentItem.angle,
        status: currentItem.status,
        lockZOrder: currentItem.lockZOrder,
      );

      data[_indexMap[id]!] = updatedItem;
      value = value.copyWith(data: data);
      notifyListeners();
    }
  }

  /// * update text item data specifically (just the text string)
  void updateTextItemData(String id, String newData) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final StackItem<StackItemContent> currentItem = data[_indexMap[id]!];
    
    if (currentItem is StackTextItem && currentItem.content != null) {
      // Create new TextItemContent with updated data but preserve all other content properties
      final TextItemContent updatedContent = TextItemContent(
        data: newData,
        // Preserve all existing content properties
        style: currentItem.content!.style,
        strutStyle: currentItem.content!.strutStyle,
        textAlign: currentItem.content!.textAlign,
        textDirection: currentItem.content!.textDirection,
        locale: currentItem.content!.locale,
        softWrap: currentItem.content!.softWrap,
        overflow: currentItem.content!.overflow,
        textScaleFactor: currentItem.content!.textScaleFactor,
        maxLines: currentItem.content!.maxLines,
        semanticsLabel: currentItem.content!.semanticsLabel,
        textWidthBasis: currentItem.content!.textWidthBasis,
        textHeightBehavior: currentItem.content!.textHeightBehavior,
        selectionColor: currentItem.content!.selectionColor,
        fontFamily: currentItem.content!.fontFamily,
        fontSize: currentItem.content!.fontSize,
        fontWeight: currentItem.content!.fontWeight,
        fontStyle: currentItem.content!.fontStyle,
        isUnderlined: currentItem.content!.isUnderlined,
        textColor: currentItem.content!.textColor,
        textGradient: currentItem.content!.textGradient,
        strokeColor: currentItem.content!.strokeColor,
        strokeWidth: currentItem.content!.strokeWidth,
        shadowColor: currentItem.content!.shadowColor,
        shadowOffset: currentItem.content!.shadowOffset,
        shadowBlurRadius: currentItem.content!.shadowBlurRadius,
        shadowSpreadRadius: currentItem.content!.shadowSpreadRadius,
        arcDegree: currentItem.content!.arcDegree,
        letterSpacing: currentItem.content!.letterSpacing,
        wordSpacing: currentItem.content!.wordSpacing,
        backgroundColor: currentItem.content!.backgroundColor,
        borderColor: currentItem.content!.borderColor,
        borderWidth: currentItem.content!.borderWidth,
        opacity: currentItem.content!.opacity,
        padding: currentItem.content!.padding,
        margin: currentItem.content!.margin,
        skewX: currentItem.content!.skewX,
        skewY: currentItem.content!.skewY,
        horizontalAlignment: currentItem.content!.horizontalAlignment,
        verticalAlignment: currentItem.content!.verticalAlignment,
        flipHorizontally: currentItem.content!.flipHorizontally,
        flipVertically: currentItem.content!.flipVertically,
        lineHeight: currentItem.content!.lineHeight,
      );

             // Create new StackTextItem with updated content but preserve all other properties
       final StackTextItem updatedItem = currentItem.copyWith(
         content: updatedContent,
         // Preserve all existing properties
         size: currentItem.size,
         offset: currentItem.offset,
         angle: currentItem.angle,
         status: currentItem.status,
         lockZOrder: currentItem.lockZOrder,
       );

      data[_indexMap[id]!] = updatedItem;
      value = value.copyWith(data: data);
      notifyListeners();
    }
  }

  /// * update image item content specifically
  void updateImageItemContent(String id, ImageItemContent newContent) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final StackItem<StackItemContent> currentItem = data[_indexMap[id]!];
    
    if (currentItem is StackImageItem) {
      // Create new StackImageItem with updated content but preserve all other properties
      final StackImageItem updatedItem = currentItem.copyWith(
        content: newContent,
        // Preserve all existing properties
        size: currentItem.size,
        offset: currentItem.offset,
        angle: currentItem.angle,
        status: currentItem.status,
        lockZOrder: currentItem.lockZOrder,
      );

      data[_indexMap[id]!] = updatedItem;
      value = value.copyWith(data: data);
    }
  }

  /// * update drawing item content specifically
  void updateDrawItemContent(String id, StackDrawContent newContent) {
    if (!_indexMap.containsKey(id)) return;

    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final StackItem<StackItemContent> currentItem = data[_indexMap[id]!];
    
    if (currentItem is StackDrawItem) {
      // Create new StackDrawItem with updated content but preserve all other properties
      final StackDrawItem updatedItem = currentItem.copyWith(
        content: newContent,
        // Preserve all existing properties
        size: currentItem.size,
        offset: currentItem.offset,
        angle: currentItem.angle,
        status: currentItem.status,
        lockZOrder: currentItem.lockZOrder,
      );

      data[_indexMap[id]!] = updatedItem;
      value = value.copyWith(data: data);
      notifyListeners();
    }
  }

  /// * clear
  void clear() {
    value = StackConfig.init();
    _indexMap.clear();
  }

  /// * get selected item json data
  Map<String, dynamic>? getSelectedData() {
    return innerData
        .firstWhereOrNull(
          (StackItem<StackItemContent> item) =>
              item.status == StackItemStatus.selected,
        )
        ?.toJson();
  }

  /// * get data json by id
  Map<String, dynamic>? getDataById(String id) {
    return innerData
        .firstWhereOrNull((StackItem<StackItemContent> item) => item.id == id)
        ?.toJson();
  }

  /// * get data json list by type
  List<Map<String, dynamic>>
      getTypeData<T extends StackItem<StackItemContent>>() {
    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final List<Map<String, dynamic>> list = <Map<String, dynamic>>[];

    for (int i = 0; i < data.length; i++) {
      final StackItem<StackItemContent> item = data[i];
      if (item is T) {
        final Map<String, dynamic> map = item.toJson();
        list.add(map);
      }
    }

    return list;
  }

  /// * get data json list
  List<Map<String, dynamic>> getAllData() {
    final List<StackItem<StackItemContent>> data =
        List<StackItem<StackItemContent>>.from(innerData);

    final List<Map<String, dynamic>> list = <Map<String, dynamic>>[];

    for (int i = 0; i < data.length; i++) {
      final StackItem<StackItemContent> item = data[i];
      final Map<String, dynamic> map = item.toJson();
      list.add(map);
    }

    return list;
  }

  @override
  int get hashCode => _tag.hashCode;

  @override
  bool operator ==(Object other) =>
      other is StackBoardPlusController && _tag == other._tag;

  @override
  void dispose() {
    if (_tag == 'def') {
      assert(false, 'default StackBoardController can not be disposed');
      return;
    }

    super.dispose();
  }
}
