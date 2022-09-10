import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_tickets/models/ticket_bundle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

const double minHeight = 120;
const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class Event {
  final String assetName;
  final String title;
  final String date;
  final String location;

  Event(this.assetName, this.title, this.date, this.location);
}

class ExhibitionBottomSheet extends StatefulHookWidget {
  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get maxHeight => MediaQuery.of(context).size.height;

  double? get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);

  double? get headerFontSize => lerp(14, 24);

  double? get itemBorderRadius => lerp(8, 24);

  double? get iconLeftBorderRadius => itemBorderRadius;

  double? get iconRightBorderRadius => lerp(8, 0);

  double? get iconSize => lerp(iconStartSize, iconEndSize);

  double iconTopMargin(int index) =>
      lerp(iconStartMarginTop,
          iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize))! +
      headerTopMargin!;

  double? iconLeftMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  @override
  Widget build(BuildContext context) {
    final tickets =
        useStream<List<TicketBundle>>(ticketsSubject.stream, initialData: [])
                .data ??
            [];
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          height: lerp(minHeight, maxHeight),
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF162A49),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      right: 0,
                      bottom: 24,
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        color: Colors.white,
                        iconSize: 28,
                        onPressed: _toggle,
                      )),
                  SheetHeader(
                    fontSize: headerFontSize!,
                    topMargin: headerTopMargin!,
                  ),
                  for (final event in tickets.asMap().entries)
                    _buildFullItem(event),
                  for (final event in tickets.asMap().entries)
                    _buildIcon(event),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //TODO: 图片数据
  Widget _buildIcon(MapEntry<int, TicketBundle> event) {
    final index = event.key;
    final ticket = event.value;

    return Positioned(
      height: iconSize,
      width: iconSize,
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(iconLeftBorderRadius!),
          right: Radius.circular(iconRightBorderRadius!),
        ),
        child: CachedNetworkImage(
          imageUrl: ticket.imageSrc,
          fit: BoxFit.cover,
          alignment: Alignment(lerp(1, 0)!, 0),
        ),
      ),
    );
  }

  Widget _buildFullItem(MapEntry<int, TicketBundle> event) {
    final index = event.key;
    final ticket = event.value;

    return ExpandedEventItem(
      topMargin: iconTopMargin(index),
      leftMargin: iconLeftMargin(index)!,
      height: iconSize!,
      isVisible: _controller.status == AnimationStatus.completed,
      borderRadius: itemBorderRadius!,
      title: ticket.movieName,
      date: DateFormat("MM-dd HH:mm").format(ticket.startAt),
      location: ticket.ticketType,
    );
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta! / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }
}

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final String date;
  final String location;

  const ExpandedEventItem(
      {Key? key,
      required this.topMargin,
      required this.height,
      required this.isVisible,
      required this.borderRadius,
      required this.title,
      required this.date,
      required this.leftMargin,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: height).add(EdgeInsets.all(8)),
          child: _buildContent(),
        ),
      ),
    );
  }

  //TODO:数据填充
  Widget _buildContent() {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              '1 ticket',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.grey.shade400, size: 16),
            Text(
              location,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            )
          ],
        )
      ],
    );
  }
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader({Key? key, required this.fontSize, required this.topMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      child: Text(
        'Booked Movies',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
