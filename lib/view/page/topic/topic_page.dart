import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/config/global.dart';
import 'package:file_client/constant/album.dart';
import 'package:file_client/model/file/user_file.dart';
import 'package:file_client/model/file/user_folder.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/model/share/source.dart';
import 'package:file_client/model/share/subscribe_topic.dart';
import 'package:file_client/model/user/user.dart';
import 'package:file_client/service/share/album_service.dart';
import 'package:file_client/service/share/application_service.dart';
import 'package:file_client/service/share/audio_service.dart';
import 'package:file_client/service/share/gallery_service.dart';
import 'package:file_client/service/share/subscribe_album_service.dart';
import 'package:file_client/service/share/topic_service.dart';
import 'package:file_client/service/user/user_service.dart';
import 'package:file_client/util/mime_util.dart';
import 'package:file_client/view/component/album/album_content_list_view.dart';
import 'package:file_client/view/component/file/select_file_dialog.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:file_client/view/component/source/source_item.dart';
import 'package:file_client/view/widget/common_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import '../../../model/share/topic.dart';
import '../../../service/share/subscribe_topic_service.dart';
import '../../../service/share/video_service.dart';
import '../../component/album/album_edit_dialog.dart';
import '../../component/topic/topic_edit_dialog.dart';
import '../../widget/common_action_one_button.dart';
import '../../widget/common_tab_bar.dart';
import '../../widget/confirm_alert_dialog.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key, required this.topic, required this.onDeleteTopic}) : super(key: key);

  final Topic topic;
  final Function(Topic) onDeleteTopic;

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  List<Album>? albumList;

  User? topicUser;
  SubscribeTopic? subscribeTopic;
  late Future _futureBuilderFuture;

  bool isOwn = false;

  //获取用户信息
  Future<void> loadUser() async {
    try {
      if (widget.topic.userId == Global.user.id) {
        topicUser = Global.user;
        isOwn = true;
      } else {
        topicUser = await UserService.getUserInfo(targetUserId: widget.topic.userId!);
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  //获取专辑列表
  Future<void> loadAlbumList() async {
    try {
      albumList = await AlbumService.getAlbumListByTopic(topicId: widget.topic.id!);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  //获取订阅状态
  Future<void> loadSubscribeStatus() async {
    try {
      subscribeTopic = await SubscribeTopicService.getUserSubscribeTopicInfo(topicId: widget.topic.id!);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadAlbumList(), loadUser(), loadSubscribeStatus()]);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          List<String> tabBarList = <String>[];
          if (albumList != null) {
            for (var album in albumList!) {
              tabBarList.add(album.title ?? "--");
            }
          }
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: colorScheme.onBackground,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              width: 1,
                              color: colorScheme.onSurface.withAlpha(30),
                              style: BorderStyle.solid,
                            ),
                          ),
                          color: colorScheme.surface,
                          child: Icon(
                            Icons.settings,
                            color: colorScheme.onSurface,
                          ),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                value: "edit",
                                onTap: () async {
                                  await editTopic();
                                },
                                child: Text("编辑", style: TextStyle(color: colorScheme.onSurface)),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                onTap: () async {
                                  await deleteTopic();
                                },
                                child: Text("删除", style: TextStyle(color: colorScheme.onSurface)),
                              ),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.withAlpha(100), height: 1),
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10, top: 5),
                        width: 150,
                        height: 150,
                        child: Image(
                          image: NetworkImage(
                            widget.topic.coverUrl!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.topic.title ?? "未知名称",
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 40,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  height: 30,
                                  width: 200,
                                  child: isOwn
                                      ? null
                                      //不是自己的主题
                                      : CommonActionOneButton(
                                          title: subscribeTopic == null ? "订阅" : "取消订阅",
                                          backgroundColor: colorScheme.primary,
                                          textColor: colorScheme.onPrimary,
                                          onTap: () async {
                                            try {
                                              if (subscribeTopic == null) {
                                                //订阅
                                                subscribeTopic = await SubscribeTopicService.createSubscribe(topicId: widget.topic.id!);
                                              } else {
                                                //取消订阅
                                                await SubscribeTopicService.deleteSubscribe(subscribeId: subscribeTopic!.id!);
                                              }
                                            } on Exception catch (e) {
                                              ShowSnackBar.exception(context: context, e: e);
                                            }
                                            setState(() {});
                                          },
                                        ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: CircleAvatar(
                                    radius: 10,
                                    foregroundImage: NetworkImage(
                                      topicUser == null ? "" : topicUser!.avatarUrl!,
                                    ),
                                  ),
                                ),
                                Text(
                                  topicUser == null ? "未知" : topicUser!.name!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                widget.topic.introduction ?? "简介为空",
                                style: TextStyle(color: colorScheme.onSurface.withAlpha(100)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: albumList == null ? 0 : albumList!.length,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CommonTabBar(
                                titleTextList: tabBarList,
                              ),
                            ),
                            //新建合集
                            IconButton(
                              splashRadius: 18,
                              onPressed: () async {
                                await createAlbum();
                              },
                              icon: Icon(
                                Icons.add,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            color: colorScheme.background,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ...List.generate(
                                  tabBarList.length,
                                  (index) {
                                    return AlbumContentListView(
                                      key: ValueKey(albumList![index].id),
                                      album: albumList![index],
                                      onDeleteAlbum: (a) {
                                        albumList?.remove(a);
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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

  Future<void> createAlbum() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlbumEditDialog(
          onCreate: (String title, String introduction, String? coverUrl, albumType) async {
            var album = await AlbumService.createAlbum(
              topicId: widget.topic.id,
              title: title,
              introduction: introduction,
              coverUrl: coverUrl ?? "",
              albumType: albumType,
            );
            if (albumList == null) {
              albumList = [album];
            } else {
              albumList!.add(album);
            }
            setState(() {});
            if (mounted) Navigator.of(context).pop();
          },
          option: AlbumType.option,
        );
      },
    );
  }

  //主题功能
  Future<void> deleteTopic() async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return ConfirmAlertDialog(
            text: "是否确定删除？",
            onConfirm: () async {
              try {
                await TopicService.deleteTopic(topicId: widget.topic.id!);
                await widget.onDeleteTopic(widget.topic);
              } on DioException catch (e) {
                ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
              } finally {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              }
            },
            onCancel: () {
              Navigator.pop(dialogContext);
            },
          );
        });
  }

  Future<void> editTopic() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return TopicEditDialog(
          initTopic: widget.topic,
          onCreate: (String title, String introduction, String? coverUrl, int albumType) async {
            await TopicService.updateTopic(
              title: title,
              introduction: introduction,
              coverUrl: coverUrl ?? "",
              topicId: widget.topic.id!,
            );
            widget.topic.title = title;
            widget.topic.introduction = introduction;
            widget.topic.coverUrl = coverUrl;
            setState(() {});
            if (mounted) Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
