class UnitUtil{
  static String convertByteUnits(int? bytes) {
    if(bytes==null){
      return '--';
    }
    double converted = bytes.toDouble();
    List<String> units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int index = 0;

    while (converted >= 1024 && index < units.length - 1) {
      converted /= 1024;
      index++;
    }

    return '${converted.toStringAsFixed(2)} ${units[index]}';
  }
}