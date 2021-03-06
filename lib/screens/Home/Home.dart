import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_uis/Utils.dart';
import 'package:flutter_uis/configs/App.dart';
import 'package:flutter_uis/configs/TextStyles.dart';

import 'package:flutter_uis/configs/Theme.dart' as theme;
import 'package:flutter_uis/configs/AppDimensions.dart';

import 'package:flutter_uis/Widgets/Screen/Screen.dart';
import 'package:flutter_uis/screens/Home/Widgets/HomeSettingsModal.dart';
import 'package:flutter_uis/screens/Home/messages/keys.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'data.dart' as data;
import 'Dimensions.dart';

import 'Widgets/HomeBuildVersion.dart';
import 'Widgets/HomeAlertModal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool webPopUpMounted = false;
  double webPopUpOpacity = 0;

  bool desktopPopUpMounted = false;
  double desktopPopUpOpacity = 0;

  @override
  void initState() {
    this.webPopUpMounted = kIsWeb;
    this.webPopUpOpacity = kIsWeb ? 1 : 0;

    this.desktopPopUpMounted = Utils.isDesktop();
    this.desktopPopUpOpacity = Utils.isDesktop() ? 1 : 0;

    super.initState();
  }

  void handlePath(String path) {
    if (path == "settings") {
      showMaterialModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_, __) => HomeSettingsModal(),
      );
    } else {
      Navigator.of(context).pushNamed(
        path,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("test");

    return Screen(
      Dimensions.init,
      scaffoldBackgroundColor: Colors.white,
      builder: (_) => SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: AppDimensions.maxContainerWidth,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.padding * 2,
                  vertical: AppDimensions.padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      App.translate(
                        HomeScreenMessages.title,
                      ),
                      style: TextStyles.heading1,
                    ),
                    Text(
                      App.translate(
                        HomeScreenMessages.desc,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(AppDimensions.padding)),
                    ...data.list
                        .map(
                          (item) => Container(
                            width: double.infinity,
                            child: OutlineButton(
                              textColor: theme.primary,
                              borderSide: BorderSide(
                                width: 1.5,
                                color: theme.primary.withOpacity(0.2),
                              ),
                              highlightedBorderColor: theme.primary.withOpacity(
                                0.8,
                              ),
                              onPressed: () => this.handlePath(item["path"]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item["icon"], size: 20),
                                  Container(width: 6),
                                  Text(
                                    App.translate(
                                      item["label"],
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    HomeBuildVersion(),
                  ],
                ),
              ),
            ),
            HomeAlertModal(
              title: App.translate(
                HomeScreenMessages.modalWebTitle,
              ),
              description: App.translate(
                HomeScreenMessages.modalWebDesc,
              ),
              primaryText: App.translate(
                HomeScreenMessages.modalWebButton1,
              ),
              secondaryText: App.translate(
                HomeScreenMessages.modalWebButton2,
              ),
              mount: this.webPopUpMounted,
              opacity: this.webPopUpOpacity,
              onPrimary: () => Navigator.of(context).pushNamed("download"),
              onSecondary: () => setState(() => (this.webPopUpOpacity = 0)),
              onEnd: () => setState(() => (this.webPopUpMounted = false)),
            ),
            HomeAlertModal(
              title: App.translate(
                HomeScreenMessages.modalDesktopTitle,
              ),
              description: App.translate(
                HomeScreenMessages.modalDesktopDesc,
              ),
              secondaryText: App.translate(
                HomeScreenMessages.modalDesktopButton,
              ),
              mount: this.desktopPopUpMounted,
              opacity: this.desktopPopUpOpacity,
              onEnd: () => setState(() => (this.desktopPopUpMounted = false)),
              onSecondary: () => setState(() => (this.desktopPopUpOpacity = 0)),
            ),
          ],
        ),
      ),
    );
  }
}
