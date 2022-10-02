import 'dart:math';

import 'package:cinema_tickets/api/movie.dart';
import 'package:cinema_tickets/models/ticket_bundle.dart';
import 'package:cinema_tickets/screens/home/components/movie_bundle_card.dart';
import 'package:cinema_tickets/screens/ticket/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Body extends HookWidget {
  int ticketTimeNear(List<TicketBundle> ticketBundles) {
    int indexNearT = -1;
    DateTime now = new DateTime.now();
    for (int i = 0; i < ticketBundles.length; i++) {
      if (ticketBundles[i].startAt.difference(now).inHours < 12 &&
          ticketBundles[i].startAt.difference(now).inHours > 0) {
        indexNearT = i;
      }
      //记录下12小时内即将开始的电影在bundle的index
    }
    return indexNearT;
  }

  @override
  Widget build(BuildContext context) {
    final tickets =
        useStream<List<TicketBundle>>(ticketsSubject.stream, initialData: [])
                .data ??
            [];
    int nearTimeTicketIndex = ticketTimeNear(tickets);

    Size size = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.only(
            left: size.width * 0.075, right: size.width * 0.075),
        child: EasyRefresh(
          header: ClassicalHeader(
              refreshedText: "Success!",
              textColor: Colors.white,
              infoColor: Colors.white.withOpacity(0.5)),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
          },
          child: CustomScrollView(
            slivers: <Widget>[
              if (nearTimeTicketIndex != -1) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: TicketCard(
                      ticketBundle: tickets[nearTimeTicketIndex],
                    ),
                  ),
                ),
              ],
              _grid(context),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 16,
                ),
              )
            ],
          ),
        ));
  }

  Widget _grid(BuildContext context) {
    final movies = useProvider(allMoviesProvider).data?.value ?? [];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: MovieBundleCard(movieBundle: movies[index])),
        childCount: movies.length,
      ),
    );
  }
}
