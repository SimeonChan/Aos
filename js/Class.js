/*
需要实例化类定义
*/

///图片预载器
function clsImageLoader(url, func) {
    var gUrl = url;
    var gFunc = func;

    ///载入图片
    clsImageLoader.prototype.load = function () {
        var Img = new Image();
        
        Img.onerror = function () {
            gFunc(gUrl);
        };

        Img.onload = function () {
            gFunc(gUrl);
        };

        Img.src = gUrl;
    }

}