class HttpApis {
  // static const baseUrl = 'http://47.100.251.76:8080';
  // static const baseUrl = 'http://wms.yuyouship.top/prod-api';
  // static const baseUrl = 'http://192.168.0.122:9090';
  static const baseUrl = 'http://admin.topyuncang.com/prod-api/'; //正式环境

  static const agreement =
      'http://120.27.15.182/profile/h5/agreement.html'; //  服务合作协议

  static const aboutUs = 'http://www.topyuncang.com'; //  关于我们
  static const companyInfo = 'http://admin.topyuncang.com/companyInfoHtml'; //
  static const countryList = '/system/country/list'; //  国家列表
  static const provinceList = '/api/address/provincelist'; //  省列表

  static const cityList = '/api/address/sysCitylist'; //  市列表

  static const areaList = '/api/address/sysArealist'; //  区列表

  static const sendVerificationCode = '/system/api/message/add'; //  发送验证码

  static const resetPwd = '/system/api/wmsuser/reset'; //  修改密码接口

  static const register = '/system/api/wmsuser/add'; //  注册

  static const login = '/system/api/wmsuser/login'; //  登录

  static const warehouseNum = '/api/warehouse/warehouseNum'; // 查询今日仓储情况

  static const modifyUserInfo = '/system/api/wmsuser/edit'; //  修改用户信息接口

  static const getUserInfo = '/system/api/wmsuser/details'; // 获取用户信息接口

  static const checkVerificationCode = '/system/api/message/query'; // 查询验证码是否正确

  static const oss = '/wms/alioss'; // 获取阿里云oss签名

