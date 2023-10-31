import 'package:dio/dio.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/service/share/album_service.dart';
import 'package:file_client/view/page/source/audio_edit_page.dart';
import 'package:file_client/view/page/source/video_edit_page.dart';
import 'package:flutter/material.dart';

import '../../../constant/album.dart';
import '../../../model/share/source.dart';
import '../../../service/share/application_service.dart';
import '../../../service/share/audio_service.dart';
import '../../../service/share/gallery_service.dart';
import '../../../service/share/video_service.dart';
import '../../widget/common_action_one_button.dart';
import '../../widget/common_item_list.dart';
import '../../widget/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';
import '../source/source_item.dart';

class AlbumContentListView extends StatefulWidget {
  const AlbumContentListView({super.key, required this.album, required this.onDeleteAlbum});

  final Album album;
  final Function(Album) onDeleteAlbum;

  @override
  State<AlbumContentListView> createState() => _AlbumContentListViewState();
}

class _AlbumContentListViewState extends State<AlbumContentListView> {
  GlobalKey<CommonItemListState<Source>> listKey = GlobalKey<CommonItemListState<Source>>();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          color: colorScheme.surface,
          margin: const EdgeInsets.only(bottom: 1, top: 1),
          padding: const EdgeInsets.only(bottom: 5, top: 5),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 140,
                child: CommonActionOneButton(
                  onTap: () async {
                    await addSource();
                  },
                  title: "添加资源",
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                width: 140,
                child: CommonActionOneButton(
                  onTap: () async {
                    await deleteAlbum();
                  },
                  title: "删除合集",
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 1),
            color: colorScheme.background,
            child: CommonItemList<Source>(
              key: listKey,
              onLoad: (int page) async {
                List<Source> list = <Source>[];
                switch (widget.album.albumType) {
                  case AlbumType.gallery:
                    list = await GalleryService.getGalleryListByAlbum(pageSize: 20, albumId: widget.album.id!, pageIndex: page);
                  case AlbumType.audio:
                    list = await AudioService.getAudioListByAlbum(pageSize: 20, albumId: widget.album.id!, pageIndex: page);
                  case AlbumType.video:
                    list = await VideoService.getVideoListByAlbum(pageSize: 20, albumId: widget.album.id!, pageIndex: page);
                  case AlbumType.application:
                    list = await ApplicationService.getApplicationListByAlbum(pageSize: 20, albumId: widget.album.id!, pageIndex: page);
                }
                return list;
              },
              itemName: "资源",
              itemHeight: 40,
              enableScrollbar: true,
              isGrip: false,
              itemBuilder: (ctx, source, sourceList, onFresh) {
                return SourceItem(
                  source: source,
                  onDeleteSource: (s) {
                    sourceList?.remove(s);
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  //添加资源部分
  Future<void> addSource() async {
    //如果是画廊，弹出一个界面，然后依次上传图片，合成一个画廊后创建
    switch (widget.album.albumType) {
      case AlbumType.audio:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AudioEditPage(
                onCreate: (String title, String? coverUrl, int fileId, int order) async {
                  var audio = await AudioService.createAudio(albumId: widget.album.id!, fileId: fileId, title: title, coverUrl: coverUrl, order: order);
                  listKey.currentState?.addItem(audio);
                  listKey.currentState?.setState(() {});
                },
              );
            },
          ),
        );
      case AlbumType.video:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return VideoEditPage(
                onCreate: (String title, String? coverUrl, int fileId, int order) async {
                  var video = await VideoService.createVideo(albumId: widget.album.id!, fileId: fileId, title: title, coverUrl: coverUrl, order: order);
                  listKey.currentState?.addItem(video);
                  listKey.currentState?.setState(() {});
                },
              );
            },
          ),
        );
    }
  }

  Future<void> deleteAlbum() async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return ConfirmAlertDialog(
            text: "是否确定删除？",
            onConfirm: () async {
              try {
                await AlbumService.deleteAlbum(albumId: widget.album.id!);
                await widget.onDeleteAlbum(widget.album);
              } on DioException catch (e) {
                ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
              } finally {
                Navigator.pop(dialogContext);
              }
            },
            onCancel: () {
              Navigator.pop(dialogContext);
            },
          );
        });
  }
}
