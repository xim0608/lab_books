// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', function () {
    $('.card-link').click(function () {
        location.href = jQuery(this).attr('data-url');
    });

    $('.modal').modal();

    $('#preview_type').change(function () {
        let val = $(this).val();
        $.ajax({
            type: 'post',
            url: '/books/change_show_type',
            data: {show_type: val},
            dataType: 'json',
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

    $('#preview_num').change(function () {
        let val = $(this).val();
        $.ajax({
            type: 'post',
            url: '/books/change_show_num',
            data: {show_num: val},
            dataType: 'json',
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

    $('.favorite-btn').click(function () {
        $.post({
            url: `/books/${$(this).attr("book_id")}/add`
        });
        if ($books_id.includes(parseInt($(this).attr('book_id')))) {
            // 白抜きにする
            $(this).html("<a href='#add_modal'><i class='material-icons md-dark md-inactive'>star_border</i></a>");
            var i;
            for (i = 0; i < $books_id.length; i++) {
                if ($books_id[i] === parseInt($(this).attr("book_id"))) {
                    $books_id.splice(i--, 1);
                }
            }
        } else {
            // 色付きにする
            $(this).html("<a href='#delete_modal'><i class='material-icons'>star</i></a>");
            $books_id.push(parseInt($(this).attr('book_id')));
        }
    });
});
