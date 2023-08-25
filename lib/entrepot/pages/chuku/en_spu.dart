// 给出库用的spu list

import 'package:wms/entrepot/pages/common.dart'; //页面通用依赖集合

Widget buildSpuList({List skuList, editable: true, Function afterEdit, bool actualNumberEditable}) {
  final rowHeight = 40.h;
  final mh = [rowHeight * (skuList.length + 1), rowHeight * 3];
  mh.sort();
  return Column(
    children: [
      skuList.runtimeType != List
          ? Container(
              height: mh[1],
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: skuList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SpuBlock(
                        spu: skuList[index],
                        rowHeight: rowHeight,
                        afterEdit: afterEdit,
                        index: index,
                        editable: editable,
                        actualNumberEditable: actualNumberEditable);
                  },
                ),
              ),
            )
          : Container(child: Text("暂无数据"))
    ],
  );
}

class SpuBlock extends StatefulWidget {
  final dynamic spu;
  final Function afterEdit; // 修改数据以后的回调函数
  final bool actualNumberEditable; //实收数量是否可以修改
  final rowHeight;
  final int index;
  final bool editable;

  SpuBlock(
      {Key key, this.spu, this.rowHeight, this.afterEdit, this.index, this.actualNumberEditable, this.editable = true})
      : super(key: key);

  @override
  State<SpuBlock> createState() => _SpuBlockState();
}

class _SpuBlockState extends State<SpuBlock> {
  final hs = HttpServices();
  var rowHeight = 40.h;
  final radius = 5.r;
  bool showmore = true;
  final warningColor = Colors.red[400];
  String oldSkuCode;

  TextEditingController _actualNumberController;
  TextEditingController _skuCodeController;

  @override
  void initState() {
    rowHeight = widget.rowHeight ?? 40.h;

    super.initState();
    oldSkuCode = widget.spu['skuCode'].toString();
    _actualNumberController = TextEditingController(text: widget.spu['actualNumber']?.toString());

    _skuCodeController = TextEditingController(text: widget.spu['skuCode'].toString());
  }

  @override
  void dispose() {
    _actualNumberController.dispose();
    _skuCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey;
    final borderWidth = 1.0;
    bool showRedAsIncomplete = false;
    if (widget.spu['skuDetailList'] != null) {
      for (int _i = 0; _i < widget.spu['skuDetailList'].length; _i++) {
        if (widget.spu["skuDetailList"][_i]['skuNumber'] != widget.spu["skuDetailList"][_i]['sortingSkuNumber']) {
          showRedAsIncomplete = true;
          break;
        }
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: radius),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: showRedAsIncomplete ? warningColor : Colors.grey[200], // this part should be dynamic
              borderRadius: BorderRadius.circular(5.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: WMSText(
                      content:
                          '尺码: ${widget.spu['size'] ?? '无'}${widget.spu['specification'] != null ? "/" + widget.spu['specification'] : ""}',
                      size: 12,
                      bold: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: WMSText(
                      content: 'SKU码: ${widget.spu['skuCode'] ?? '无'}',
                      size: 12,
                      bold: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: Visibility(
                      visible: widget.spu['skuDetailList'] != null,
                      //  ??
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showmore = !showmore;
                          });
                        },
                        child: Icon(
                          showmore == true ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.spu['skuDetailList'] != null && showmore,
            child: Column(
              children: [
                Container(
                  height: rowHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50.w,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: borderWidth, color: borderColor),
                              bottom: BorderSide(width: borderWidth, color: borderColor),
                              left: BorderSide(width: borderWidth, color: borderColor),
                              right: BorderSide(width: borderWidth, color: borderColor),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('应出数'),
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: borderWidth, color: borderColor),
                              bottom: BorderSide(width: borderWidth, color: borderColor),
                              right: BorderSide(width: borderWidth, color: borderColor),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('实出数'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: borderWidth, color: borderColor),
                              bottom: BorderSide(width: borderWidth, color: borderColor),
                              right: BorderSide(width: borderWidth, color: borderColor),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('SN码'),
                        ),
                      ),
                      SizedBox(
                        width: 80.w,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: borderWidth, color: borderColor),
                              bottom: BorderSide(width: borderWidth, color: borderColor),
                              right: BorderSide(width: borderWidth, color: borderColor),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('库位'),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.spu['skuDetailList'] != null)
                  Container(
                    height: widget.spu["skuDetailList"].length * rowHeight,
                    child: ListView.builder(
                      itemCount: widget.spu["skuDetailList"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: rowHeight,
                          color: widget.spu["skuDetailList"][index]['skuNumber'] !=
                                  widget.spu["skuDetailList"][index]['sortingSkuNumber']
                              ? warningColor
                              : Colors.white,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(width: borderWidth, color: borderColor),
                                        left: BorderSide(width: borderWidth, color: borderColor),
                                        right: BorderSide(width: borderWidth, color: borderColor)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('${widget.spu["skuDetailList"][index]['skuNumber']}'), //应出数目
                                ),
                              ),
                              SizedBox(
                                width: 50.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: borderWidth, color: borderColor),
                                      right: BorderSide(width: borderWidth, color: borderColor),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('${widget.spu["skuDetailList"][index]['sortingSkuNumber']}'),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: borderWidth, color: borderColor),
                                      right: BorderSide(width: borderWidth, color: borderColor),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('${widget.spu["skuDetailList"][index]['snCode'] ?? '/'}'),
                                ),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: borderWidth, color: borderColor),
                                      right: BorderSide(width: borderWidth, color: borderColor),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('${widget.spu["skuDetailList"][index]['location'] ?? '暂缺'} '),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
