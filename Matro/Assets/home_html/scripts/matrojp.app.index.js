var matrojp_api = 'http://www.matrojp.com/ajax/app/index.ashx?op=index&webframecode=0301';
$(function() {
  slide(".allpage", 0, function (e) {
    var that = this;
    setTimeout(function () {
//      window.location.reload();
    }, 1000);
        
  });

  $('.hotsale a').click(function() {
    $('.hotsale a').removeClass('current');
    $(this).addClass('current');
  });
  $.ajax({
    url: matrojp_api,
    type: 'GET',
    success: function (res) {
    datasource = JSON.parse(res);
    //datasource={"GdggList":[{"TITLE":"首页广告","SRC":"http://61.155.212.163:83/img/GGW/o_1ah1961u61a1i4km1ktroraj1ja.jpg","URL":"","WIDTH":"1080","HEIGHT":"525","MC":"spid=1000000055","ID":"259","HOTIMG":""},{"TITLE":"首页广告","SRC":"http://61.155.212.163:83/img/GGW/o_1ag2b2ifc9og1cgl1ktdbv1vpno.jpg","URL":"","WIDTH":"1080","HEIGHT":"525","MC":"C050DB2292B378D43C3CDDA1C82E75A0","ID":"175","HOTIMG":""}],"ZttjList":[{"TITLE":"全球购|Worldwide","SRC":"http://61.155.212.163:83/img/GGW/o_1ag2b522t913r5s6fvpu31ofs16.jpg","URL":"","WIDTH":"110","HEIGHT":"103","MC":"全球购|Worldwide","ID":"179","HOTIMG":""},{"TITLE":"奢侈品|Luxuries","SRC":"http://61.155.212.163:83/img/GGW/o_1ag2b4karkli1lp2mka149qs88h.jpg","URL":"","WIDTH":"110","HEIGHT":"103","MC":"奢侈品|Luxuries","ID":"177","HOTIMG":""},{"TITLE":"休闲零食|Snacks","SRC":"http://61.155.212.163:83/img/GGW/o_1ah16vpb91fnl13ur1esq1srlbg4h.jpg","URL":"","WIDTH":"110","HEIGHT":"103","MC":"休闲零食|Snacks","ID":"253","HOTIMG":""},{"TITLE":"会员卡|Membership","SRC":"http://61.155.212.163:83/img/GGW/o_1ag2b4p94195spe8msm1niq1r2fo.jpg","URL":"","WIDTH":"110","HEIGHT":"103","MC":"会员卡|Membership","ID":"178","HOTIMG":""}],"LcggList":[{"TITLE":"雅培","SRC":"http://61.155.212.163:83/img/GGW/o_1ah185iqba5t3f81a2318d41qgda.jpg","URL":"","WIDTH":"1080","HEIGHT":"482","MC":"4","ID":"256","HOTIMG":""},{"TITLE":"美迪惠尔","SRC":"http://61.155.212.163:83/img/GGW/o_1ah189rc23mjnp7aia19kh19orn.png","URL":"","WIDTH":"1080","HEIGHT":"482","MC":"3","ID":"258","HOTIMG":""},{"TITLE":"悦木之源","SRC":"http://61.155.212.163:83/img/GGW/o_1ag2b6rae1iku8u4fpt1m4614mnh.jpg","URL":"","WIDTH":"1080","HEIGHT":"482","MC":"yd首页_21_结果","ID":"181","HOTIMG":""},{"TITLE":"倩碧","SRC":"http://61.155.212.163:83/img/GGW/o_1ag2b6pkhdnmmd17o9mcp1vt2a.jpg","URL":"","WIDTH":"1080","HEIGHT":"482","MC":"yd首页_23_结果","ID":"180","HOTIMG":""},{"TITLE":"花王","SRC":"http://61.155.212.163:83/img/GGW/o_1ag2b6t0gh2h38c14rh1tqn1jdvo.jpg","URL":"","WIDTH":"1080","HEIGHT":"482","MC":"yd首页_19_结果","ID":"182","HOTIMG":""},{"TITLE":"SK-II","SRC":"http://61.155.212.163:83/img/GGW/o_1ah188d1d1vc8ieshoc16s51p1jh.png","URL":"","WIDTH":"1080","HEIGHT":"482","MC":"1","ID":"257","HOTIMG":""}],"AppProductList":[{"CodeName":"全部","SPList":[{"JMSP_ID":"C050DB2292B378D43C3CDDA1C82E75A0","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"120","KCSL":"462","LSDJ":"120","SPNAME":"透明防晒条","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D4B969116AC20E8D90","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"2","KCSL":"397","LSDJ":"2.5","SPNAME":"雀巢衡怡纤维饮品550ml","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D436B90617D39E7D59","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"20","KCSL":"428","LSDJ":"20","SPNAME":"海绵扑","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D4E4EE60AC4F0AE45B","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"23","KCSL":"500","LSDJ":"23","SPNAME":"德芙黑巧克力150G","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D4E32D6C9446673C5D","ZCSP":"5","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657n7bq1q11138t4gtm1o9e5l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"69","KCSL":"151","LSDJ":"69","SPNAME":"宝莱澳洲纯牛奶126G","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{"2":"","3":""}},{"JMSP_ID":"C050DB2292B378D482248C6D1FCDBA9C","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657n7bq1q11138t4gtm1o9e5l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"4.9","KCSL":"460","LSDJ":"4.9","SPNAME":"MM30.6g纯牛奶巧克力迷你装","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{"2":"MM30.6g纯牛奶巧克力迷你装","3":"MM30.6g纯牛奶巧克力迷你装"}}]},{"CodeName":"全球购","SPList":[{"JMSP_ID":"C050DB2292B378D4E32D6C9446673C5D","ZCSP":"5","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657n7bq1q11138t4gtm1o9e5l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"69","KCSL":"151","LSDJ":"69","SPNAME":"宝莱澳洲纯牛奶126G","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{"2":"","3":""}}]},{"CodeName":"食甲天下","SPList":[{"JMSP_ID":"C050DB2292B378D45C371F31BCDA775B","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"5.9","KCSL":"486","LSDJ":"5.9","SPNAME":"一口恋花生巧克力派23g*6","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}}]},{"CodeName":"奢侈品","SPList":[{"JMSP_ID":"C050DB2292B378D41F8D1BB47FE32835","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"6.8","KCSL":"494","LSDJ":"6.8","SPNAME":"高乐高卷心牛奶蛋糕30gx4","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D49EFD36286B9B2670","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"190","KCSL":"484","LSDJ":"190","SPNAME":"防皱霜","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}}]},{"CodeName":"婴童用品","SPList":[{"JMSP_ID":"C050DB2292B378D41DB7794026BE94DE","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"115","KCSL":"468","LSDJ":"115","SPNAME":"眼线液","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D40A12421A0C7E948D","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"100","KCSL":"900","LSDJ":"115","SPNAME":"眼线液","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D4A993C5D2DB21636D","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"1.2","KCSL":"500","LSDJ":"1.6","SPNAME":"雀巢飘蓝水500ml","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}},{"JMSP_ID":"C050DB2292B378D435D767ECFB7C28D4","ZCSP":"0","IMGURL":"http://61.155.212.163:83/img/SPXSM/o_1a657nr9da6f1hsa5451dr5ftk1l_M.jpg","XSBJ":null,"XSSL":null,"XJ":"2","KCSL":"500","LSDJ":"2.9","SPNAME":"伟嘉妙妙厨新鲜黄鱼900g","XSMSP_ID":null,"PPNAME":"","TJBJ":"","TJ":"","NAMELIST":{}}]},{"CodeName":"饰品","SPList":[]},{"CodeName":"家居用品","SPList":[]}]};
      //console.log(datasource);
      // [FIX]修复服务端返回的数据格式问题(应该由服务端来做这个事情, 服务端表示是合理的 :-( )
      // [UPDATE]服务器貌似又按照这个要求调整了返回 str => json object
      /**
       $.each(datasource.GdggList, function(index, item) {
                datasource.GdggList[index] = JSON.parse(item);
            });
       $.each(datasource.LcggList, function(index, item) {
                datasource.LcggList[index] = JSON.parse(item);
            });*/
      $.each(datasource.ZttjList, function(index, item) {
        //datasource.ZttjList[index] = JSON.parse(item);
        datasource.ZttjList[index].iconChn = datasource.ZttjList[index].MC.split('|')[0];
        datasource.ZttjList[index].iconEng = datasource.ZttjList[index].MC.split('|')[1];
      });

      //绑定首页广告位
      $('#banner_data').bindTemplate({
        source: {'advlist': datasource.GdggList},
        template: $('#template-banner_data')
      });
      TouchSlide({slideCell: "#banner", titCell: ".hd ul", mainCell: ".bd ul", effect: "left", autoPlay: true, autoPage: true, delayTime:1000, interTime:3500});

      //获取首页频道icon区
      $('.channel').bindTemplate({
        source: {'iconlist': datasource.ZttjList},
        template: $('#template-channel')
      });

      //绑定首页楼层展示区
      $('#floor').bindTemplate({
        source: {'floorlist': datasource.LcggList},
        template: $('#template-floor')
      });

      //绑定首页热卖精选文字列表区
      $('.hotsale').bindTemplate({
        source: {'textlist': datasource.AppProductList},
        template: $('#template-recommend')
      });
      $('.hotsale a').first().addClass('current');
      $('.hotsale a').click(function() {
        $('.hotsale a').removeClass('current');
        $(this).addClass('current');

        get_products($(this).attr('idx'));
      });

      //获取首页热卖精选图文详细区
      get_products(datasource.AppProductList[0].CodeName);
    }
  });

  function get_products(codename) {
    $('.products').empty();
    var html = '<div class="row">';
    $(datasource.AppProductList).each(function(index, item) {
      if(item.CodeName == codename) {
        $(item.SPList).each(function(i, product) {
          html +=
            '<div class="col-xs-6">' +
            '<div class="col-item">' +
            '<a href="javascript:" onclick="product_click(\''+product.ZCSP+'\', \''+product.JMSP_ID+'\')">' +
            '<img src="'+product.IMGURL+'" alt="">' +
            '<span class="name">'+product.SPNAME+'</span>' +
            '<span class="price">¥'+format_money(product.XJ, 2)+' <span>¥'+format_money(product.LSDJ, 2)+'</span></span>' +
            '</a>' +
            '</div>' +
            '</div>';
          if(i % 2) {
            html += '</div><div class="row">';
          }
        });
      }
    });
    html += '</div>';
    $('.products').append(html);
  }

  /**
   * 格式化金额
   * @param s 金额
   * @param n 保留小数
   * @returns {string}
   */
  function format_money(s, n) {
    n = n > 0 && n <= 20 ? n : 2;
    s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
//    var l = s.split(".")[0].split("").reverse();
//    //r = s.split(".")[1];
//    var t = "";
//    for(i = 0; i < l.length; i ++ )
//    {
//      t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
//    }
    return s;//t.split("").reverse().join("");// + "." + r;
  }
});