import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/common/list/common_item_list.dart';
import 'package:file_client/constant/album.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/service/share/album_service.dart';
import 'package:file_client/view/component/album/album_edit_dialog.dart';
import 'package:file_client/view/component/album/album_item.dart';
import 'package:flutter/material.dart';

import '../../widget/common_action_one_button.dart';
import '../../widget/common_tab_bar.dart';

class ShareAlbumPage extends StatefulWidget {
  const ShareAlbumPage({super.key});

  @override
  State<ShareAlbumPage> createState() => _ShareAlbumPageState();
}

class _ShareAlbumPageState extends State<ShareAlbumPage> {
  late Future _futureBuilderFuture;

  //这里的顺序必须和AlbumType声明的顺序一致
  var albumKeyList = [GlobalKey<CommonItemListState<Album>>(), GlobalKey<CommonItemListState<Album>>()];

  Future<void> loadMyAlbumList() async {
    try {} on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadMyAlbumList()]);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Navigator(
            onGenerateRoute: (val) {
              return PageRouteBuilder(
                pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
                  return DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const CommonTabBar(
                          titleTextList: ["音频", "视频"],
                        ),
                        Expanded(
                          child: Container(
                            color: Theme.of(context).colorScheme.background,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ...List.generate(
                                  2,
                                  (index) => Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5),
                                        margin: const EdgeInsets.only(top: 1, bottom: 2),
                                        color: Theme.of(context).colorScheme.surface,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 100,
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 120,
                                              child: CommonActionOneButton(
                                                title: "创建合集",
                                                textColor: Theme.of(context).colorScheme.primary,
                                                onTap: () async {
                                                  await createAlbum(index);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: CommonItemList<Album>(
                                          key: albumKeyList[index],
                                          onLoad: (int page) async {
                                            switch (index) {
                                              case 0:
                                                var list = await AlbumService.getUserAlbumList(albumType: AlbumType.audio, pageIndex: page, pageSize: 20, withTopic: false);
                                                return list;
                                              case 1:
                                                var list = await AlbumService.getUserAlbumList(albumType: AlbumType.video, pageIndex: page, pageSize: 20, withTopic: false);
                                                return list;
                                              case 2:
                                                var list = await AlbumService.getUserAlbumList(albumType: AlbumType.gallery, pageIndex: page, pageSize: 20, withTopic: false);
                                                return list;
                                              case 3:
                                                var list = await AlbumService.getUserAlbumList(albumType: AlbumType.application, pageIndex: page, pageSize: 20, withTopic: false);
                                                return list;
                                              default:
                                                return <Album>[];
                                            }
                                          },
                                          itemName: "合集",
                                          itemHeight: null,
                                          isGrip: false,
                                          enableScrollbar: true,
                                          itemBuilder: (ctx, album, albumList, onFresh) {
                                            return AlbumItem(
                                              album: album,
                                              key: ValueKey(album.id),
                                              onDeleteAlbum: (a) {
                                                albumList?.remove(a);
                                                setState(() {});
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
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
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> createAlbum(int index) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlbumEditDialog(
          onCreate: (String title, String introduction, String? coverUrl, albumType) async {
            var album = await AlbumService.createAlbum(
              title: title,
              introduction: introduction,
              coverUrl: coverUrl ?? "",
              albumType: albumType,
            );

            if (albumType == index + 1) {
              albumKeyList[index].currentState?.addItem(album);
              albumKeyList[index].currentState?.setState(() {});
            }
            if (context.mounted) Navigator.of(context).pop();
          },
          option: AlbumType.option,
        );
      },
    );
  }
}
