import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wms/common/baseWidgets/wms_text.dart';
import 'en_sku_table_cell.dart';
import 'package:wms/models/entrepot/en_sku_detail_model.dart';



class ENbuildSKuInfoWdidget extends StatefulWidget {
  final List list;
  final bool showmore;
  const ENbuildSKuInfoWdidget({Key key, this.list, this.showmore})
      : super(key: key);

  @override
  _ENbuildSKuInfoWdidgetState createState() => _ENbuildSKuInfoWdidgetState();
}

List list = [12, 3];
bool showmore = showmore;

@override
void initState() {
  print(list);
  print(showmore);
}

class _ENbuildSKuInfoWdidgetState extends State<ENbuildSKuInfoWdidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listWidget = [];
    for (var index = 0; index < list.length; index++) {
      listWidget.add(Container(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey[100],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                ),
                height: 60.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.grey[100],
                          ),
                          child: WMSText(
                            content: list[index]['size'],
                            size: 11,
                            bold: true,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 40.h,
                        // width: 60,
                        child: TextField(
                          maxLines: 1,
                          cursorColor: Colors.black,
                          controller: TextEditingController(
                              text: list[index]['skuCode']),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.r),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 0.1)),
                            hintText: "SKU码",
                            hintStyle: TextStyle(fontSize: 8.sp),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 40,
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40.h,
                                      width: 40.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        color: Colors.grey[100],
                                      ),
                                      child: WMSText(
                                        content: list[index]['actualNumber']
                                            .toString(),
                                        size: 11,
                                        bold: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: true,
                                  child: GestureDetector(
                                    onTap: () {
                                      //更改起作用showmore
                                      setState(() {
                                        showmore = !showmore;
                                      });
                                      print(showmore);
                                    },
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showmore,
                child: ENSkuTableCell(
                  eNSkuDetailModel: ENSkuDetailModel(skus: []),
                ),
              )
            ],
          ),
        ),
      ));
    }

    return Column(
      children: listWidget,
    );
  }
}
