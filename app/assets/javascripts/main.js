// 詳細テキスト表示エリアを切り替えるイベント
$('.detail-area-toggle-button').click(function(){
  toggleDetailArea();
});

// いいねボタン押下時のイベント
$('.folder-like').click(function(){
  $(".folder-like-icon").toggleClass("liked");
  $.ajax({
    type: 'GET',
    url: $(this).attr("data-href"),
    dataType: 'json',
    success: function(json){
      if (json['liked']) {
        $(".folder-like-icon").addClass("liked");
      } else {
        $(".folder-like-icon").removeClass("liked");
      }
      $(".content-header-folder-likes").text(json['like_count'])
      viewToaster(json['info_message'], "info")
    }
  });
});

// サイドバーのフォルダー名マウスホバー時に詳細エリアに情報を表示する
$('.sidebar-folder').hover(function(){
    var folder_name = $(this).find('.sidebar-folder-name').text();
    var folder_note = $(this).find('.sidebar-folder-note').text();
    setDetailArea(folder_name, "", folder_note, "");
  },
  function() {
  }
);

// コンテンツヘッダーのインフォメーションアイコンを押下時に詳細エリアに情報を表示する
$('.content-header-folder-info').click(function(){
    var folder_name = $('.content-header-folder-name').text();
    var folder_note = $('.content-header-folder-note').text();
    setDetailArea(folder_name, "", folder_note, "");
    // 非表示の時に表示
    if(!$(".detail-area").hasClass('active')){
      toggleDetailArea();
    }
});

// リンクのインフォメーションアイコンを押下時に詳細エリアに情報を表示する
$('.link-info').click(function(){
    var link_name = $(this).parents(".link-box").find('.link-name').text();
    var link_url = $(this).parents(".link-box").find('.link-url').text();
    var link_note = $(this).parents(".link-box").find('.link-note').text();
    var color = $(this).parents(".link-box").attr("class").split(" ")[0].split("-")[3];
    setDetailArea(link_name, link_url, link_note, color);
    // 非表示の時に表示
    if(!$(".detail-area").hasClass('active')){
      toggleDetailArea();
    }
});

// フォルダー作成時にスマホ画面だった場合は、サイドバーを閉じる
$('.sidebar-folder-create').click(function(){
  var width = $(window).width();
  if (width < 768) {
    $('.sidebar-toggle')[0].click();
  }
  $('#folder-create-modal').modal();
});

// リンク登録時のカラースキンクリック時の挙動
$("[id^='link-create-skin-type']").click(function(){
  // 一度すべてのスキンからactive要素を除外
  $("[id^='link-create-skin-type']").removeClass("active");
  $(this).addClass("active");
  $("#link-create-skin-type-form").val($(this).attr("link-skin-data"));
});

// リンク変更時のカラースキンクリック時の挙動
$("[id^='link-edit-skin-type']").click(function(){
  // 一度すべてのスキンからactive要素を除外
  $("[id^='link-edit-skin-type']").removeClass("active");
  $(this).addClass("active");
  $("#mock-link-edit-skin-type-form").val($(this).attr("link-skin-data"));
});

// リンク変更ボタン押下時の挙動
$("[id^='link-edit-button-']").click(function(){
  // リンク変更フォームの値を空にする
  $("#mock-link-edit-name-form").val("");
  $("#mock-link-edit-url-form").val("");
  $("#mock-link-edit-comment-form").val("");
  $("#mock-link-edit-skin-type-form").val("");
  $("#editing-link-id").val("");
  // カラースキンの選択状態をクリア、初期値にセット
  $("[id^='link-edit-skin-type']").removeClass("active");
  $("#mock-link-edit-skin-type-default").addClass("active");

  // リンク変更フォームに値をセットする
  var id = $(this).attr("id").split("-")[3];
  var form = $("#link-edit-form-" + id);
  $("#mock-link-edit-name-form").val(form.children("#link-edit-name-form").val());
  $("#mock-link-edit-url-form").val(form.children("#link-edit-url-form").val());
  $("#mock-link-edit-comment-form").val(form.children("#link-edit-comment-form").val());
  $("#mock-link-edit-skin-type-form").val(form.children("#link-edit-skin-type-form").val());
  $("#link-edit-skin-type-" + form.children("#link-edit-skin-type-form").val()).addClass("active");
  $("#editing-link-id").val(id);
});

// リンク変更ボタン押下時の挙動
$("#mock_link_edit_btn").click(function(){
  var id = $("#editing-link-id").val();
  var form = $("#link-edit-form-" + id);
  form.children("#link-edit-name-form").val($("#mock-link-edit-name-form").val());
  form.children("#link-edit-url-form").val($("#mock-link-edit-url-form").val());
  form.children("#link-edit-comment-form").val($("#mock-link-edit-comment-form").val());
  form.children("#link-edit-skin-type-form").val($("#mock-link-edit-skin-type-form").val());
  form.submit();
});

// フォルダーソートボタン押下時の挙動
$("#mock-folder-sort-button").click(function(){
  var width = $(window).width();
  // 現在の画面サイズがスマホ画面だった場合は、サイドバーを非表示にする
  if (width < 768) {
    $('.sidebar-toggle')[0].click();
  }
  var updateFolderIdArray =  $(".sidebar-menu").sortable("toArray").join(",");
  var sortURL = $("#folder-sort-button").attr("href") + updateFolderIdArray;
  $("#folder-sort-button").attr("href", sortURL);
  $("#folder-sort-modal").modal();
});

// リンクソートボタン押下時の挙動
$("#mock-link-sort-button").click(function(){
  var updateLinkIdArray =  $(".link-box-area").sortable("toArray").join(",");
  var sortURL = $("#link-sort-button").attr("href") + updateLinkIdArray;
  $("#link-sort-button").attr("href", sortURL);
  $("#link-sort-modal").modal();
});

function toggleDetailArea(){
  $(".detail-area").toggleClass('active');
  // キャレットの向きを変更する
  if($(".detail-toggle-icon").hasClass('fa-caret-up')){
    $(".detail-toggle-icon").removeClass('fa-caret-up');
    $(".detail-toggle-icon").addClass('fa-caret-down');
  } else {
    $(".detail-toggle-icon").removeClass('fa-caret-down');
    $(".detail-toggle-icon").addClass('fa-caret-up');
  }
}

// 詳細エリアにデータをセット
function setDetailArea(title, title_sub, note, skin_color) {
  // 一度すべての内容をクリア
  $(".detail-area-title").text("");
  $(".detail-area-note").text("");
  $(".detail-area-sub-title").text("");
  $(".detail-area").removeClass(function(index, className) {
    return (className.match(/\bdetail-area-skin-\S+/g) || []).join(' ');
  })
  $(".detail-area-title").text(title);
  $(".detail-area-sub-title").text(title_sub);
  $(".detail-area-note").html(antiXSS(note));
  $(".detail-area").addClass("detail-area-skin-" + skin_color);
}