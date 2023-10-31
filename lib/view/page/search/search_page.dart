import 'package:file_client/util/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/share/album.dart';
import '../../../model/share/audio.dart';
import '../../../model/share/topic.dart';
import '../../../model/share/video.dart';
import '../../../service/share/album_service.dart';
import '../../../service/share/audio_service.dart';
import '../../../service/share/topic_service.dart';
import '../../../service/share/video_service.dart';
import '../../component/album/album_item.dart';
import '../../component/source/source_item.dart';
import '../../component/topic/topic_item.dart';
import '../../widget/common_item_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.initKeyword});

  final String? initKeyword;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool showSearchResult = false;
  final FocusNode _focusNode = FocusNode();
  TextEditingController keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initKeyword != null) {
      keywordController.text = widget.initKeyword!;
      showSearchResult = true;
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 45,
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
        ),
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: CupertinoSearchTextField(
            controller: keywordController,
            style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
            placeholder: "",
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            prefixInsets: const EdgeInsets.only(left: 10, top: 3),
            focusNode: _focusNode,
            onSubmitted: (value) {
              if (value.isEmpty) return;
              if (!showSearchResult) showSearchResult = true;
              setState(() {});
            },
          ),
        ),
        actions: [
          Device.isDesktopDeviceOrWeb
              ? Container(
                  width: 10,
                )
              : Center(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 50,
                    height: 34,
                    child: TextButton(
                      onPressed: () {
                        if (!showSearchResult) showSearchResult = true;
                        setState(() {});
                      },
                      child: const Text("搜索"),
                    ),
                  ),
                )
        ],
      ),
      body: showSearchResult ? searchResultBuild() : recommendBuild(),
    );
  }

  Widget recommendBuild() {
    return Container();
  }

  Widget searchResultBuild() {
    var colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 4,
      child: Container(
        color: colorScheme.surface,
        child: Column(
          children: [
            TabBar(
              labelPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              tabs: [
                buildTab("主题"),
                buildTab("合集"),
                buildTab("视频"),
                buildTab("音频"),
              ],
            ),
            Expanded(
              child: buildTabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Tab buildTab(String title) {
    return Tab(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: 65,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }

  Widget buildTabBarView() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.only(left: 1, right: 1, top: 1),
      child: TabBarView(
        key: ValueKey(DateTime.now()),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CommonItemList<Topic>(
            onLoad: (int page) async {
              var list = await TopicService.searchTopic(keyword: keywordController.text, page: page, pageSize: 20);
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
              var list = await AlbumService.searchAlbum(keyword: keywordController.text, page: page, pageSize: 20);
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
              var list = await VideoService.searchVideo(keyword: keywordController.text, page: page, pageSize: 20);
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
              var list = await AudioService.searchAudio(keyword: keywordController.text, page: page, pageSize: 20);
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
          )
        ],
      ),
    );
  }
}
