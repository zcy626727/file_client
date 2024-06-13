class DownloadTaskStatus {
  static const int init = 1;
  static const int downloading = 2;
  static const int awaiting = 3;
  static const int pause = 4;
  static const int finished = 5;
  static const int error = 6;
}

class DownloadTaskType {
  static const int user = 1;
  static const int space = 2;
}