  static const enAddOrepareOrder = '/system/api/prepareOrder'; // 仓库端生成预约入库单

/* ######################################################客户端################################################################################*/
//预约入库
  static const depotList =
      '/user/api/prepareOrder/prepareOrderDepotList'; // 查询仓库
  static const prepareOrderDepotList =
      '/user/api/prepareOrder/depotList'; // 客户端APP查询所有仓库详细信息
  static const prepareOrderList =
      '/user/api/prepareOrder/prepareOrderList'; // 客户端APP查询预入库订单
  static const prepareOrderDetailList =
      '/user/api/prepareOrder/prepareOrderDetailList'; // 客户端APP查询预约入库单详情
  static const getSpuSkuList = '/user/api/prepareOrder/spuSkulist'; // 获取商品列表
  static const csAddNewOrder = '/user/api/prepareOrder/addNewOrder'; // 用户申请新品
  static const csAddSku = '/user/api/prepareOrder/addSku'; // 用户添加商品
  static const csGetSku = '/user/api/prepareOrder/getSku'; // 用户查询订单绑定商品
  static const csUpdataCommodityNumber =
      '/user/api/prepareOrder/updataCommodityNumber'; // 修改预约数量
  static const csDeleSku = '/user/api/prepareOrder/deleSku'; // 客户端删除sku信息
  static const addPrepareOrder = '/user/api/prepareOrder'; // 客户端用户添加预约入库单
  static const updataPrepareOrder =
      '/user/api/prepareOrder/updataPrepareOrder'; // 客户端修改预约入库单,发货功能
  static const updPrepareOrder =
      '/user/api/prepareOrder/updPrepareOrder'; // 客户端修改预约入库单,改变物流单号

//自主仓
  static const newsOrderList =
      '/user/api/prepareOrder/newsOrderList'; // 客户端APP查询预自主仓订单
  static const newsOrderDetail =
      '/user/api/prepareOrder/newsOrder'; // 客户端APP查询预自主仓订单详情
  static const updNewsOrder =
      '/user/api/prepareOrder/updNewsOrder'; // 客户端APP自主仓仓订单取消
  static const addVirtualOrder =
      '/app/virtual/store/order/add'; // 客户端APP自主仓生成入库单
  static const addVirtualSku = '/app/virtual/store/sku/add'; // 客户端APP自主仓添加其他商品

//无主单
  static const csWzjList =
      '/user/api/prepareOrder/ownerLessList'; // 客户端APP查询无主单列表
  static const wzjDetail =
      '/user/api/prepareOrder/ownerLessDetail'; // 客户端APP查询无主单详情
  // 临存
  static const csTemporaryExistenceList =
      '/user/api/prepareOrder/temporaryExistenceList'; // 用户APP人员临存订单
  static const csTemporaryExistenceListDetail =
      '/user/api/prepareOrder/temporaryExistenceDetail'; // 用户APP人员临存订单详情
  static const csAddOutStore =
      '/user/api/prepareOrder/addOutStore'; // 用户APP人员提交出库单
//出库
  static const getWillList = '/app/out_store/will_list'; // 获取待出库列表
  static const getAlreadyList = '/app/out_store/already_list'; // 获取已出库单列表
  static const csOutStoreDetail = '/app/out_store'; // 获取待出库详情
  static const csAlreadyDetail = '/app/out_store/already'; // 客户端获取已出库详情

//库存
  static const getDepotTagList = '/app/storage/depotTag/list'; // 客户端APP查询仓库标签
  static const getCategoryList = '/app/storage/category'; // 客户端APP查询品类
  static const getFirstCategorys = '/app/market/firstCategorys'; // 客户端APP查询所有一级品类
  static const getSpuList = '/app/storage/spu/list'; // 客户端APP查询库存商品列表
  static const csPostOutStoreNormalSize =
      '/app/storage/outStore/normal'; // 库存正常件出库，点击spu获取尺码列表
  static const csPostOutStoreDefectSize =
      '/app/storage/outStore/defect/size'; // 库存瑕疵件出库，点击spu获取尺码列表
  static const csPostOutStoreDefectSizeList =
      '/app/storage/outStore/defect/list'; // 库存瑕疵件出库，根据storeId查列表
  static const csPostOutStore = '/app/storage/outStore'; // 库存出库
  static const spuShelfDefectDetail =
      '/app/storage/spu/shelf/defect/detail'; // 客户端APP库存的出售详情-瑕疵件
  static const spuShelfNormalDetail =
      '/app/storage/spu/shelf/normal/detail'; // 客户端APP库存的出售详情-正常件
  static const spuShelfDefect =
      '/app/storage/spu/shelf/defect/list'; // 客户端APP库存的瑕疵件列表
  static const postSpuNormalShelf =
      '/app/storage/spu/normal/shelf'; // 客户端APP库存的正常件出售
  static const postSpuDefectShelf =
      '/app/storage/spu/defect/shelf'; // 客户端APP库存的瑕疵件出售

//异常单
  static const getExceptionOrderList =
      '/user/api/prepareOrder/exceptionOrderList'; // 获取异常件列表
  static const exceptionListDetail =
      '/user/api/prepareOrder/exceptionListDetail'; // 查询异常单详情

  static const warehouseMoneysLog =
      '/api/money/warehouseMoneysLog'; // 客户端APP查询仓储流水
//我的账户
  static const getCardList = '/app/card/list'; // 客户端APP查询银行卡
  static const getCardDetail = '/app/card'; // 客户端APP查询银行卡
  static const addCard = '/app/card/add'; // 客户端APP添加银行卡
  static const editCard = '/app/card/edit'; // 客户端APP添加银行卡
  static const walletAccount = '/api/money/details'; // 客户端APP查询账户余额
  static const shopMoneysLog = '/api/money/shopMoneysLog'; // 客户端APP查询店铺流水
  static const withdrawal = '/api/money/withdrawal'; // 客户端APP提现

  //我的微信
  static const getWeChatAccount =
      '/system/api/wmsuser/getWeChatAccount'; // 客户端APP获取微信账号
  static const getBindWeChat = '/system/api/wmsuser/bindWeChat'; // 客户端APP绑定微信账号

//地址
  static const addAddress = '/api/address/add'; // 新增收货地址
  static const editAddress = '/api/address/edit'; // 修改收货地址
  static const getAddressList = '/api/address/list'; // 获取收货地址列表
  static const deleteAddress = '/api/address'; // 删除地址

