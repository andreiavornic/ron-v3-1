import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:notary/controllers/point.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/models/point.dart';
import 'package:notary/views/tags/tag_touch.dart';
import 'package:provider/provider.dart';

class DocumentTag extends StatefulWidget {
  final Function updatePoint;
  final Function addPoint;
  final Function checkPoint;

  DocumentTag({
    this.updatePoint,
    this.addPoint,
    this.checkPoint,
  });

  @override
  _DocumentTagState createState() => _DocumentTagState();
}

class _DocumentTagState extends State<DocumentTag> {
  Matrix4 _matrix;
  ValueNotifier<Matrix4> notifier;
  TransformationController _transformationController;
  double wPage;

  List<Image> _images;

  @override
  void initState() {
    _matrix = Matrix4.identity();
    notifier = ValueNotifier(_matrix);
    _transformationController = TransformationController();

    initImages();
    super.initState();
  }

  initImages() {
    _images = [];
    Provider.of<SessionController>(context, listen: false)
        .session
        .images
        .forEach((image) {
      _images.add(new Image.memory(base64Decode(image)));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PointController>(
      builder: (context, _controller, _) {
        return Container(
          child: Center(
            child: Stack(
              children: [
                MatrixGestureDetector(
                  shouldRotate: false,
                  onMatrixUpdate: (m, tm, sm, rm) {
                    _matrix =
                        MatrixGestureDetector.compose(_matrix, tm, sm, null);
                    notifier.value = _matrix;
                    setState(() {});
                  },
                  child: AnimatedBuilder(
                    animation: notifier,
                    builder: (ctx, _) {
                      return Transform(
                        transform: notifier.value,
                        child: InteractiveViewer(
                          minScale: 1,
                          maxScale: 5,
                          transformationController: _transformationController,
                          child: SingleChildScrollView(
                            physics: _controller.points
                                    .any((element) => element.isChecked)
                                ? NeverScrollableScrollPhysics()
                                : ScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                for (int i = 0; i < _images.length; i++)
                                  GestureDetector(
                                    onTapUp: (TapUpDetails details) {
                                      widget.addPoint(details, i, wPage);
                                    },
                                    child: _getImageAndPoints(
                                      _controller.points,
                                      _images[i],
                                      i,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getImageAndPoints(
    List<Point> _points,
    Image image,
    int index,
  ) {
    _checkPoint(Point point) {
      int indexPoint = _points.indexWhere((element) => element.id == point.id);
      if (indexPoint >= 0) {
        widget.checkPoint(indexPoint);
      }
    }

    List<Point> _sortedPoints =
        _points.where((element) => element.page == index).toList();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                wPage = constraints.maxWidth;
                return image;
              },
            ),
            Container(
              height: 1,
              color: Color(0xFF000000).withOpacity(0.3),
            )
          ],
        ),
        ..._sortedPoints.map((point) {
          return Positioned(
            left: point.position.dx,
            top: point.position.dy,
            child: GestureDetector(
              child: TagTouch(
                point: point,
                onDrag: widget.updatePoint,
                onTap: () => _checkPoint(point),
              ),
            ),
          );
        })
      ],
    );
  }
}
