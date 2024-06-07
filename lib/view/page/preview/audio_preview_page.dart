import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/common/upload/service/file_url_service.dart';
import 'package:file_client/view/widget/common_media_player.dart';
import 'package:flutter/material.dart';

class AudioPreviewPage extends StatefulWidget {
  const AudioPreviewPage({super.key, required this.fileId});

  final int fileId;

  @override
  State<AudioPreviewPage> createState() => _AudioPreviewPageState();
}

class _AudioPreviewPageState extends State<AudioPreviewPage> {
  late Future _futureBuilderFuture;
  late String _currentUrl;

  Future<void> loadMediaUrl() async {
    try {
      var (url,_) = await FileUrlService.genGetFileUrl(widget.fileId);
      _currentUrl= url;
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadMediaUrl()]);
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
          return Scaffold(
            backgroundColor: colorScheme.background,
            body: Stack(
              children: [
                CommonMediaPlayer(videoUrl: _currentUrl),
                Positioned(
                  left: 5,
                  top: 5,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Material(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      clipBehavior: Clip.hardEdge,
                      color: colorScheme.surface.withAlpha(100),
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
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
}