  static const getinstoreOrderList =
      '/user/api/prepareOrder/instoreOrderList'; // 客户端查询入库单列表
//集市
  static const csGetMarketSpuList = '/app/market/spu/list'; // app客户端集市获取集市商品列表
  static const csGetMarketSpuSize = '/app/market/spu/size'; // app客户端集市获取商品详情
  static const csGetChuHuoNormalList =
      '/app/market/sku/outStore/normal/list'; // 集市在售商品详情页查询出货列表正常商品
  static const csGetChuHuoDefectList =
      '/app/market/sku/outStore/defect/list'; // 集市在售商品详情页查询出货列表瑕疵商品
  static const csMarketResale = '/app/market/resale'; // 集市正常商品转售
  static const csMarketInfo = '/wms/commodity/app'; // 集市商品详情

  //订单

  static const businessOrder = '/api/businessOrder'; // 订单
  static const perfectInfo = '/api/address/perfect'; // 修改地址信息（完善实名信息）
  static const outOrderExpress = '/app/order/express'; // 订单添加物流
  static const csMarketOrderAdd = '/app/order/add'; // 集市提交订单
  static const csMarketOrderTaxFee = '/app/order/taxFee'; // 集市计算税费接口
  static const getOrderlist = '/app/order/list'; // 手机端查询订单列表
  static const getToBC = '/app/order/toBc'; // 清关重推
  static const postOrderReceived = '/app/order/received'; // 确认收货

// 我的在售
  static const csOnSaleList = '/app/storage/mine/onSale'; // app我的在售
  static const csOffShelf = '/app/storage/mine/offShelf'; // app下架转售商品
  static const csOnSaleDetail = "/app/storage/mine/mySaleDetail"; //app在售详情
  static const csOnSaleOffSeparate = "/app/storage/mine/offSeparate"; //app单品下架
  static const csOnSaleAdjustPrice = "/app/storage/adjustPrice"; //app单品调整价格
// -----                             /app/storage/mine/adjustPrice

  static const csInStoreOrderDetail =
      '/user/api/prepareOrder/inStoreOrderDetail'; // 客户端查询入库单详情

  static const userClaimOwnerLessSysPrepareOrder =
      '/user/api/prepareOrder/userClaimOwnerLessSysPrepareOrder'; // 客户端认领无主单

//  客户端库存相关
  static const getInventoryCategorys =
      '/app/inventory/category_qty'; // 获取库存列表品类标签信息
  static const getInventoryList = '/app/inventory/list'; // 获取库存列表
  static const setSaleSkuDWPrice = '/user/sale/setSaleSkuDWPrice'; // 设置在售单品得物价格
  static const setSaleSkuAppPrice =
      '/user/sale/setSaleSkuAppPrice'; // 设置在售单品集市价格
  static const editForeSaleSku = '/user/sale/editForeSaleSku'; // 修改在售商品app的价格

/* ######################################################仓库端################################################################################*/
// 通用
  static const getselStayTally =
      '/system/api/prepareOrder/selStayTally'; //查询待理货或待上架订单
  static const getTallyDetail =
      '/system/api/prepareOrder/tallyDetails'; //待理货订单详情
  static const enAddNewOrder =
      '/system/api/prepareOrder/addNewOrder'; // 仓管人员申请新品
  static const entallyStockCode =
      '/system/api/prepareOrder/tallyByStockCode'; // 仓管人员申请新品时判断是否为新品completed
  static const enOrderCount =
      '/system/api/prepareOrder/orderCount'; //查询订单个数completed
  static const enPrepareOrderDetail =
      '/system/api/prepareOrder/prepareOrderDetailList'; // 仓管APP人员查询所有预约入库单
  static const enInStoreOrderList =
      '/system/api/prepareOrder/inStoreOrderList'; // 仓管app使用者查询入库单列表
//待收货
  static const enPrepareOrderList =
      '/system/api/prepareOrder/prepareOrderList'; // 仓管APP人员查询所有预约入库单completed
  static const enSignOrder =
      '/system/api/prepareOrder/signOrder'; // 仓管APP人员签收有预约订单completed
  static const enSignNoForecastOrder =
      '/system/api/prepareOrder/signNoForecastOrder'; // 仓管APP人员签收无预约订单
  static const enQueryMail =
      '/system/api/prepareOrder/queryByMailNo'; // 仓管APP人员扫描待收货订单
  static const enTemporaryExistenceOrderList =
      '/system/api/prepareOrder/temporaryExistenceOrderList'; // 仓管APP人员临存订单

//代理货
  static const enSearchSkuByScan =
      '/system/api/prepareOrder/tallyScanCode'; //根据扫码查询商品
  static const enSearchSkuByCode =
      '/system/api/prepareOrder/tallyByCode'; //根据货号查询商品
  static const getSPuDetail =
      '/system/api/prepareOrder/tallySpuId'; //查询商品spuId详情
  static const inspectionComplete =
      '/system/api/prepareOrder/inspectionComplete'; //提交需要质检理货信息
  static const noInspectionComplete =
      '/system/api/prepareOrder/noInspectionComplete'; //提交不需要质检理货信息
  static const getTallySpuDetails =
      '/system/api/prepareOrder/tallySpuDetails'; //理货中心sku中的sn信息
  static const tallysubmisssion =
      '/system/api/prepareOrder/tallySubmission'; //理货完成

