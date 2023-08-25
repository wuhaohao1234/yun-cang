///  支符密码  用于 密码输入框和键盘之间进行通信
class KeyEvent {
  ///  当前点击的按钮所代表的值
  String key;

  KeyEvent(this.key);

  bool isDelete() => this.key == "del";

  bool isCommit() => this.key == "commit";
}
