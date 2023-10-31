import 'dart:math';

class ShareUtil {
  // 创建随机数生成器实例
  static final rand = Random();

  //生成n位提取码
  static String generateCode({int len = 4}) {
    // 可选字符数组
    final chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
    // 生成四位提取码
    final code = List.generate(len, (_) => chars[rand.nextInt(chars.length)]).join('');
    return code;
  }
}
