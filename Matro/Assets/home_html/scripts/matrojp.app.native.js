/* 与native交互具体接口参数定义请参见接口文档 */


/**
 * 首页广告位点击事件
 * @param idx
 */
function scroll_click(idx, zcsp) {
    _native.navigationProduct(zcsp, idx);
}

/**
 * 首页频道icon区点击事件
 * @param idx
 */
function channel_click(idx) {
    _native.navigationFloor(idx);
}

/**
 * 首页楼层广告展示区点击事件
 * @param idx
 */
function floor_click(idx) {
    _native.navigationFloor(idx);
}

/**
 * 首页热卖精选产品点击事件
 * @param idx
 * @param productId
 */
function product_click(zcsp, productId) {
    _native.navigationProduct(zcsp, productId);
}