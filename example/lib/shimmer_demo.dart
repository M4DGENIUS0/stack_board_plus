import 'package:flutter/material.dart';
import 'package:stack_board_plus/flutter_stack_board_plus.dart';
import 'package:stack_board_plus/stack_items.dart';

class ShimmerLoadingDemo extends StatefulWidget {
  const ShimmerLoadingDemo({Key? key}) : super(key: key);

  @override
  _ShimmerLoadingDemoState createState() => _ShimmerLoadingDemoState();
}

class _ShimmerLoadingDemoState extends State<ShimmerLoadingDemo> {
  late StackBoardPlusController _boardController;

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

  void _addNetworkImage() {
    final networkItem = StackImageItem.url(
      url: 'https://picsum.photos/300/200?random=${DateTime.now().millisecondsSinceEpoch}',
      size: const Size(200, 150),
    );
    _boardController.addItem(networkItem);
  }

  void _addNetworkSvg() {
    final svgItem = StackImageItem.url(
      url: 'https://www.vectorlogo.zone/logos/dartlang/dartlang-official.svg',
      size: const Size(100, 100),
    );
    _boardController.addItem(svgItem);
  }

  void _addLargeNetworkImage() {
    final largeImageItem = StackImageItem.url(
      url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600',
      size: const Size(250, 200),
    );
    _boardController.addItem(largeImageItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shimmer Loading Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addNetworkImage,
                  child: const Text('Random Image'),
                ),
                ElevatedButton(
                  onPressed: _addNetworkSvg,
                  child: const Text('SVG Image'),
                ),
                ElevatedButton(
                  onPressed: _addLargeNetworkImage,
                  child: const Text('Large Image'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StackBoardPlus(
              controller: _boardController,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const ShimmerLoadingDemo(),
  ));
}
