import 'package:common_utils/common_utils.dart';

class WvTool {
  // 控制器
  static TimerUtil mCountDownTimerUtil;
  static TimerUtil orderCountDownTimerUtil;

  static void countdown(String time, Function callBack) {
    if (time == null) return;
    if (mCountDownTimerUtil != null) {
      mCountDownTimerUtil.cancel();
    }
    int now = DateUtil.getNowDateMs() ~/ 1000 * 1000;
    int createTime = DateTime.parse(time).millisecondsSinceEpoch;
    // 订单结束时长
    int _m = 15 * 60 * 1000;
    // int _m = 60 * 3 * 60 * 1000; //测试订单支付时间3小时
    // 下单时间 + 15分钟
    int _m2 = createTime + _m;
    // 下单15分后 - 当前时间
    int _m3 = _m2 - now;
    mCountDownTimerUtil = new TimerUtil(mInterval: 1000, mTotalTime: _m3);
    mCountDownTimerUtil.setOnTimerTickCallback((int tick) {
      // print('tick $tick');
      String H = '00';
      String M = (tick ~/ 60 ~/ 1000).toInt().toString().padLeft(2, '0');
      String S = (tick / 1000 % 60).toInt().toString().padLeft(2, '0');
      // print("'$H:$M:$S'");
      callBack('$H:$M:$S', tick);
      // countdownStr.value = '$H:$M:$S';
      // countdownInt.value = tick;
    });
    mCountDownTimerUtil.startCountDown();
  }

  static void orderCountdown(Function callBack) {
    if (orderCountDownTimerUtil != null) {
      orderCountDownTimerUtil.cancel();
    }
    //设置5分钟倒计时
    orderCountDownTimerUtil =
        new TimerUtil(mInterval: 6000, mTotalTime: 300000);
    orderCountDownTimerUtil.setOnTimerTickCallback((int tick) {
      callBack(tick / 1000);
    });
    orderCountDownTimerUtil.startCountDown();
  }
}
