import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/screens/cinemas/cinema_screen.dart';
import 'package:cinema_tickets/screens/home/components/body.dart';
import 'package:cinema_tickets/screens/home/components/profile.dart';
import 'package:cinema_tickets/screens/home/components/search_bar_delegate.dart';
import 'package:cinema_tickets/screens/new/mains.dart';
import 'package:cinema_tickets/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  static String routeName = "/home_screen";
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin{
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

  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myChild = Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: buildAppBar(context),
      body: Body(),
    );
    // var myDrawer = MyDrawer();
    // return WillPopScope(
    //   onWillPop: () async {
    //     if (_animationController.isCompleted){
    //       close();
    //       return false;
    //     }
    //     return true;
    //   },
      return GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        onTap: toggle,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _){
            return Material(
              color: Colors.blueGrey,
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(maxSlide * (_animationController.value - 1), 0),
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
                      child: myChild,
                    ),
                  ),

                  // Positioned(
                  //   top: 4.0 + MediaQuery.of(context).padding.top,
                  //   left: 4.0 + _animationController.value * maxSlide,
                  //   child: IconButton(
                  //     icon: Icon(Icons.menu),
                  //     onPressed: toggle,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // Positioned(
                  //   top: 16.0 + MediaQuery.of(context).padding.top,
                  //   left: _animationController.value *
                  //       MediaQuery.of(context).size.width,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Text(
                  //     'Hello Flutter Europe',
                  //     style: Theme.of(context).primaryTextTheme.title,
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                ],
              ),
            );
          },

        ),
      );
  }

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

  }

  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(text),
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: new Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () =>
              Navigator.pushNamed(context, ProfileScreen.routeName)),
      title:
      // Container(
      //   child: DropdownButton(
      //     dropdownColor: Colors.black,
      //     value: _chosenValue,
      //     onChanged: (value) {
      //       setState(() {
      //         _chosenValue = value.toString();
      //         print(_chosenValue);
      //       });
      //     },
      //     items: <String>[
      //       '西南艺威影院龙湖时代天街店西南交大', //少于13个中文字
      //       'IOS',
      //       'Flutter',
      //       'Node',
      //       'Java',
      //       'Python',
      //       'PHP',
      //     ].map<DropdownMenuItem<String>>((String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value,),
      //       );
      //     }).toList(),
      //     icon: Icon(Icons.arrow_right),
      //     iconSize: 40,
      //     iconEnabledColor: Colors.white.withOpacity(0.7),
      //     style: TextStyle(color: Colors.white),
      //     hint: Text(
      //       "Choose Cinema",
      //       style: TextStyle(color: Colors.white),
      //       overflow: TextOverflow.ellipsis,
      //       textAlign: TextAlign.center,
      //     ),
      //     isDense: true,
      //     isExpanded: true,
      //   ),
      // ),
      Text(
        "CinemaTickets",
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.bold, color: kGoldenColor),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () => Navigator.pushNamed(context, TestHomeScreen.routeName),
          // onPressed: () {
          //   showSearch(context: context, delegate: SearchBarDelegate());
          // },
        )
      ],
    );
  }


class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                ListTile(
                  leading: Icon(Icons.new_releases),
                  title: Text('News'),
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Favourites'),
                ),
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Map'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}