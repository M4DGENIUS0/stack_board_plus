import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stack_board_plus/helpers.dart';
import 'package:stack_board_plus/stack_board_plus_item.dart';
import 'package:stack_board_plus/widget_style_extension.dart';

class ImageItemContent extends StackItemContent {
  ImageItemContent({
    this.url,
    this.assetName,
    this.bytes,
    this.file,
    this.svgString,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.cover,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
  }) {
    _init();
  }

  factory ImageItemContent.fromJson(Map<String, dynamic> json) {
    return ImageItemContent(
      url: json['url'] != null ? asT<String>(json['url']) : null,
      assetName:
          json['assetName'] != null ? asT<String>(json['assetName']) : null,
      svgString:
          json['svgString'] != null ? asT<String>(json['svgString']) : null,
      semanticLabel: json['semanticLabel'] != null
          ? asT<String>(json['semanticLabel'])
          : null,
      excludeFromSemantics:
          asNullT<bool>(json['excludeFromSemantics']) ?? false,
      width: json['width'] != null ? asT<double>(json['width']) : null,
      height: json['height'] != null ? asT<double>(json['height']) : null,
      color: json['color'] != null ? Color(asT<int>(json['color'])) : null,
      colorBlendMode: json['colorBlendMode'] != null
          ? BlendMode.values[asT<int>(json['colorBlendMode'])]
          : BlendMode.srcIn,
      fit: json['fit'] != null
          ? BoxFit.values[asT<int>(json['fit'])]
          : BoxFit.cover,
      repeat: json['repeat'] != null
          ? ImageRepeat.values[asT<int>(json['repeat'])]
          : ImageRepeat.noRepeat,
      matchTextDirection: asNullT<bool>(json['matchTextDirection']) ?? false,
      gaplessPlayback: asNullT<bool>(json['gaplessPlayback']) ?? false,
      isAntiAlias: asNullT<bool>(json['isAntiAlias']) ?? true,
      filterQuality: json['filterQuality'] != null
          ? FilterQuality.values[asT<int>(json['filterQuality'])]
          : FilterQuality.high,
      bytes: json['bytes'] != null ? base64Decode(json['bytes']) : null,
      file: json['filePath'] != null ? File(json['filePath']) : null,
    );
  }