  static const updateSpuInfo =
      '/system/api/prepareOrder/updOrderSku'; // 修改条形码与理货数量

  static const deleteSkuInfo = "/system/api/prepareOrder/delOrderSku"; //删除SKU
  static const deleteSn =
      "/system/api/prepareOrder/deleSn/"; // 删除SN(注意,后面要跟一个id)

  //待上架
  static const tallyShelf = '/system/api/prepareOrder/tallyShelf'; //提交上架
  // 判断仓位是否可用
  static const locationIsExist =
      '/system/api/prepareOrder/locationIsExist'; //判断仓位是否可用
//分拣
  static const enSortingCount = '/system/api/outOrder/sortingCount'; //查看分拣条数
  static const enSortingList = '/system/api/outOrder/sortingList'; //查看分拣数据集合
  static const enSortingDetail = '/system/api/outOrder/sortingDetail'; //查看分拣详情
  static const enSortingSpu = '/system/api/outOrder/sortSpu'; //根据skuCode分拣
  static const enScanSnCode = '/system/api/outOrder/scanSnCode'; //根据snCode分拣
  static const enUpdSortingNumber =
      '/system/api/outOrder/updSortingNumber'; //修改分拣商品数量
  static const enSortingCompleted =
      '/system/api/outOrder/sortingCompleted'; //分拣完成
  static const sortSkuAndSn =
      '/system/api/outOrder/sortSkuAndSn'; //根据SnCode或者SkuCode分拣商品
//出仓
  static const enQueryNumber = '/app/out_store/queryNumber'; //查看待出库与已出库数量
  static const enWillList = '/app/out_store/will_list'; //查看待出库
  static const enAlreadyList = '/app/out_store/already_list'; //查看已出库
  static const enOutStore = '/app/out_store'; //修改出库单

//无主单
  static const enOwnerLessList =
      '/system/api/prepareOrder/ownerLessList'; // 仓管app人员查询无主单列表
  static const enOwnerLessDetail =
      '/system/api/prepareOrder/ownerLessDetail'; // 仓管app人员查询无主单详情
  static const addOwnerLessSysPrepareOrder =
      '/system/api/prepareOrder/addOwnerLessSysPrepareOrder'; // 仓管APP人员生成无主单

  static const enInStoreOrderDetail =
      '/system/api/prepareOrder/inStoreOrderDetail'; // 仓管人员查询入库单详情
//异常单
  static const enExceptionOrderList =
      '/system/api/prepareOrder/exceptionOrderList'; // 查询异常单列表
  static const enExceptionListDetail =
      '/system/api/prepareOrder/exceptionListDetail'; // 查询异常单详情
  static const enQueryByMailNo =
      '/system/api/prepareOrder/queryByMailNo'; // 仓管人员扫运单号查询预约入库单
//查询

