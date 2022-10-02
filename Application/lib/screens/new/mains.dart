import 'package:cinema_tickets/api/movie.dart';
import 'package:cinema_tickets/screens/favourite/favourite.dart';
import 'package:cinema_tickets/screens/home/components/search_bar_delegate.dart';
import 'package:cinema_tickets/screens/new/ExhibitionBottomSheet.dart';
import 'package:cinema_tickets/screens/new/slide_card.dart';
import 'package:cinema_tickets/screens/new/tabs.dart';
import 'package:cinema_tickets/screens/sign_in/sign_in.dart';
import 'package:cinema_tickets/screens/ticket/ticket_list.dart';
import 'package:cinema_tickets/utils/application.dart';
import 'package:cinema_tickets/utils/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;

import '../../size_config.dart';

class TestHomeScreen extends StatefulHookWidget {
  static var routeName = "/test_home";
  @override
  _TestHomeScreenState createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<TestHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed;
    bool isDragCloseFromRight = _animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    useProvider(locationProvider);
    SizeConfig().init(context);

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Material(
            color: Colors.blueGrey,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset:
                      Offset(maxSlide * (_animationController.value - 1), 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 * (1 - _animationController.value)),
                    alignment: Alignment.centerRight,
                    child: MyDrawer(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(maxSlide * _animationController.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * _animationController.value / 2),
                    alignment: Alignment.centerLeft,
                    child: HomePage(_animationController),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HomePage extends HookWidget {
  AnimationController _animationController;
  HomePage(this._animationController);
  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    final movies = useProvider(currentMoviesProvider);

    final appBar = Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: toggle,
          color: Colors.black,
        ),
        Expanded(child: DropDownTitle()),
        IconButton(
            icon: Icon(Icons.location_on_outlined),
            color: Colors.black,
            onPressed: () {
              context.refresh(locationProvider);
            }),
        IconButton(
          icon: Icon(Icons.search),
          color: Colors.black,
          onPressed: () {
            showSearch(context: context, delegate: SearchBarDelegate(context));
          },
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Padding(
                    padding: EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: appBar),
                SizedBox(height: 40),
                Tabs(),
                SizedBox(height: 8),
                SlidingCardsView(
                  movieBundle: movies,
                ),
              ],
            ),
          ),
          ExhibitionBottomSheet(),
          // ExhibitionBottomSheet(), //use this or ScrollableExhibitionSheet
        ],
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawer createState() => _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    double defaultSize = 5.0;
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Material(
        color: Colors.blue,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: defaultSize,
                    left: defaultSize * 4,
                  ), //10
                  height: defaultSize * 14, //140
                  width: defaultSize * 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.8, //8
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/profile.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(Application.isLogin ? "Account" : "Login"),
                  leading: Icon(Icons.supervised_user_circle),
                  onTap: () async {
                    if (Application.isLogin) {
                      return;
                    }
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                    setState(() {});
                  },
                ),
                if (Application.isLogin) ...[
                  ListTile(
                    leading: Icon(Icons.local_movies_outlined),
                    title: Text('Tickets'),
                    onTap: () => Navigator.pushNamed(
                        context, TicketListScreen.routeName),
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('My Favorite'),
                    onTap: () =>
                        Navigator.pushNamed(context, FavouriteScreen.routeName),
                  ),
                ],
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Help Center'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                if (Application.isLogin) ...[
                  ListTile(
                    title: Text("Log Out"),
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      await Application.setToken(null);
                      setState(() {});
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropDownTitle extends StatefulWidget {
  DropDownTitle();

  @override
  _DropDownTitleState createState() => _DropDownTitleState();
}

class _DropDownTitleState extends State<DropDownTitle> {
  int chosenValue = 0;
  @override
  Widget build(BuildContext context) {
    final cinemas = [
      'C+影城终极荧幕（双铁广场店）', //少于13个中文字
      '中影星美国际影城（犀浦百伦店）',
      'CGV影城（犀浦IMAX店）',
      '太平洋影城（龙城国际店）',
      '嘉莱国际影城（金科路店）',
      '太平洋影城（金泉店）',
      'SFC上影影城（成都龙湖IMAX店）',
    ];
    return Container(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<int>(
          dropdownColor: Colors.white,
          value: chosenValue,
          onChanged: (value) {
            if (value != null) {
              currentCinemaSubject.add(value);
              setState(() {
                chosenValue = value;
              });
            }
          },
          items: cinemas.asMap().entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(
                entry.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          icon: Icon(Icons.arrow_right),
          iconSize: 30,
          iconEnabledColor: Colors.black.withOpacity(0.7),
          style: TextStyle(color: Colors.black),
          hint: Text(
            "C+影城终极荧幕（双铁广场店）",
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          isDense: true,
          isExpanded: true,
        ),
      ),
    );
  }
}
