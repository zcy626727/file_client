import 'package:file_client/constant/album.dart';

class MimeUtil {
  static bool isMedia(String mimeType) {
    return mimeType.startsWith("video/") || mimeType.startsWith("audio/");
  }

  static bool isVideo(String mimeType) {
    return mimeType.startsWith("video/");
  }

  static bool isAudio(String mimeType) {
    return mimeType.startsWith("audio/");
  }

  static bool isImage(String mimeType) {
    return mimeType.startsWith("image/");
  }

  static bool checkAlbumType(String? mimeType, int? albumType) {
    if (mimeType == null || albumType == null) return false;
    switch (albumType) {
      case AlbumType.video:
        return mimeType.startsWith("video/");
      case AlbumType.audio:
        return mimeType.startsWith("audio/");
      case AlbumType.gallery:
        return mimeType.startsWith("image/");
      case AlbumType.application:
        return mimeType.startsWith("application/wasm") ||
            mimeType.startsWith("application/vnd.microsoft.portable-executable") ||
            mimeType.startsWith("application/x-ole-storage") ||
            mimeType.startsWith("application/vnd.debian.binary-package");
      //...
      default:
        return false;
    }
  }
}
