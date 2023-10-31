class AlbumType {
  static const int all = 0;
  static const int audio = 1;
  static const int video = 2;
  static const int gallery = 3;
  static const int application = 4;

  static const option = [
    (AlbumType.audio, "音频"),
    (AlbumType.video, "视频"),
    // (AlbumType.gallery, "画廊"),
    // (AlbumType.application, "应用"),
  ];

  static String getAlbumTypeName(int? type){
    switch(type){
      case audio:
        return "音频";
      case video:
        return "视频";
      case gallery:
        return "画廊";
      case application:
        return "应用";
      default:
        return "未知";
    }
  }

}
