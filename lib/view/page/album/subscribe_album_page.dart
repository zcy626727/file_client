import 'package:file_client/constant/album.dart';
import 'package:flutter/material.dart';

import '../../../common/list/common_item_list.dart';
import '../../../model/share/album.dart';
import '../../../service/share/album_service.dart';
import '../../component/album/album_item.dart';
import '../../widget/common_tab_bar.dart';

class SubscribeAlbumPage extends StatefulWidget {
  const SubscribeAlbumPage({super.key});

  @override
  State<SubscribeAlbumPage> createState() => _SubscribeAlbumPageState();
}

class _SubscribeAlbumPageState extends State<SubscribeAlbumPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var colorScheme = Theme.of(context).colorScheme;

    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const CommonTabBar(
                    titleTextList: ["视频", "音频"],
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CommonItemList<Album>(
                            onLoad: (int page) async {
                              var list = await AlbumService.getSubscribeAlbumList(albumType: AlbumType.video, pageIndex: page, pageSize: 20);
                              return list;
                            },
                            itemName: "视频合集",
                            itemHeight: null,
                            isGrip: false,
                            enableScrollbar: true,
                            itemBuilder: (ctx, album, albumList, onFresh) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 2, left: 5, right: 5),
                                child: AlbumItem(
                                  album: album,
                                  key: ValueKey(album.id),
                                  onDeleteAlbum: (a) {
                                    albumList?.remove(a);
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                          CommonItemList<Album>(
                            onLoad: (int page) async {
                              var list = await AlbumService.getSubscribeAlbumList(albumType: AlbumType.audio, pageIndex: page, pageSize: 20);
                              return list;
                            },
                            itemName: "音频合集",
                            itemHeight: null,
                            isGrip: false,
                            enableScrollbar: true,
                            itemBuilder: (ctx, album, albumList, onFresh) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 2, left: 5, right: 5),
                                child: AlbumItem(
                                  album: album,
                                  key: ValueKey(album.id),
                                  onDeleteAlbum: (a) {
                                    albumList?.remove(a);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
