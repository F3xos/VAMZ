import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/Database/global.dart';
import 'package:bet_trial/widgets/ticket_card.dart';
import 'package:bet_trial/widgets/modals/account_model.dart';
import 'package:bet_trial/widgets/modals/modal_item.dart';
import 'package:bet_trial/resources/text.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() {
    return _TicketsScreenState();
  }
}

class _TicketsScreenState extends State<TicketsScreen> {
  List<TicketItem> tickets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getTickets();
  }

  Future<void> getTickets() async {
    final globalModel = Provider.of<GlobalModel>(context, listen: false);
    globalModel.refreshAccountData();
    try {
      final response = await http.get(
        Uri.parse('${AppApiUrls.accUrl}${globalModel.account!['id']}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<TicketItem> loadedTickets = [];

        for (var item in data) {
          final createdAt = DateTime.parse(item['created_at']);

          loadedTickets.add(
            TicketItem(
              id: item['ticket_id'],
              status: item['status'],
              bettingAmount: double.parse(item['bet_money'].toString()),
              multiplier: double.parse(item['multiplier'].toString()),

              date:
                  "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
              time:
                  "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}",
            ),
          );
        }

        if (mounted) {
          setState(() {
            tickets = loadedTickets;
            loading = false;
          });
        }
      } else {
        throw Exception("Failed to fetch tickets");
      }
    } catch (error) {
      print("Error fetching tickets: $error");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load tickets')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 100.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.ticketsScreenTitle,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<GlobalModel>(
                      builder: (context, globalModel, _) {
                        return Text(
                          '${globalModel.getMoney.toStringAsFixed(2)}\$',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.backgroundColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => AccountModal(),
                        );
                      },
                      tooltip: 'Profile',
                      icon: const Icon(
                        Icons.account_circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: getTickets,
                child:
                    tickets.isEmpty
                        ? ListView.builder(
                          padding: EdgeInsets.only(
                            top: 10.h,
                            right: 10.w,
                            left: 10.w,
                          ),
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Text(
                                AppStrings.noTickets,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        )
                        : loading
                        ? ListView.builder(
                          padding: EdgeInsets.only(
                            top: 10.h,
                            right: 10.w,
                            left: 10.w,
                          ),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return SelectModalItem.sceleton(
                              sceleton: true,
                              reset: () {},
                              isSelected: false,
                            );
                          },
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                            left: 10,
                          ),
                          itemCount: tickets.length,
                          itemBuilder: (context, index) {
                            return tickets[index].getWidget(context);
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
