// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wms/common/baseWidgets/wms_text.dart';
// import 'package:wms/views/customer/market/market_cell_widget.dart';
// import 'package:wms/views/entrenpot/ruku/en_rkd_cell.dart';
// import 'controllers/mk_search_page_controller.dart';
// import 'market_all_detail_page.dart';
// import 'market_my_detail_page.dart';

// class MKSearchPage extends StatelessWidget {
//   final int listType;

//   const MKSearchPage({Key key, this.listType}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     MKSearchPageController pageController = Get.put(MKSearchPageController());

//     return Scaffold(
//       body: Container(
//         color: Theme.of(context).primaryColor,
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 24.h),
//               child: Container(
//                 height: 52.0,
//                 child: Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30),
//                                 color: Colors.grey[200]),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 SizedBox(
//                                   width: 8.w,
//                                 ),
//                                 Icon(
//                                   Icons.search,
//                                   color: Colors.grey,
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     child: TextField(
//                                       onSubmitted: (value) {
//                                         pageController.request(listType);
//                                       },
//                                       controller: pageController.textC,
//                                       keyboardType: TextInputType.text,

//                                       ///控制键盘的功能键 指enter键，比如此处设置为next时，enter键
//                                       textInputAction: TextInputAction.search,
//                                       decoration: InputDecoration(
//                                           contentPadding:
//                                               EdgeInsets.only(top: -8.h),
//                                           hintText: '请输入商品名称',
//                                           hintStyle: TextStyle(fontSize: 13.sp),
//                                           border: InputBorder.none),
//                                       // onChanged: onSearchTextChanged,
//                                     ),
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: new Icon(Icons.cancel),
//                                   color: Colors.grey,
//                                   iconSize: 18.0,
//                                   onPressed: () {
//                                     // onSearchTextChanged('');
//                                     pageController.textC.text = '';
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => Get.back(),
//                           child: WMSText(
//                             content: '取消',
//                           ),
//                         )
//                       ],
//                     )),
//               ),
//             ),
//             Expanded(
//               child: Obx(
//                 () {
//                   return ListView.builder(
//                     padding: EdgeInsets.zero,
//                     itemBuilder: (context, index) {
//                       if (pageController.dataSource.length == 0) {
//                         return Container(
//                           padding: EdgeInsets.only(top: 100.h),
//                           child: Center(
//                             child: WMSText(
//                               content: '暂无数据',
//                             ),
//                           ),
//                         );
//                       }
//                       if (listType == 1) {
//                         return GestureDetector(
//                           onTap: () {
//                             Get.to(
//                               () => MarketAllDetailPage(
//                                 spuId: pageController.dataSource[index].spuId,
//                               ),
//                             );
//                           },
//                           child: MarketCellWidget(
//                             model: pageController.dataSource[index],
//                           ),
//                         );
//                       }
//                       return GestureDetector(
//                         onTap: () {
//                           Get.to(
//                             () => () => MarketMyDetailPage(
//                                   spuId: pageController.dataSource[index].spuId,
//                                 ),
//                           );
//                         },
//                         child: MarketCellWidget(
//                           model: pageController.dataSource[index],
//                         ),
//                       );
//                     },
//                     itemCount: pageController.dataSource.length == 0
//                         ? 1
//                         : pageController.dataSource.length,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
