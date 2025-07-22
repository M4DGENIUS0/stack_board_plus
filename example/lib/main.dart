import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:example/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stack_board_plus/flutter_stack_board_plus.dart';
import 'package:stack_board_plus/stack_board_plus_item.dart';
import 'package:stack_board_plus/stack_case.dart';
import 'package:stack_board_plus/stack_items.dart';

class ColorContent extends StackItemContent {
  ColorContent({required this.color});

  Color color;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'color': color.value,
    };
  }
}

class ColorStackItem extends StackItem<ColorContent> {
  ColorStackItem({
    required Size size,
    String? id,
    Offset? offset,
    double? angle,
    StackItemStatus? status,
    ColorContent? content,
  }) : super(
          id: id,
          size: size,
          offset: offset,
          angle: angle,
          status: status,
          content: content,
          lockZOrder: true,
        );

  @override
  ColorStackItem copyWith({
    Size? size,
    Offset? offset,
    double? angle,
    StackItemStatus? status,
    bool? lockZOrder,
    ColorContent? content,
  }) {
    return ColorStackItem(
      id: id, // <= must !!
      size: size ?? this.size,
      offset: offset ?? this.offset,
      angle: angle ?? this.angle,
      status: status ?? this.status,
      content: content ?? this.content,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StackBoardPlusController _boardController;
  
  // Background customization variables
  Color _backgroundColor = Colors.white;
  Gradient? _backgroundGradient = const LinearGradient(
    colors: [Colors.grey, Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  File? _backgroundImage;
  double _backgroundWidth = 800.0;
  double _backgroundHeight = 600.0;
  BoxFit _backgroundFit = BoxFit.cover;
  bool _useGradient = true;  // Start with gradient as default
  bool _useImage = false;

  @override
  void initState() {
    super.initState();
    _boardController = StackBoardPlusController();
  }

  @override
  void dispose() {
    _boardController.dispose();
    super.dispose();
  }

  /// Delete intercept
  Future<void> _onDel(StackItem<StackItemContent> item) async {
    final bool? r = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange[600], size: 28),
              const SizedBox(width: 12),
              const Text(
                'Delete Item',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this item? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (r == true) {
      _boardController.removeById(item.id);
    }
  }

  /// Add text item
  void _addTextItem() {
    _boardController.addItem(
      StackTextItem(
        size: const Size(200, 100),
        content: TextItemContent(data: 'Sample Text', ),
      ),
    );
  }

  /// Add custom item
  void _addCustomItem() {
    final Color color =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    _boardController.addItem(
      ColorStackItem(
        size: const Size.square(100),
        content: ColorContent(color: color),
      ),
    );
  }
  /// Add custom item
  Future<void> _generateFromJson() async {
    final String jsonString =
        (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    if (jsonString.isEmpty) {
      _showAlertDialog(
          title: 'Clipboard is empty',
          content: 'Please copy the json string to the clipboard first');
      return;
    }
    try {
      final List<dynamic> items = jsonDecode(jsonString) as List<dynamic>;

      for (final dynamic item in items) {
        if (item['type'] == 'StackTextItem') {
          _boardController.addItem(
            StackTextItem.fromJson(item),
          );
        } else if (item['type'] == 'StackImageItem') {
          _boardController.addItem(
            StackImageItem.fromJson(item),
          );
        } 
      }
    } catch (e) {
      _showAlertDialog(title: 'Error', content: e.toString());
    }
  }

  /// get json
  Future<void> _getJson() async {
    final String json = jsonEncode(_boardController.getAllData());
    Clipboard.setData(ClipboardData(text: json));
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.code, color: Colors.blue[600]),
              const SizedBox(width: 8),
              const Text(
                'Export JSON Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'JSON data copied to clipboard!',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Preview:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        json,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addImageFromGalleryItem() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) return;

      final File imageFile = File(pickedImage.path);

      final imageItem = StackImageItem(
        size: const Size(300, 300),
        content: ImageItemContent(
          file: imageFile,
        ),
      );

      _boardController.addItem(imageItem);
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  void _addSvgItem() {
    // Example SVG string - a simple star * replace the image in constants.dart with this           
     String svgString = SVG_ASSET_IMAGE_NAME;

    final svgItem = StackImageItem.svg(
      svgString: svgString,
      size: const Size(150, 150),
      fit: BoxFit.contain,
      semanticLabel: 'Golden Star',
    );

    _boardController.addItem(svgItem);
  }

  /// Example SVG from network
  void _addSvgNetworkItem() {
    final svgNetworkItem = StackImageItem(
      size: const Size(120, 120),
      content: ImageItemContent(
        url: SVG_NETWORK_IMAGE_URL,
      ),
    );

    _boardController.addItem(svgNetworkItem);
  }

  /// Example SVG from asset
  void _addAssetItem() {
    final svgAssetItem = StackImageItem(
      size: const Size(120, 120),
      content: ImageItemContent(
        assetName: ASSET_IMAGE_NAME,
      ),
    );

    _boardController.addItem(svgAssetItem);
  }
  /// Example for image from Network
  void _addNetworkItem() {
    
    final networkItem = StackImageItem(
      size: const Size(120, 120),
      content: ImageItemContent(
        url: NETWORK_IMAGE_URL,
      ),
    );

    _boardController.addItem(networkItem);
  }

  /// Background Editor Methods
  void _openBackgroundEditor() {
    showDialog(
      context: context,
      builder: (context) => _BackgroundEditorDialog(
        backgroundColor: _backgroundColor,
        backgroundGradient: _backgroundGradient,
        backgroundImage: _backgroundImage,
        backgroundWidth: _backgroundWidth,
        backgroundHeight: _backgroundHeight,
        backgroundFit: _backgroundFit,
        useGradient: _useGradient,
        useImage: _useImage,
        onSave: (
          Color color,
          Gradient? gradient,
          File? image,
          double width,
          double height,
          BoxFit fit,
          bool useGradient,
          bool useImage,
        ) {
          setState(() {
            _backgroundColor = color;
            _backgroundGradient = gradient;
            _backgroundImage = image;
            _backgroundWidth = width;
            _backgroundHeight = height;
            _backgroundFit = fit;
            _useGradient = useGradient;
            _useImage = useImage;
          });
        },
      ),
    );
  }

  Widget _buildBackground() {
    if (_useImage && _backgroundImage != null) {
      return Container(
        width: _backgroundWidth,
        height: _backgroundHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(_backgroundImage!),
            fit: _backgroundFit,
          ),
        ),
      );
    } else if (_useGradient && _backgroundGradient != null) {
      return Container(
        width: _backgroundWidth,
        height: _backgroundHeight,
        decoration: BoxDecoration(
          gradient: _backgroundGradient,
        ),
      );
    } else {
      return Container(
        width: _backgroundWidth,
        height: _backgroundHeight,
        decoration: BoxDecoration(
          color: _backgroundColor,
        ),
      );
    }
  }

 

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Stack Board Plus Example',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openBackgroundEditor,
            icon: const Icon(Icons.wallpaper, color: Colors.white),
            tooltip: 'Background Settings',
          ),
          IconButton(
            onPressed: () => _boardController.clear(),
            icon: const Icon(Icons.clear_all, color: Colors.white),
            tooltip: 'Clear All',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[50]!, Colors.grey[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StackBoardPlus(
          onDel: _onDel,
          controller: _boardController,
          caseStyle: CaseStyle(
            frameBorderColor: Colors.blue.withOpacity(0.6),
            buttonIconColor: Colors.white,
            buttonBgColor: Colors.blue,
            buttonBorderColor: Colors.blue[700]!,
            frameBorderWidth: 2,
            buttonSize: 32,
          ),
          background: _buildBackground(),
          customBuilder: (StackItem<StackItemContent> item) {
            if (item is StackTextItem) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _EnhancedStackTextCase(
                    item: item, 
                    decoration: InputDecoration.collapsed(hintText: "Enter text"),
                    onTap: () => _openTextCustomizationDialog(item),
                  ),
                ),
              );
            } else if (item is StackImageItem) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: StackImageCase(item: item),
                ),
              );
            } else if (item is ColorStackItem) {
              return Container(
                width: item.size.width,
                height: item.size.height,
                decoration: BoxDecoration(
                  color: item.content?.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.text_fields,
                  label: 'Text',
                  color: Colors.blue,
                  onPressed: _addTextItem,
                ),
                _buildActionButton(
                  icon: Icons.image,
                  label: 'Network Image',
                  color: Colors.green,
                  onPressed: _addNetworkItem,
                ),
                _buildActionButton(
                  icon: Icons.image,
                  label: 'Asset Image',
                  color: Colors.green,
                  onPressed: _addAssetItem,
                ),
                _buildActionButton(
                  icon: Icons.add_photo_alternate,
                  label: 'Gallery',
                  color: Colors.purple,
                  onPressed: _addImageFromGalleryItem,
                ),
                _buildActionButton(
                  icon: Icons.star,
                  label: 'SVG',
                  color: Colors.amber,
                  onPressed: _addSvgItem,
                ),
                _buildActionButton(
                  icon: Icons.file_upload,
                  label: 'SVG Network',
                  color: Colors.blue,
                  onPressed: _addSvgNetworkItem,
                ),
                _buildActionButton(
                  icon: Icons.palette,
                  label: 'Color',
                  color: Colors.orange,
                  onPressed: _addCustomItem,
                ),
                _buildActionButton(
                  icon: Icons.file_download,
                  label: 'Export',
                  color: Colors.teal,
                  onPressed: _getJson,
                ),
                _buildActionButton(
                  icon: Icons.file_upload,
                  label: 'Import',
                  color: Colors.indigo,
                  onPressed: _generateFromJson,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: color, size: 24),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Text Customization Methods
  void _openTextCustomizationDialog(StackTextItem item) {
    showDialog(
      context: context,
      builder: (context) => _TextCustomizationDialog(
        item: item,
        onSave: (updatedContent) {
          setState(() {
            // Create a new item with updated content
            final updatedItem = item.copyWith(content: updatedContent);
            _boardController.removeById(item.id);
            _boardController.addItem(updatedItem);
          });
        },
      ),
    );
  }

  void _showAlertDialog({required String title, required String content}) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _EnhancedStackTextCase extends StatefulWidget {
  const _EnhancedStackTextCase({
    Key? key,
    required this.item,
    this.decoration,
    this.onTap,
  }) : super(key: key);

  final StackTextItem item;
  final InputDecoration? decoration;
  final VoidCallback? onTap;

  @override
  _EnhancedStackTextCaseState createState() => _EnhancedStackTextCaseState();
}

class _EnhancedStackTextCaseState extends State<_EnhancedStackTextCase> {
  bool _isHovered = false;

  TextItemContent? get content => widget.item.content;

  @override
  Widget build(BuildContext context) {
    return widget.item.status == StackItemStatus.editing
        ? _buildEditing(context)
        : _buildNormal(context);
  }

  Widget _buildNormal(BuildContext context) {
    final content = this.content;
    if (content == null) return const SizedBox.shrink();

    // Build the base text widget with enhanced styling
    Widget textWidget = _buildEnhancedText(content);

    // Apply container styling (background, border, padding)
    if (content.backgroundColor != null || 
        content.borderWidth > 0 || 
        content.padding != null) {
      textWidget = Container(
        padding: content.padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: content.backgroundColor,
          border: content.borderWidth > 0 && content.borderColor != null
              ? Border.all(color: content.borderColor!, width: content.borderWidth)
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: textWidget,
      );
    }

    // Apply margin
    if (content.margin != null) {
      textWidget = Padding(
        padding: content.margin!,
        child: textWidget,
      );
    }

    // Apply transformations (skew, flip)
    if (content.skewX != 0 || content.skewY != 0 || 
        content.flipHorizontally || content.flipVertically) {
      textWidget = Transform(
        transform: Matrix4.identity()
          ..setEntry(0, 1, content.skewX)
          ..setEntry(1, 0, content.skewY)
          ..scale(
            content.flipHorizontally ? -1.0 : 1.0, 
            content.flipVertically ? -1.0 : 1.0
          ),
        alignment: Alignment.center,
        child: textWidget,
      );
    }

    // Apply opacity
    if (content.opacity < 1.0) {
      textWidget = Opacity(
        opacity: content.opacity,
        child: textWidget,
      );
    }

    // Apply arc transformation if needed
    if (content.arcDegree != 0) {
      textWidget = Transform.rotate(
        angle: content.arcDegree * (3.14159 / 180), // Convert degrees to radians
        child: textWidget,
      );
    }

    // Add tap gesture for customization
    if (widget.onTap != null) {
      textWidget = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          onDoubleTap: widget.onTap, // Also respond to double tap
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isHovered ? Colors.blue.withOpacity(0.3) : Colors.transparent, 
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: textWidget,
              ),
              if (_isHovered)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Wrap in alignment container
    return Container(
      alignment: _getAlignment(content.horizontalAlignment, content.verticalAlignment),
      child: FittedBox(child: textWidget),
    );
  }

  Widget _buildEditing(BuildContext context) {
    // When in editing mode, immediately open the customization dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onTap != null) {
        widget.onTap!();
      }
    });
    
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(4),
          color: Colors.blue.withOpacity(0.1),
        ),
        child: Text(
          content?.data ?? 'Tap to customize',
          style: content?.style?.copyWith(color: Colors.blue) ?? 
                 const TextStyle(color: Colors.blue),
          textAlign: content?.textAlign ?? TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildEnhancedText(TextItemContent content) {
    // Create text style with enhanced properties using Google Fonts
    TextStyle baseStyle;
    
    try {
      baseStyle = GoogleFonts.getFont(
        content.fontFamily ?? 'Roboto',
        fontSize: content.fontSize,
        fontWeight: content.fontWeight,
        fontStyle: content.fontStyle,
        letterSpacing: content.letterSpacing,
        wordSpacing: content.wordSpacing,
        height: content.lineHeight,
        decoration: content.isUnderlined ? TextDecoration.underline : null,
        decorationColor: content.textColor,
        shadows: _buildShadows(content),
      );
    } catch (e) {
      // Fallback to default font if Google Font fails
      baseStyle = TextStyle(
        fontFamily: content.fontFamily,
        fontSize: content.fontSize,
        fontWeight: content.fontWeight,
        fontStyle: content.fontStyle,
        letterSpacing: content.letterSpacing,
        wordSpacing: content.wordSpacing,
        height: content.lineHeight,
        decoration: content.isUnderlined ? TextDecoration.underline : null,
        decorationColor: content.textColor,
        shadows: _buildShadows(content),
      );
    }

    // Combine with existing style if any
    final finalStyle = content.style?.merge(baseStyle) ?? baseStyle;

    final text = content.data ?? '';

    // Handle gradient text
    if (content.textGradient != null) {
      return ShaderMask(
        shaderCallback: (bounds) => content.textGradient!.createShader(bounds),
        child: Text(
          text,
          style: finalStyle.copyWith(color: Colors.white),
          textAlign: content.textAlign ?? content.horizontalAlignment,
          textDirection: content.textDirection,
          locale: content.locale,
          softWrap: content.softWrap,
          overflow: content.overflow,
          textScaler: content.textScaleFactor != null
              ? TextScaler.linear(content.textScaleFactor!)
              : TextScaler.noScaling,
          maxLines: content.maxLines,
          semanticsLabel: content.semanticsLabel,
          textWidthBasis: content.textWidthBasis,
          textHeightBehavior: content.textHeightBehavior,
          selectionColor: content.selectionColor,
        ),
      );
    } else {
      // Regular text with color
      return Text(
        text,
        style: finalStyle.copyWith(
          color: content.textColor?.withValues(alpha: content.opacity) ?? 
                 finalStyle.color?.withValues(alpha: content.opacity),
        ),
        textAlign: content.textAlign ?? content.horizontalAlignment,
        textDirection: content.textDirection,
        locale: content.locale,
        softWrap: content.softWrap,
        overflow: content.overflow,
        textScaler: content.textScaleFactor != null
            ? TextScaler.linear(content.textScaleFactor!)
            : TextScaler.noScaling,
        maxLines: content.maxLines,
        semanticsLabel: content.semanticsLabel,
        textWidthBasis: content.textWidthBasis,
        textHeightBehavior: content.textHeightBehavior,
        selectionColor: content.selectionColor,
      );
    }
  }

  List<Shadow>? _buildShadows(TextItemContent content) {
    if (content.shadowBlurRadius <= 0 || content.shadowColor == null) {
      return null;
    }

    return [
      Shadow(
        color: content.shadowColor!,
        offset: content.shadowOffset ?? const Offset(1, 1),
        blurRadius: content.shadowBlurRadius,
      ),
    ];
  }

  Alignment _getAlignment(TextAlign horizontal, MainAxisAlignment vertical) {
    double x = 0.0;
    double y = 0.0;

    // Horizontal alignment
    switch (horizontal) {
      case TextAlign.left:
        x = -1.0;
        break;
      case TextAlign.center:
        x = 0.0;
        break;
      case TextAlign.right:
        x = 1.0;
        break;
      case TextAlign.start:
        x = -1.0;
        break;
      case TextAlign.end:
        x = 1.0;
        break;
      case TextAlign.justify:
        x = 0.0;
        break;
    }

    // Vertical alignment
    switch (vertical) {
      case MainAxisAlignment.start:
        y = -1.0;
        break;
      case MainAxisAlignment.center:
        y = 0.0;
        break;
      case MainAxisAlignment.end:
        y = 1.0;
        break;
      case MainAxisAlignment.spaceAround:
      case MainAxisAlignment.spaceBetween:
      case MainAxisAlignment.spaceEvenly:
        y = 0.0;
        break;
    }

    return Alignment(x, y);
  }
}

class _TextCustomizationDialog extends StatefulWidget {
  final StackTextItem item;
  final Function(TextItemContent) onSave;

  const _TextCustomizationDialog({
    Key? key,
    required this.item,
    required this.onSave,
  }) : super(key: key);

  @override
  _TextCustomizationDialogState createState() => _TextCustomizationDialogState();
}

class _TextCustomizationDialogState extends State<_TextCustomizationDialog> {
  late TextEditingController _textController;
  
  // Text properties
  String _fontFamily = 'Roboto';
  double _fontSize = 16.0;
  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _fontStyle = FontStyle.normal;
  bool _isUnderlined = false;
  Color _textColor = Colors.black;
  bool _useGradientText = false;
  Gradient? _textGradient;
  
  // Stroke
  Color _strokeColor = Colors.transparent;
  double _strokeWidth = 0.0;
  
  // Shadow
  Color _shadowColor = Colors.black54;
  Offset _shadowOffset = const Offset(1, 1);
  double _shadowBlurRadius = 2.0;
  double _shadowSpreadRadius = 0.0;
  
  // Arc and spacing
  double _arcDegree = 0.0;
  double _letterSpacing = 0.0;
  double _wordSpacing = 0.0;
  double _lineHeight = 1.0;
  
  // Background and border
  Color? _backgroundColor;
  Color? _borderColor;
  double _borderWidth = 0.0;
  
  // Transform and alignment
  double _opacity = 1.0;
  EdgeInsets _padding = EdgeInsets.zero;
  EdgeInsets _margin = EdgeInsets.zero;
  double _skewX = 0.0;
  double _skewY = 0.0;
  TextAlign _horizontalAlignment = TextAlign.center;
  MainAxisAlignment _verticalAlignment = MainAxisAlignment.center;
  bool _flipHorizontally = false;
  bool _flipVertically = false;
  
  int _selectedTab = 0;

  // Google Fonts list (20 popular fonts)
  final List<String> _fontFamilies = [
    'Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Oswald',
     'Raleway', 'Poppins', 'Merriweather', 'Ubuntu',
    'Playfair Display', 'Nunito', 'PT Sans', 'Crimson Text', 'Libre Baskerville',
    'Dancing Script', 'Pacifico', 'Lobster', 'Great Vibes', 'Indie Flower'
  ];

  @override
  void initState() {
    super.initState();
    _initializeFromItem();
  }

  void _initializeFromItem() {
    final content = widget.item.content;
    if (content != null) {
      _textController = TextEditingController(text: content.data ?? '');
      _fontFamily = content.fontFamily ?? 'Roboto';
      _fontSize = content.fontSize;
      _fontWeight = content.fontWeight ?? FontWeight.normal;
      _fontStyle = content.fontStyle ?? FontStyle.normal;
      _isUnderlined = content.isUnderlined;
      _textColor = content.textColor ?? Colors.black;
      _textGradient = content.textGradient;
      _useGradientText = content.textGradient != null;
      _strokeColor = content.strokeColor ?? Colors.transparent;
      _strokeWidth = content.strokeWidth;
      _shadowColor = content.shadowColor ?? Colors.black54;
      _shadowOffset = content.shadowOffset ?? const Offset(1, 1);
      _shadowBlurRadius = content.shadowBlurRadius;
      _shadowSpreadRadius = content.shadowSpreadRadius;
      _arcDegree = content.arcDegree;
      _letterSpacing = content.letterSpacing;
      _wordSpacing = content.wordSpacing;
      _lineHeight = content.lineHeight;
      _backgroundColor = content.backgroundColor;
      _borderColor = content.borderColor;
      _borderWidth = content.borderWidth;
      _opacity = content.opacity;
      _padding = content.padding ?? EdgeInsets.zero;
      _margin = content.margin ?? EdgeInsets.zero;
      _skewX = content.skewX;
      _skewY = content.skewY;
      _horizontalAlignment = content.horizontalAlignment;
      _verticalAlignment = content.verticalAlignment;
      _flipHorizontally = content.flipHorizontally;
      _flipVertically = content.flipVertically;
    } else {
      _textController = TextEditingController(text: 'Sample Text');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Text Customization',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Text Input
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Preview
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(child: _buildPreviewText()),
            ),
            const SizedBox(height: 16),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildTabButton('Font', 0, Icons.font_download),
                  _buildTabButton('Style', 1, Icons.format_paint),
                  _buildTabButton('Effects', 2, Icons.auto_awesome),
                  _buildTabButton('Layout', 3, Icons.view_agenda),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _buildTabContent(),
            ),

            // Buttons
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildFontTab();
      case 1:
        return _buildStyleTab();
      case 2:
        return _buildEffectsTab();
      case 3:
        return _buildLayoutTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildFontTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Font Family
          const Text('Font Family', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            height: 120,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _fontFamilies.length,
              itemBuilder: (context, index) {
                final font = _fontFamilies[index];
                return GestureDetector(
                  onTap: () => setState(() => _fontFamily = font),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _fontFamily == font ? Colors.blue : Colors.grey[300]!,
                        width: _fontFamily == font ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        font,
                        style: GoogleFonts.getFont(font, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Font Size
          const Text('Font Size', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 8,
                  max: 100,
                  divisions: 92,
                  label: _fontSize.toInt().toString(),
                  onChanged: (value) => setState(() => _fontSize = value),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text('${_fontSize.toInt()}px'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Font Weight
          const Text('Font Weight', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FontWeight.w100,
              FontWeight.w300,
              FontWeight.normal,
              FontWeight.w500,
              FontWeight.w600,
              FontWeight.bold,
              FontWeight.w800,
              FontWeight.w900,
            ].map((weight) => ChoiceChip(
              label: Text('${weight.index + 1}00'),
              selected: _fontWeight == weight,
              onSelected: (selected) => setState(() => _fontWeight = weight),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Format Options
          const Text('Format', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CheckboxListTile(
            title: const Text('Bold'),
            value: _fontWeight == FontWeight.bold,
            onChanged: (value) => setState(() => 
              _fontWeight = value! ? FontWeight.bold : FontWeight.normal),
          ),
          CheckboxListTile(
            title: const Text('Italic'),
            value: _fontStyle == FontStyle.italic,
            onChanged: (value) => setState(() => 
              _fontStyle = value! ? FontStyle.italic : FontStyle.normal),
          ),
          CheckboxListTile(
            title: const Text('Underline'),
            value: _isUnderlined,
            onChanged: (value) => setState(() => _isUnderlined = value!),
          ),
          const SizedBox(height: 16),

          // Text Color
          const Text('Text Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Switch(
                value: _useGradientText,
                onChanged: (value) => setState(() => _useGradientText = value),
              ),
              Text(_useGradientText ? 'Gradient' : 'Solid Color'),
            ],
          ),
          const SizedBox(height: 8),
          
          if (!_useGradientText) ...[
            // Solid Colors
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Colors.black, Colors.white, Colors.red, Colors.green,
                Colors.blue, Colors.yellow, Colors.purple, Colors.orange,
                Colors.pink, Colors.teal, Colors.grey, Colors.brown,
              ].map((color) => GestureDetector(
                onTap: () => setState(() => _textColor = color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _textColor == color ? Colors.blue : Colors.grey[300]!,
                      width: _textColor == color ? 3 : 1,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ] else ...[
            // Gradient Options
            Text('Gradient Presets'),
            const SizedBox(height: 8),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  final gradients = [
                    const LinearGradient(colors: [Colors.red, Colors.orange]),
                    const LinearGradient(colors: [Colors.blue, Colors.purple]),
                    const LinearGradient(colors: [Colors.green, Colors.teal]),
                    const LinearGradient(colors: [Colors.pink, Colors.purple]),
                    const LinearGradient(colors: [Colors.yellow, Colors.orange]),
                    const LinearGradient(colors: [Colors.indigo, Colors.blue]),
                  ];
                  final gradient = gradients[index];
                  return GestureDetector(
                    onTap: () => setState(() => _textGradient = gradient),
                    child: Container(
                      width: 60,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _textGradient == gradient ? Colors.blue : Colors.grey[300]!,
                          width: _textGradient == gradient ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Opacity
          const Text('Opacity', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _opacity,
            min: 0.1,
            max: 1.0,
            divisions: 18,
            label: '${(_opacity * 100).toInt()}%',
            onChanged: (value) => setState(() => _opacity = value),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stroke
          const Text('Stroke', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Width:'),
              Expanded(
                child: Slider(
                  value: _strokeWidth,
                  min: 0,
                  max: 10,
                  divisions: 20,
                  label: _strokeWidth.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _strokeWidth = value),
                ),
              ),
            ],
          ),
          if (_strokeWidth > 0) ...[
            const Text('Stroke Color:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Colors.black, Colors.white, Colors.red, Colors.green,
                Colors.blue, Colors.yellow, Colors.purple, Colors.orange,
              ].map((color) => GestureDetector(
                onTap: () => setState(() => _strokeColor = color),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _strokeColor == color ? Colors.blue : Colors.grey[300]!,
                      width: _strokeColor == color ? 2 : 1,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
          const SizedBox(height: 16),

          // Shadow
          const Text('Shadow', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Blur:'),
              Expanded(
                child: Slider(
                  value: _shadowBlurRadius,
                  min: 0,
                  max: 20,
                  divisions: 20,
                  label: _shadowBlurRadius.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _shadowBlurRadius = value),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Spread:'),
              Expanded(
                child: Slider(
                  value: _shadowSpreadRadius,
                  min: 0,
                  max: 10,
                  divisions: 20,
                  label: _shadowSpreadRadius.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _shadowSpreadRadius = value),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Offset X:'),
              Expanded(
                child: Slider(
                  value: _shadowOffset.dx,
                  min: -10,
                  max: 10,
                  divisions: 20,
                  label: _shadowOffset.dx.toStringAsFixed(1),
                  onChanged: (value) => setState(() => 
                    _shadowOffset = Offset(value, _shadowOffset.dy)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Offset Y:'),
              Expanded(
                child: Slider(
                  value: _shadowOffset.dy,
                  min: -10,
                  max: 10,
                  divisions: 20,
                  label: _shadowOffset.dy.toStringAsFixed(1),
                  onChanged: (value) => setState(() => 
                    _shadowOffset = Offset(_shadowOffset.dx, value)),
                ),
              ),
            ],
          ),

          // Arc
          const SizedBox(height: 16),
          const Text('Text Arc', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _arcDegree,
            min: -180,
            max: 180,
            divisions: 72,
            label: '${_arcDegree.toInt()}°',
            onChanged: (value) => setState(() => _arcDegree = value),
          ),

          // Spacing
          const SizedBox(height: 16),
          const Text('Letter Spacing', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _letterSpacing,
            min: -5,
            max: 10,
            divisions: 30,
            label: _letterSpacing.toStringAsFixed(1),
            onChanged: (value) => setState(() => _letterSpacing = value),
          ),

          const Text('Word Spacing', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _wordSpacing,
            min: -5,
            max: 10,
            divisions: 30,
            label: _wordSpacing.toStringAsFixed(1),
            onChanged: (value) => setState(() => _wordSpacing = value),
          ),

          const Text('Line Height', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _lineHeight,
            min: 0.5,
            max: 3.0,
            divisions: 25,
            label: _lineHeight.toStringAsFixed(1),
            onChanged: (value) => setState(() => _lineHeight = value),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Background
          const Text('Background Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _backgroundColor = null),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.clear, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                ...([
                  Colors.white, Colors.black.withOpacity(0.1), Colors.red.withOpacity(0.1),
                  Colors.green.withOpacity(0.1), Colors.blue.withOpacity(0.1), Colors.yellow.withOpacity(0.1),
                ].map((color) => GestureDetector(
                  onTap: () => setState(() => _backgroundColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _backgroundColor == color ? Colors.blue : Colors.grey[300]!,
                        width: _backgroundColor == color ? 2 : 1,
                      ),
                    ),
                  ),
                ))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Border
          const Text('Border', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Width:'),
              Expanded(
                child: Slider(
                  value: _borderWidth,
                  min: 0,
                  max: 10,
                  divisions: 20,
                  label: _borderWidth.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _borderWidth = value),
                ),
              ),
            ],
          ),
          if (_borderWidth > 0) ...[
            const Text('Border Color:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Colors.black, Colors.grey, Colors.red, Colors.green,
                Colors.blue, Colors.purple,
              ].map((color) => GestureDetector(
                onTap: () => setState(() => _borderColor = color),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _borderColor == color ? Colors.blue : Colors.grey[300]!,
                      width: _borderColor == color ? 2 : 1,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
          const SizedBox(height: 16),

          // Padding & Margin
          const Text('Padding', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('All'),
                    Slider(
                      value: _padding.left,
                      min: 0,
                      max: 20,
                      divisions: 20,
                      onChanged: (value) => setState(() => 
                        _padding = EdgeInsets.all(value)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transform
          const Text('Transform', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Skew X:'),
              Expanded(
                child: Slider(
                  value: _skewX,
                  min: -1,
                  max: 1,
                  divisions: 20,
                  label: _skewX.toStringAsFixed(2),
                  onChanged: (value) => setState(() => _skewX = value),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Skew Y:'),
              Expanded(
                child: Slider(
                  value: _skewY,
                  min: -1,
                  max: 1,
                  divisions: 20,
                  label: _skewY.toStringAsFixed(2),
                  onChanged: (value) => setState(() => _skewY = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alignment
          const Text('Alignment', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Horizontal:'),
              const SizedBox(width: 8),
              Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                children: [TextAlign.left, TextAlign.center, TextAlign.right, TextAlign.start, TextAlign.end, TextAlign.justify].map((align) =>
                  Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(align.toString().split('.').last),
                    selected: _horizontalAlignment == align,
                    onSelected: (selected) => setState(() => _horizontalAlignment = align),
                  ),
                  ),
                ).toList(),
                ),
              ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Vertical:'),
              const SizedBox(width: 8),
              Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                children: [MainAxisAlignment.start, MainAxisAlignment.center, MainAxisAlignment.end].map((align) =>
                  Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(align.toString().split('.').last),
                    selected: _verticalAlignment == align,
                    onSelected: (selected) => setState(() => _verticalAlignment = align),
                  ),
                  ),
                ).toList(),
                ),
              ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Flip
          const Text('Flip', style: TextStyle(fontWeight: FontWeight.bold)),
          Column(
            children: [
              CheckboxListTile(
                title: const Text('Horizontal'),
                value: _flipHorizontally,
                onChanged: (value) => setState(() => _flipHorizontally = value!),
              ),
              CheckboxListTile(
                title: const Text('Vertical'),
                value: _flipVertically,
                onChanged: (value) => setState(() => _flipVertically = value!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewText() {
    final textWidget = Text(
      _textController.text.isEmpty ? 'Sample Text' : _textController.text,
      style: GoogleFonts.getFont(
        _fontFamily,
        fontSize: _fontSize * 0.7, // Scale down for preview
        fontWeight: _fontWeight,
        fontStyle: _fontStyle,
        color: _useGradientText ? null : _textColor.withValues(alpha: _opacity),
        letterSpacing: _letterSpacing,
        wordSpacing: _wordSpacing,
        height: _lineHeight,
        decoration: _isUnderlined ? TextDecoration.underline : null,
        decorationColor: _textColor,
        shadows: _shadowBlurRadius > 0 ? [
          Shadow(
            color: _shadowColor,
            offset: _shadowOffset,
            blurRadius: _shadowBlurRadius,
          ),
        ] : null,
      ),
      textAlign: _horizontalAlignment,
    );

    Widget result = textWidget;

    // Apply gradient if enabled
    if (_useGradientText && _textGradient != null) {
      result = ShaderMask(
        shaderCallback: (bounds) => _textGradient!.createShader(bounds),
        child: Text(
          _textController.text.isEmpty ? 'Sample Text' : _textController.text,
          style: GoogleFonts.getFont(
            _fontFamily,
            fontSize: _fontSize * 0.7,
            fontWeight: _fontWeight,
            fontStyle: _fontStyle,
            color: Colors.white,
            letterSpacing: _letterSpacing,
            wordSpacing: _wordSpacing,
            height: _lineHeight,
            decoration: _isUnderlined ? TextDecoration.underline : null,
          ),
          textAlign: _horizontalAlignment,
        ),
      );
    }

    // Apply background
    if (_backgroundColor != null) {
      result = Container(
        padding: _padding,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: _borderWidth > 0 ? Border.all(color: _borderColor!, width: _borderWidth) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: result,
      );
    }

    // Apply transforms
    if (_skewX != 0 || _skewY != 0 || _flipHorizontally || _flipVertically) {
      result = Transform(
        transform: Matrix4.identity()
          ..setEntry(0, 1, _skewX)
          ..setEntry(1, 0, _skewY)
          ..scale(_flipHorizontally ? -1.0 : 1.0, _flipVertically ? -1.0 : 1.0),
        alignment: Alignment.center,
        child: result,
      );
    }

    return result;
  }

  void _saveSettings() {
    final content = TextItemContent(
      data: _textController.text,
      fontFamily: _fontFamily,
      fontSize: _fontSize,
      fontWeight: _fontWeight,
      fontStyle: _fontStyle,
      isUnderlined: _isUnderlined,
      textColor: _useGradientText ? null : _textColor,
      textGradient: _useGradientText ? _textGradient : null,
      strokeColor: _strokeWidth > 0 ? _strokeColor : null,
      strokeWidth: _strokeWidth,
      shadowColor: _shadowBlurRadius > 0 ? _shadowColor : null,
      shadowOffset: _shadowBlurRadius > 0 ? _shadowOffset : null,
      shadowBlurRadius: _shadowBlurRadius,
      shadowSpreadRadius: _shadowSpreadRadius,
      arcDegree: _arcDegree,
      letterSpacing: _letterSpacing,
      wordSpacing: _wordSpacing,
      lineHeight: _lineHeight,
      backgroundColor: _backgroundColor,
      borderColor: _borderWidth > 0 ? _borderColor : null,
      borderWidth: _borderWidth,
      opacity: _opacity,
      padding: _padding,
      margin: _margin,
      skewX: _skewX,
      skewY: _skewY,
      horizontalAlignment: _horizontalAlignment,
      verticalAlignment: _verticalAlignment,
      flipHorizontally: _flipHorizontally,
      flipVertically: _flipVertically,
      // Keep existing properties
      style: widget.item.content?.style,
      strutStyle: widget.item.content?.strutStyle,
      textAlign: _horizontalAlignment,
      textDirection: widget.item.content?.textDirection,
      locale: widget.item.content?.locale,
      softWrap: widget.item.content?.softWrap,
      overflow: widget.item.content?.overflow,
      textScaleFactor: widget.item.content?.textScaleFactor,
      maxLines: widget.item.content?.maxLines,
      semanticsLabel: widget.item.content?.semanticsLabel,
      textWidthBasis: widget.item.content?.textWidthBasis,
      textHeightBehavior: widget.item.content?.textHeightBehavior,
      selectionColor: widget.item.content?.selectionColor,
    );

    widget.onSave(content);
    Navigator.pop(context);
  }
}

class _BackgroundEditorDialog extends StatefulWidget {
  final Color backgroundColor;
  final Gradient? backgroundGradient;
  final File? backgroundImage;
  final double backgroundWidth;
  final double backgroundHeight;
  final BoxFit backgroundFit;
  final bool useGradient;
  final bool useImage;
  final Function(Color, Gradient?, File?, double, double, BoxFit, bool, bool) onSave;

  const _BackgroundEditorDialog({
    Key? key,
    required this.backgroundColor,
    this.backgroundGradient,
    this.backgroundImage,
    required this.backgroundWidth,
    required this.backgroundHeight,
    required this.backgroundFit,
    required this.useGradient,
    required this.useImage,
    required this.onSave,
  }) : super(key: key);

  @override
  _BackgroundEditorDialogState createState() => _BackgroundEditorDialogState();
}

class _BackgroundEditorDialogState extends State<_BackgroundEditorDialog> {
  late Color _selectedColor;
  late Gradient? _selectedGradient;
  late File? _selectedImage;
  late double _width;
  late double _height;
  late BoxFit _fit;
  late bool _useGradient;
  late bool _useImage;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.backgroundColor;
    _selectedGradient = widget.backgroundGradient;
    _selectedImage = widget.backgroundImage;
    _width = widget.backgroundWidth;
    _height = widget.backgroundHeight;
    _fit = widget.backgroundFit;
    _useGradient = widget.useGradient;
    _useImage = widget.useImage;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Background Editor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildTabButton('Color', 0, Icons.color_lens),
                  _buildTabButton('Gradient', 1, Icons.gradient),
                  _buildTabButton('Image', 2, Icons.image),
                  _buildTabButton('Size', 3, Icons.aspect_ratio),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Content
            Expanded(
              child: _buildTabContent(),
            ),

            // Buttons
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildColorTab();
      case 1:
        return _buildGradientTab();
      case 2:
        return _buildImageTab();
      case 3:
        return _buildSizeTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildColorTab() {
    return Column(
      children: [
        // Color Preview
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        const SizedBox(height: 20),
        
        // Predefined Colors
        const Text('Quick Colors', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Colors.white,
            Colors.black,
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
            Colors.pink,
            Colors.teal,
            Colors.grey,
            Colors.brown,
          ].map((color) => GestureDetector(
            onTap: () => setState(() {
              _selectedColor = color;
              _useGradient = false;
              _useImage = false;
            }),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedColor == color ? Colors.blue : Colors.grey[300]!,
                  width: _selectedColor == color ? 3 : 1,
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildGradientTab() {
    final gradients = [
      const LinearGradient(colors: [Colors.blue, Colors.purple]),
      const LinearGradient(colors: [Colors.orange, Colors.red]),
      const LinearGradient(colors: [Colors.green, Colors.teal]),
      const LinearGradient(colors: [Colors.pink, Colors.purple]),
      const LinearGradient(colors: [Colors.yellow, Colors.orange]),
      const LinearGradient(colors: [Colors.indigo, Colors.blue]),
    ];

    return Column(
      children: [
        const Text('Gradient Presets', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2,
            ),
            itemCount: gradients.length,
            itemBuilder: (context, index) {
              final gradient = gradients[index];
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedGradient = gradient;
                  _useGradient = true;
                  _useImage = false;
                }),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedGradient == gradient ? Colors.blue : Colors.grey[300]!,
                      width: _selectedGradient == gradient ? 3 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageTab() {
    return Column(
      children: [
        // Image Preview
        if (_selectedImage != null)
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              image: DecorationImage(
                image: FileImage(_selectedImage!),
                fit: _fit,
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 48, color: Colors.grey),
                Text('No image selected', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        const SizedBox(height: 20),

        // Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery', style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImageFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
        
        if (_selectedImage != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _cropImage,
                  icon: const Icon(Icons.crop),
                  label: const Text('Crop'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _selectedImage = null),
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 20),
        const Text('Image Fit', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        DropdownButtonFormField<BoxFit>(
          value: _fit,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: BoxFit.values.map((fit) {
            return DropdownMenuItem(
              value: fit,
              child: Text(fit.toString().split('.').last),
            );
          }).toList(),
          onChanged: (value) => setState(() => _fit = value!),
        ),
      ],
    );
  }

  Widget _buildSizeTab() {
    return Column(
      children: [
        // Size Preview
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              '${_width.toInt()} × ${_height.toInt()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Width Slider
        const Text('Width', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: _width,
          min: 300,
          max: 2000,
          divisions: 34,
          label: _width.toInt().toString(),
          onChanged: (value) => setState(() => _width = value),
        ),
        const SizedBox(height: 10),

        // Height Slider
        const Text('Height', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: _height,
          min: 300,
          max: 2000,
          divisions: 34,
          label: _height.toInt().toString(),
          onChanged: (value) => setState(() => _height = value),
        ),
        const SizedBox(height: 5),

        // Preset Sizes
        const Text('Preset Sizes', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 5,
          runSpacing: 5,

          children: [
            {'name': 'HD', 'width': 1280.0, 'height': 720.0},
            {'name': 'Full HD', 'width': 1920.0, 'height': 1080.0},
            {'name': 'Square', 'width': 800.0, 'height': 800.0},
            {'name': 'A4', 'width': 794.0, 'height': 1123.0},
          ].map((preset) => ElevatedButton(
            onPressed: () => setState(() {
              _width = preset['width'] as double;
              _height = preset['height'] as double;
            }),
            child: Text(preset['name'] as String),
          )).toList(),
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _useImage = true;
        _useGradient = false;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _useImage = true;
        _useGradient = false;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_selectedImage == null) return;

    // For now, we'll just show a message since image_cropper might not be installed
    // In a real implementation, you would use image_cropper package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Crop functionality requires image_cropper package'),
      ),
    );

    /* 
    Uncomment this when image_cropper is properly installed:
    
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _selectedImage!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Background',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(
          title: 'Crop Background',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
    }
    */
  }

  void _saveSettings() {
    widget.onSave(
      _selectedColor,
      _selectedGradient,
      _selectedImage,
      _width,
      _height,
      _fit,
      _useGradient,
      _useImage,
    );
    Navigator.pop(context);
  }
}
