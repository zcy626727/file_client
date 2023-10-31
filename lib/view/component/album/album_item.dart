import 'package:file_client/constant/album.dart';
import 'package:file_client/model/share/album.dart';
import 'package:flutter/material.dart';

import '../../page/album/album_page.dart';

class AlbumItem extends StatefulWidget {
  const AlbumItem({Key? key, required this.album, required this.onDeleteAlbum}) : super(key: key);
  final Album album;
  final Function(Album) onDeleteAlbum;

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    IconData iconData = Icons.file_open;
    switch(widget.album.albumType){
      case AlbumType.video:
        iconData = Icons.video_collection_outlined;
      case AlbumType.audio:
        iconData = Icons.audiotrack;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.only(bottom: 2),
      color: colorScheme.surface,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AlbumPage(
                  album: widget.album,
                  onDeleteAlbum: widget.onDeleteAlbum,
                );
              },
            ),
          );
        },
        contentPadding: EdgeInsets.zero,
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          //这个集合的类型
          child: Icon(iconData, color: colorScheme.onPrimary),
        ),
        title: Text(
          widget.album.title ?? "未知合集",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
        ),
        subtitle: Text(
          widget.album.introduction ?? "简介为空",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
