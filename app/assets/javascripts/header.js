$(document).on("turbolinks:load", function (e) {
    $("#search-toggle").click(function () {
        $("#search").toggle("slow");
        if ($("#search").css("display") === "block") {
            $("input:visible").eq(0).focus();
        }
    });
});
