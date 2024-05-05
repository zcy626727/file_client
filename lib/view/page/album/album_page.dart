import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/model/share/subscribe_album.dart';
import 'package:file_client/service/share/subscribe_album_service.dart';
import 'package:file_client/view/component/album/album_edit_dialog.dart';
import 'package:file_client/view/widget/common_action_one_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/global.dart';
import '../../../constant/album.dart';
import '../../../model/user/user.dart';
import '../../../service/share/album_service.dart';
import '../../../service/user/user_service.dart';
import '../../component/album/album_content_list_view.dart';
import '../../component/show/show_snack_bar.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key? key, required this.album, required this.onDeleteAlbum}) : super(key: key);

  final Album album;
  final Function(Album) onDeleteAlbum;

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late Future _futureBuilderFuture;

  bool isOwn = false;

  User? albumUser;

  SubscribeAlbum? subscribeAlbum;

  Future getData() async {
    return Future.wait([loadUser(), loadSubscribeStatus()]);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  //获取用户信息
  Future<void> loadUser() async {
    try {
      if (widget.album.userId == Global.user.id) {
        albumUser = Global.user;
        isOwn = true;
      } else {
        albumUser = await UserService.getUserInfo(targetUserId: widget.album.userId!);
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  //获取订阅状态
  Future<void> loadSubscribeStatus() async {
    try {
      if (widget.album.userId != Global.user.id) {
        subscribeAlbum = await SubscribeAlbumService.getUserSubscribeAlbumInfo(albumId: widget.album.id!);
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
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
                    ],
                  ),
                ),
                Divider(color: Colors.grey.withAlpha(100), height: 1),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 250,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.album.coverUrl != null)
                                    Container(
                                      color: Colors.grey,
                                      width: double.infinity,
                                      height: 170,
                                      child: Image(
                                        image: NetworkImage(widget.album.coverUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      widget.album.title ?? "--",
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Text(
                                      widget.album.introduction ?? "--",
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    albumUser!.name ?? "--",
                                    style: TextStyle(color: colorScheme.onSurface.withAlpha(180), fontSize: 13),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "创建时间：${DateFormat("yyyy-MM-dd").format(widget.album.createTime!)}",
                                    style: TextStyle(color: colorScheme.onSurface.withAlpha(180), fontSize: 13),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "类型：${AlbumType.getAlbumTypeName(widget.album.albumType)}",
                                    style: TextStyle(color: colorScheme.onSurface.withAlpha(180), fontSize: 13),
                                  ),
                                  const SizedBox(height: 3),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 2, right: 2, bottom: 5),
                              height: 34,
                              child: isOwn
                                  ? CommonActionOneButton(
                                      onTap: () async {
                                        await editAlbum();
                                      },
                                      title: "编辑合集",
                                      backgroundColor: colorScheme.primary,
                                      textColor: colorScheme.onPrimary,
                                    )
                                  : CommonActionOneButton(
                                      onTap: () async {
                                        try {
                                          if (subscribeAlbum == null) {
                                            //订阅
                                            subscribeAlbum = await SubscribeAlbumService.createSubscribe(albumId: widget.album.id!);
                                          } else {
                                            //取消订阅
                                            await SubscribeAlbumService.deleteSubscribe(subscribeId: subscribeAlbum!.id!);
                                            subscribeAlbum = null;
                                          }
                                          setState(() {});
                                        } on Exception catch (e) {
                                          if (mounted) ShowSnackBar.exception(context: context, e: e);
                                        }
                                      },
                                      title: subscribeAlbum == null ? "订阅" : "取消订阅",
                                      backgroundColor: colorScheme.primary,
                                      textColor: colorScheme.onPrimary,
                                    ),
                            )
                          ],
                        ),
                      ),
                      VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
                      Expanded(
                        child: AlbumContentListView(
                          album: widget.album,
                          onDeleteAlbum: (a) async {
                            Navigator.pop(context);
                            await widget.onDeleteAlbum(a);
                          },
                        ),
                      ),
                    ],
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

  Future<void> editAlbum() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlbumEditDialog(
          initAlbum: widget.album,
          onCreate: (String title, String introduction, String? coverUrl, int albumType) async {
            await AlbumService.updateAlbum(
              title: title,
              introduction: introduction,
              coverUrl: coverUrl ?? "",
              albumId: widget.album.id!,
            );
            widget.album.title = title;
            widget.album.introduction = introduction;
            widget.album.coverUrl = coverUrl;
            setState(() {});
            if (mounted) Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