  factory ImageItemContent.svg({
    required String svgString,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.contain,
    bool matchTextDirection = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return ImageItemContent(
      svgString: svgString,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
    );
  }

  void _init() {
    final sources = {
      'url': url,
      'assetName': assetName,
      'bytes': bytes,
      'file': file,
      'svgString': svgString,
    };

    final nonNullSources = sources.entries.where((e) => e.value != null).toList();

    if (nonNullSources.length != 1) {
      final selected = nonNullSources.map((e) => e.key).join(', ');
      throw Exception(
        nonNullSources.isEmpty
            ? 'One image source must be provided: url, assetName, bytes, file, or svgString.'
            : 'Only one image source can be used at a time. Found multiple: $selected',
      );
    }

    /// Handle different image sources and detect SVG content
    if (svgString != null) {
      /// Direct SVG string provided
      _isSvg = true;
      _svgWidget = SvgPicture.string(
        svgString!,
        width: width,
        height: height,
        fit: fit,
        semanticsLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn) : null,
        matchTextDirection: matchTextDirection,
      );
    } else if (url != null) {
      /// Check if URL points to an SVG
      _isSvg = _isSvgUrl(url!);
      if (_isSvg) {
        _svgWidget = SvgPicture.network(
          url!,
          width: width,
          height: height,
          fit: fit,
          semanticsLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn) : null,
          matchTextDirection: matchTextDirection,
        );
      } else {
        /// Regular image from URL
        if (url!.startsWith('http') || url!.startsWith('https')) {
          _image = NetworkImage(url!);
        } else {
          _image = FileImage(File(url!));
        }
      }
    } else if (assetName != null) {
      /// Check if asset is an SVG
      _isSvg = _isSvgPath(assetName!);
      if (_isSvg) {
        _svgWidget = SvgPicture.asset(
          assetName!,
          width: width,
          height: height,
          fit: fit,
          semanticsLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn) : null,
          matchTextDirection: matchTextDirection,
        );
      } else {
        _image = AssetImage(assetName!);
      }
    } else if (file != null) {
      /// Check if file is an SVG
      _isSvg = _isSvgPath(file!.path);
      if (_isSvg) {
        _svgWidget = SvgPicture.file(
          file!,
          width: width,
          height: height,
          fit: fit,
          semanticsLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn) : null,
          matchTextDirection: matchTextDirection,
        );
      } else {
        _image = FileImage(file!);
      }
    } else if (bytes != null) {
      /// Check if bytes represent an SVG
      _isSvg = _isSvgBytes(bytes!);
      if (_isSvg) {
        /// Convert bytes to string for SVG
        final svgContent = utf8.decode(bytes!);
        _svgWidget = SvgPicture.string(
          svgContent,
          width: width,
          height: height,
          fit: fit,
          semanticsLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn) : null,
          matchTextDirection: matchTextDirection,
        );
      } else {
        _image = MemoryImage(bytes!);
      }
    }
  }

  /// Helper methods to detect SVG content
  bool _isSvgUrl(String url) {
    print("Checking if URL is SVG: $url");
    final uri = Uri.tryParse(url);
    if (uri != null) {
      final path = uri.path.toLowerCase();
      return path.endsWith('.svg');
    }
    return url.toLowerCase().endsWith('.svg');
  }

  bool _isSvgPath(String path) {
    return path.toLowerCase().endsWith('.svg');
  }

  bool _isSvgBytes(Uint8List bytes) {
    try {
      final content = utf8.decode(bytes);
      /// Check if content starts with SVG markers
      final trimmed = content.trim().toLowerCase();
      return trimmed.startsWith('<svg') || 
             trimmed.startsWith('<?xml') && trimmed.contains('<svg');
    } catch (e) {
      return false;
    }
  }

  late ImageProvider? _image;
  SvgPicture? _svgWidget;
  bool _isSvg = false;

  String? url;
  String? assetName;
  String? svgString;
  String? semanticLabel;
  bool excludeFromSemantics;
  double? width;
  double? height;
  Color? color;
  BlendMode? colorBlendMode;
  BoxFit fit;
  ImageRepeat repeat;
  bool matchTextDirection;
  bool gaplessPlayback;
  bool isAntiAlias;
  Uint8List? bytes;
  File? file;
  FilterQuality filterQuality;

  ImageProvider? get image => _image;
  SvgPicture? get svgWidget => _svgWidget;
  bool get isSvg => _isSvg;

  void setRes({
    String? url,
    String? assetName,
    Uint8List? bytes,
    File? file,
    String? svgString,
  }) {
    if (url != null) this.url = url;
    if (assetName != null) this.assetName = assetName;
    if (bytes != null) this.bytes = bytes;
    if (file != null) this.file = file;
    if (svgString != null) this.svgString = svgString;
    
    /// Clear previous state
    _image = null;
    _svgWidget = null;
    _isSvg = false;
    
    _init();
  }

  /// Method to build the appropriate widget
  Widget buildWidget() {
    return _buildWidgetWithShimmer();
  }

    /// Create shimmer placeholder
  Widget _buildWidgetWithShimmer() {
    Widget shimmerPlaceholder = Container(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );

    if (_isSvg && _svgWidget != null) {
      /// For SVG content
      if (svgString != null) {
        /// Direct SVG string - no loading needed
        return _svgWidget!;
      } else {
        /// Network or asset SVG - use placeholder while loading
        return FutureBuilder<bool>(
          future: _checkSvgLoaded(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return shimmerPlaceholder;
            }
            return _svgWidget!;
          },
        );
      }
    } else if (_image != null) {
      /// For regular images
      if (_image is NetworkImage) {
        /// Network image with loading state
        return Image(
          image: _image!,
          width: width,
          height: height,
          fit: fit,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          isAntiAlias: isAntiAlias,
          filterQuality: filterQuality,
          color: color,
          colorBlendMode: colorBlendMode,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return shimmerPlaceholder;
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.red),
            );
          },
        );
      } else if (_image is FileImage) {
        /// File image with loading state
        return FutureBuilder<bool>(
          future: _checkFileExists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return shimmerPlaceholder;
            }
            if (snapshot.hasError || !(snapshot.data ?? false)) {
              return Container(
                width: width,
                height: height,
                color: Colors.grey[300],
                child: const Icon(Icons.error, color: Colors.red),
              );
            }
            return Image(
              image: _image!,
              width: width,
              height: height,
              fit: fit,
              repeat: repeat,
              matchTextDirection: matchTextDirection,
              gaplessPlayback: gaplessPlayback,
              isAntiAlias: isAntiAlias,
              filterQuality: filterQuality,
              color: color,
              colorBlendMode: colorBlendMode,
              semanticLabel: semanticLabel,
              excludeFromSemantics: excludeFromSemantics,
            );
          },
        );
      } else {
        //// Asset or Memory image - minimal loading state
        return Image(
          image: _image!,
          width: width,
          height: height,
          fit: fit,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          isAntiAlias: isAntiAlias,
          filterQuality: filterQuality,
          color: color,
          colorBlendMode: colorBlendMode,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return frame == null ? shimmerPlaceholder : child;
          },
        );
      }
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  //// Simulate loading check for SVG content
  Future<bool> _checkSvgLoaded() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  Future<bool> _checkFileExists() async {
    if (file != null) {
      return await file!.exists();
    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (url != null) 'url': url,
      if (assetName != null) 'assetName': assetName,
      if (bytes != null) 'bytes': base64Encode(bytes!),
      if (file != null) 'filePath': file!.path,
      if (svgString != null) 'svgString': svgString,
      if (semanticLabel != null) 'semanticLabel': semanticLabel,
      'excludeFromSemantics': excludeFromSemantics,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (color != null) 'color': color?.value,
      if (colorBlendMode != null) 'colorBlendMode': colorBlendMode?.index,
      'fit': fit.index,
      'repeat': repeat.index,
      'matchTextDirection': matchTextDirection,
      'gaplessPlayback': gaplessPlayback,
      'isAntiAlias': isAntiAlias,
      'filterQuality': filterQuality.index,
    };
  }
}

