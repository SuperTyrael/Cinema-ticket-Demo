import 'package:cinema_tickets/constants.dart';
import 'package:cinema_tickets/screens/ticket/components/remaind_ticket.dart';
import 'package:cinema_tickets/screens/sign_in/sign_in.dart';
import 'package:cinema_tickets/screens/ticket/ticket_list.dart';
import 'package:cinema_tickets/utils/application.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: kGoldenColor,
      ),
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfileTop(context),
          SizedBox(height: 20),
          ProfileMenu(
            text: Application.isLogin ? "My Account" : "Login",
            icon: Icons.supervised_user_circle,
            press: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
              setState(() {});
            },
          ),
          ProfileMenu(
            text: "My Tickets",
            icon: Icons.local_movies_outlined,
            press: () =>
                Navigator.pushNamed(context, TicketListScreen.routeName),
          ),
          ProfileMenu(
            text: "Settings",
            icon: Icons.settings,
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: Icons.help,
            press: () {},
          ),
          if (Application.isLogin) ...[
            ProfileMenu(
              text: "Log Out",
              icon: Icons.logout,
              press: () async {
                await Application.setToken(null);
                Navigator.pop(context);
              },
            ),
          ]
        ],
      ),
    );
  }
}

Widget ProfileTop(BuildContext context) {
  double defaultSize = 10.0;
  return SizedBox(
    height: defaultSize * 20, // 240
    child: Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShape(),
          child: Container(
            height: defaultSize * 15, //150
            color: kGoldenColor,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: defaultSize), //10
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
            ],
          ),
        )
      ],
    ),
  );
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.png"),
          ),
          // Positioned(
          //   right: -16,
          //   bottom: 0,
          //   child: SizedBox(
          //     height: 46,
          //     width: 46,
          //     child: FlatButton(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(50),
          //         side: BorderSide(color: Colors.white),
          //       ),
          //       color: Color(0xFFF5F6F9),
          //       onPressed: () {},
          //       child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: kGoldenColor,
              size: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