  static const enPrepareSkuDetail =
      '/system/api/prepareOrder/prepareSkuDetail'; // 仓管人员查询商品详情
  static const enAddSku = '/system/api/prepareOrder/addSku'; // 仓管人员添加商品
  static const commitSku = '/system/api/prepareOrder/commitSku'; // 仓管人员提交入库单
  static const logistics = '/system/api/logistics/all'; // 物流轨迹查询(非etk和港澳本地)
  static const editPrepareOrder =
      '/system/api/prepareOrder/editPrepareOrder'; // 仓管人员上传照片（快递面单/货单）

  static const upDateVersion = '/api/apk/now'; // 版本更新

  static const dwzdj = '/wms/dewu/lowest_price'; // 查询得物平台商品最低出价
  static const changeAgent =
      '/system/api/wmsuser/loginByAgentId'; // 查询得物平台商品最低出价
  static const getAgentList = '/system/api/wmsuser/selectAgentList';
  static const addAgent = '/system/api/wmsuser/bindAgent';

// new add

/* ###################################################### WV ################################################################################*/

  static const payMoneys = '/api/businessOrder/payMoneys'; // 订单支付
  static const sizeQty = '/app/inventory/size_qty'; // 手动选择页面获取选择尺码标签

  static const sizeInventory = '/app/inventory/size_inventory'; // 手动选择页面选择商品列表
  static const addForSale = '/app/inventory/addForSale'; // 商品上架可售
  static const outStore = '/app/out_store'; // 出库确认

  static const selectExceptionSkuSendBack =
      '/user/api/prepareOrder/selectExceptionSkuSendBack'; // 选择瑕疵瑕商品
  static const exceptionSkuSendBackAndCommit =
      '/user/api/prepareOrder/exceptionSkuSendBackAndCommit'; // 客户端app瑕疵件退回
  static const prepareSkuDetail =
      '/user/api/prepareOrder/prepareSkuDetail'; // 查询商品详情

  static const getJiShiPrice = '/user/sale/getJiShiPrice'; // 查询集市价格表
  static const forSaleDetialList = '/user/sale/forSaleDetialList'; // 查看在售列表
  static const confirmOut = '/app/inventory/confirm_out/list'; // 获取出仓物品清单
  static const commitForSaleSku =
      '/user/sale/commitForSaleSku'; // （单品在售我的）下架商品提交
  static const getEtk = '/api/businessOrder/get_etk'; // 通过skuId获取最小etk限数

  static const mineInfo = '/system/api/wmsuser/userInfo'; // 获取固定用户信息详细信息

  // 支付相关
  static const submitPaymentInfo = "/app/order/pay"; //测试支付->提交支付信息

/* ###################################################### 废弃 ################################################################################*/

  // static const marketMyList = '/app/market/my/list'; // app客户端集市我的在售
  // static const marketAllList = '/app/market/all/list'; // 客户app集市在售列表
  //   static const marketAllDetail = '/app/market/all'; // 获取集市在售单品详情
  // static const marketMyDetail = '/app/market/my'; // 获取我的在售单品详情
  // static const getChuHuoList = '/user/sale/getChuHuoList'; // 集市在售商品详情页查询出货列表
  // static const getChuHuoList2 =
  //     '/user/sale/getChuHuoList'; // 集市在售商品详情页查询出货列表-新需求
  //   static const getTenantlist =
  //     '/api/businessOrder/tenantlist'; // 手机端查询卖家订单列表（1期）
  // static const getBuyerslist =
  //     '/api/businessOrder/buyerslist'; // 手机端查询买家订单列表（1期）
  // static const receivingGoods =
  //   '/api/businessOrder/receivingGoods'; // 订单确认收货（1期）
  // static const businessOrderAdd = '/api/businessOrder/add'; // 下订单（1期）
  // static const businessOrde = '/api/businessOrde'; // 下订单（1期）
}
