library focused_menu;

import 'dart:ui';
import 'package:flutter/material.dart';

import '../app_dimens.dart';
import 'focused_menu_model.dart';

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final double borderRadius;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const FocusedMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.borderRadius = 5,
      this.openWithTap = false})
      : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: widget.duration ?? Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    borderRadius: widget.borderRadius,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    child: widget.child,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class FocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final double borderRadius;

  const FocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.borderRadius = 5,
      this.menuOffset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.80);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : ( maxMenuWidth + childSize!.width + 10);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                child: Container(
                  // color: (blurBackgroundColor ?? Colors.black).withOpacity(0.7),
                  color: (blurBackgroundColor ?? Colors.black),
                ),
              )),
          Positioned(
            top: topOffset - 40,
            left: leftOffset - 40,
            child: Container(
              width: maxMenuWidth,
              height: menuHeight,
              alignment: Alignment.center,
              decoration: menuBoxDecoration ??
                  const BoxDecoration(
                      // color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 10,
                            spreadRadius: 5)

                      ]),
              child: ListView.builder(
                itemCount: menuItems.length,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  FocusedMenuItem item = menuItems[index];
                  Widget listItem = GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        item.onPressed();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(child: item.title),
                            const SizedBox(
                              width: AppDimensions.dmFive,
                            ),
                            if (item.trailingWidget != null) ...[
                              item.trailingWidget!
                            ]
                          ],
                        ),
                      ));

                  if (animateMenu) {
                    return TweenAnimationBuilder(
                        builder: (context, dynamic value, child) {
                          return Transform(
                            transform: Matrix4.rotationX(1.5708 * value),
                            alignment: Alignment.bottomCenter,
                            child: child,
                          );
                        },
                        tween: Tween(begin: 1.0, end: 0.0),
                        duration: Duration(milliseconds: index * 200),
                        child: listItem);
                  } else {
                    return listItem;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