class StackImageItem extends StackItem<ImageItemContent> {
  StackImageItem({
    required ImageItemContent? content,
    String? id,
    double? angle,
    required Size size,
    Offset? offset,
    StackItemStatus? status,
    bool? lockZOrder,
  }) : super(
          id: id,
          size: size,
          offset: offset,
          angle: angle,
          status: status,
          content: content,
          lockZOrder: lockZOrder,
        );

  factory StackImageItem.fromJson(Map<String, dynamic> data) {
    return StackImageItem(
      id: data['id'] == null ? null : asT<String>(data['id']),
      angle: data['angle'] == null ? null : asT<double>(data['angle']),
      size: jsonToSize(asMap(data['size'])),
      offset:
          data['offset'] == null ? null : jsonToOffset(asMap(data['offset'])),
      status: StackItemStatus.values[data['status'] as int],
      lockZOrder: asNullT<bool>(data['lockZOrder']) ?? false,
      content: ImageItemContent.fromJson(asMap(data['content'])),
    );
  }

  factory StackImageItem.svg({
    required String svgString,
    required Size size,
    String? id,
    double? angle,
    Offset? offset,
    StackItemStatus? status,
    bool? lockZOrder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.contain,
    bool matchTextDirection = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return StackImageItem(
      id: id,
      size: size,
      offset: offset,
      angle: angle,
      status: status,
      lockZOrder: lockZOrder,
      content: ImageItemContent.svg(
        svgString: svgString,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        matchTextDirection: matchTextDirection,
        filterQuality: filterQuality,
      ),
    );
  }

  factory StackImageItem.url({
    required String url,
    required Size size,
    String? id,
    double? angle,
    Offset? offset,
    StackItemStatus? status,
    bool? lockZOrder,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.cover,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return StackImageItem(
      id: id,
      size: size,
      offset: offset,
      angle: angle,
      status: status,
      lockZOrder: lockZOrder,
      content: ImageItemContent(
        url: url,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        filterQuality: filterQuality,
      ),
    );
  }

  factory StackImageItem.asset({
    required String assetName,
    required Size size,
    String? id,
    double? angle,
    Offset? offset,
    StackItemStatus? status,
    bool? lockZOrder,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.cover,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return StackImageItem(
      id: id,
      size: size,
      offset: offset,
      angle: angle,
      status: status,
      lockZOrder: lockZOrder,
      content: ImageItemContent(
        assetName: assetName,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        filterQuality: filterQuality,
      ),
    );
  }

  factory StackImageItem.file({
    required File file,
    required Size size,
    String? id,
    double? angle,
    Offset? offset,
    StackItemStatus? status,
    bool? lockZOrder,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.cover,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return StackImageItem(
      id: id,
      size: size,
      offset: offset,
      angle: angle,
      status: status,
      lockZOrder: lockZOrder,
      content: ImageItemContent(
        file: file,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        filterQuality: filterQuality,
      ),
    );
  }

  factory StackImageItem.bytes({
    required Uint8List bytes,
    required Size size,
    String? id,
    double? angle,
    Offset? offset,
    StackItemStatus? status,
    bool? lockZOrder,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.cover,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return StackImageItem(
      id: id,
      size: size,
      offset: offset,
      angle: angle,
      status: status,
      lockZOrder: lockZOrder,
      content: ImageItemContent(
        bytes: bytes,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        filterQuality: filterQuality,
      ),
    );
  }

  void setUrl(String url) {
    content?.setRes(url: url);
  }

  void setAssetName(String assetName) {
    content?.setRes(assetName: assetName);
  }

  void setSvgString(String svgString) {
    content?.setRes(svgString: svgString);
  }

  void setFile(File file) {
    content?.setRes(file: file);
  }

  void setBytes(Uint8List bytes) {
    content?.setRes(bytes: bytes);
  }

  @override
  StackImageItem copyWith({
    Size? size,
    Offset? offset,
    double? angle,
    StackItemStatus? status,
    bool? lockZOrder,
    ImageItemContent? content,
  }) {
    return StackImageItem(
      id: id,
      size: size ?? this.size,
      offset: offset ?? this.offset,
      angle: angle ?? this.angle,
      status: status ?? this.status,
      lockZOrder: lockZOrder ?? this.lockZOrder,
      content: content ?? this.content,
    );
  }
}