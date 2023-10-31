import 'package:file_client/view/page/album/share_album_page.dart';
import 'package:file_client/view/page/album/subscribe_album_page.dart';
import 'package:file_client/view/page/plaza/plaza_page.dart';
import 'package:file_client/view/page/subject/subject_share_content_page.dart';
import 'package:file_client/view/page/subject/subject_share_edit_page.dart';
import 'package:file_client/view/page/topic/subscribe_topic_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/screen_state.dart';
import '../page/global/global_share_edit_page.dart';
import '../page/topic/share_topic_page.dart';
import '../widget/desktop_nav_button.dart';
import '../page/global/global_share_content_page.dart';
import '../page/link/link_share_page.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var navState = Provider.of<ScreenNavigatorState>(context);
    return Row(
      children: [
        Container(
          color: colorScheme.surface,
          width: 180,
          child: Row(
            children: [
              VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavButton(
                      title: "资源广场",
                      iconData: Icons.public,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.resourcePlaza;
                      },
                      index: SecondNav.resourcePlaza,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
                      child: const Text("我的分享", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    NavButton(
                      title: "链接分享",
                      iconData: Icons.link,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.linkShare;
                      },
                      index: SecondNav.linkShare,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    NavButton(
                      title: "主题分享",
                      iconData: Icons.subject,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.topicShare;
                      },
                      index: SecondNav.topicShare,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    NavButton(
                      title: "合集分享",
                      iconData: Icons.view_stream,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.albumShare;
                      },
                      index: SecondNav.albumShare,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
                      child: const Text("我的订阅", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    NavButton(
                      title: "主题订阅",
                      iconData: Icons.subject,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.topicSubscribe;
                      },
                      index: SecondNav.topicSubscribe,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    NavButton(
                      title: "合集订阅",
                      iconData: Icons.view_stream,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.albumSubscribe;
                      },
                      index: SecondNav.albumSubscribe,
                      selectedIndex: navState.secondNavIndex,
                    ),
                  ],
                ),
              ),
              VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: _getPage(),
          ),
        )
      ],
    );
  }

  Widget _getPage() {
    switch (Provider.of<ScreenNavigatorState>(context).secondNavIndex) {
      case SecondNav.resourcePlaza:
        return const PlazaPage();
      case SecondNav.linkShare:
        return const LinkSharePage();
      case SecondNav.topicShare:
        return const ShareTopicPage();
      case SecondNav.albumShare:
        return const ShareAlbumPage();
      case SecondNav.topicSubscribe:
        return const SubscribeTopicPage();
      case SecondNav.albumSubscribe:
        return const SubscribeAlbumPage();
      default:
        return Container();
    }
  }
}
