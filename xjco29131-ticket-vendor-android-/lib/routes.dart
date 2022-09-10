import 'package:cinema_tickets/models/ticket_bundle.dart';
import 'package:cinema_tickets/screens/book/book_screen.dart';
import 'package:cinema_tickets/screens/cinemas/cinema_screen.dart';
import 'package:cinema_tickets/screens/favourite/favourite.dart';
import 'package:cinema_tickets/screens/forget/forget_password.dart';
import 'package:cinema_tickets/screens/forget/forget_success.dart';
import 'package:cinema_tickets/screens/home/components/detail_screen.dart';
import 'package:cinema_tickets/screens/home/components/home_screen.dart';
import 'package:cinema_tickets/screens/home/components/profile.dart';
import 'package:cinema_tickets/screens/new/mains.dart';
import 'package:cinema_tickets/screens/ticket/components/remaind_ticket.dart';
import 'package:cinema_tickets/screens/payment/add_credit_card.dart';
import 'package:cinema_tickets/screens/payment/credit_cards_page.dart';
import 'package:cinema_tickets/screens/payment/pay_entry_screen.dart';
import 'package:cinema_tickets/screens/sign_in/sing_in_success.dart';
import 'package:cinema_tickets/screens/sign_in/sign_in.dart';
import 'package:cinema_tickets/screens/sign_up/sign_up.dart';
import 'package:cinema_tickets/screens/sign_up/sign_up_success.dart';
import 'package:cinema_tickets/screens/ticket/ticket_list.dart';
import 'package:flutter/widgets.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignupSuccessScreen.routeName: (context) => SignupSuccessScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailScreen.routeName: (context) => DetailScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  // BookScreen.routeName: (context) => BookScreen(),
  // PayEntryScreen.routeName: (context) => PayEntryScreen(),
  // CreditCardsPage.routeName: (context) => CreditCardsPage(),
  AddCreditCardPage.routeName: (context) => AddCreditCardPage(),
  TicketListScreen.routeName: (context) => TicketListScreen(),
  CinemaScreen.routeName: (context) => CinemaScreen(),
  TestHomeScreen.routeName: (context) => TestHomeScreen(),
  ForgetPassword.routeName: (context) => ForgetPassword(),
  ForgetSuccess.routeName: (context) => ForgetSuccess(),
  FavouriteScreen.routeName: (context) => FavouriteScreen(),
};
