if (controller_rails === "books") {
    $(document).on("turbolinks:load", function (e) {
        e.preventDefault();
        var liked = "<a href='#delete_modal'><i class='material-icons'>star</i></a>"
        var unliked = "<a href='#add_modal'><i class='material-icons md-dark md-inactive'>star_border</i></a>"

        $(".card-link").click(function () {
            location.href = $(this).attr("data-url");
        });

        $(".modal").modal();

        $("#preview_type").change(function () {
            let val = $(this).val();
            $.ajax({
                type: "post",
                url: "/books/change_show_type",
                data: {show_type: val},
                dataType: "json",
            })
                .then(
                    function () {
                        location.reload();
                    },
                    function () {
                        alert("access failed");
                    }
                );
        });

        $("#preview_num").change(function () {
            let val = $(this).val();
            $.ajax({
                type: "post",
                url: "/books/change_show_num",
                data: {show_num: val},
                dataType: "json",
            })
                .then(
                    function () {
                        location.reload();
                    },
                    function () {
                        alert("access failed");
                    }
                );
        });

        $(".favorite-btn").click(function () {
            $.post({
                url: `/books/${$(this).attr("book_id")}/add`
            });
            if ($books_id.includes(parseInt($(this).attr("book_id")))) {
                // 白抜きにする
                $(this).html(unliked);
                var i;
                for (i = 0; i < $books_id.length; i++) {
                    if ($books_id[i] === parseInt($(this).attr("book_id"))) {
                        $books_id.splice(i--, 1);
                    }
                }
            } else {
                // 色付きにする
                $(this).html(liked);
                $books_id.push(parseInt($(this).attr("book_id")));
            }
        });
        if (action_rails === "show") {
            var app = new Vue({
                el: "#recommend",
                data: {recommends: []},
                created: function () {
                    this.$http.get("/books/" + book_id + "/recommends").then(function (response) {
                        for (var i = 0; i < response.body.length; i++) {
                            this.recommends.push(response.body[i]);
                        }
                    }, function () {
                        // error
                    });
                },
                methods: {
                    book_link: function (id) {
                        window.location.href = "/books/" + id;
                    }
                }
            });

            $.ajax({
                url: "/books/show_review?book_id=" + book_id,
                dataType: "json",
                success: function (json) {
                    if (Object.keys(json).indexOf("url") >= 0) {
                        $("#review").html(`<div class="iframe-content"><iframe src="${json["url"]}" frameborder="0" height="500" width="800"></iframe></div>`)
                    } else {
                        $("#review-error").html("<div class='card-panel red lighten-4'><span class='red-text'>レビューの読み込みに失敗しました</span></div>")
                    }
                }
            })
        } else if (action_rails === "index" || action_rails === "show_all") {
            var $books_id = [];
            $.ajax({
                url: "/books/list_favorite",
                dataType: "json",
                success: function (json) {
                    $books_id = json;
                    $(".favorite").each(function () {
                        if ($books_id.includes(parseInt($(this).attr("book_id")))) {
                            $(this).html(liked);
                        }
                    });
                }
            });
        }
    });
}
