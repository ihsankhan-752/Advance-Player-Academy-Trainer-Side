import 'package:advance_player_academy_trainer/screens/home/requests/tabs/received_request_tab.dart';
import 'package:advance_player_academy_trainer/screens/home/requests/tabs/send_request_tab.dart';
import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../widgets/buttons.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: SelectionAndUnSelectionButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  backgroundColor: currentIndex == 0 ? AppColors.mainColor : Colors.grey,
                  title: 'Sent',
                  textColor: AppColors.primaryWhite,
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: SelectionAndUnSelectionButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  backgroundColor: currentIndex == 1 ? AppColors.mainColor : Colors.grey,
                  title: 'Received',
                  textColor: AppColors.primaryWhite,
                ),
              ),
            ],
          ),
          if (currentIndex == 0) SendRequestTab(),
          if (currentIndex == 1) ReceivedRequestTab()
        ],
      ),
    );
  }
}
