import 'package:file_client/model/share/audio.dart';
import 'package:file_client/model/share/video.dart';
import 'package:file_client/service/share/audio_service.dart';
import 'package:file_client/service/share/video_service.dart';
import 'package:file_client/view/component/source/source_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constant/album.dart';
import '../../../model/share/album.dart';
import '../../../model/share/topic.dart';
import '../../../service/share/album_service.dart';
import '../../../service/share/topic_service.dart';
import '../../component/album/album_item.dart';
import '../../component/topic/topic_item.dart';
import '../../widget/common_item_list.dart';
import '../../widget/common_tab_bar.dart';
import '../search/search_page.dart';

class PlazaPage extends StatefulWidget {
  const PlazaPage({super.key});

  @override
  State<PlazaPage> createState() => _PlazaPageState();
}

class _PlazaPageState extends State<PlazaPage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                    child: CupertinoSearchTextField(
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                      placeholder: "",
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: colorScheme.onSurface,
                      ),
                      suffixIcon: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: colorScheme.onSurface,
                      ),
                      onSubmitted: (value) {
                        Navigator.push(nContext, MaterialPageRoute(builder: (context) => SearchPage(initKeyword: value)));
                      },
                    ),
                  ),
                  const CommonTabBar(
                    titleTextList: ["主题", "合集", "视频", "音频"],
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CommonItemList<Topic>(
                            onLoad: (int page) async {
                              var list = await TopicService.getFeedTopic(pageSize: 20);
                              return list;
                            },
                            itemName: "主题",
                            itemHeight: null,
                            isGrip: true,
                            enableScrollbar: true,
                            itemBuilder: (ctx, topic, topicList, onFresh) {
                              return Container(
                                margin: const EdgeInsets.all(2),
                                child: TopicItem(
                                  topic: topic,
                                  onDeleteTopic: (Topic t) {
                                    setState(() {
                                      topicList?.remove(t);
                                      setState(() {});
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          CommonItemList<Album>(
                            onLoad: (int page) async {
                              var list = await AlbumService.getFeedAlbum(pageSize: 20);
                              return list;
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
                          CommonItemList<Video>(
                            onLoad: (int page) async {
                              var list = await VideoService.getFeedVideo(pageSize: 20);
                              return list;
                            },
                            itemName: "视频",
                            itemHeight: null,
                            isGrip: false,
                            enableScrollbar: true,
                            itemBuilder: (ctx, video, videoList, onFresh) {
                              return SourceItem(
                                source: video,
                                key: ValueKey(video.id),
                                onDeleteSource: (s) {
                                  videoList?.remove(s);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                          CommonItemList<Audio>(
                            onLoad: (int page) async {
                              var list = await AudioService.getFeedAudio(pageSize: 20);
                              return list;
                            },
                            itemName: "音频",
                            itemHeight: null,
                            isGrip: false,
                            enableScrollbar: true,
                            itemBuilder: (ctx, audio, audioList, onFresh) {
                              return SourceItem(
                                source: audio,
                                key: ValueKey(audio.id),
                                onDeleteSource: (s) {
                                  audioList?.remove(s);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
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
