$(document).on("turbolinks:load", function (e) {
    var alertNode = document.getElementById("alert-panel");
    var noticeNode = document.getElementById("notice-panel");
    if (alertNode != null) {
        wait(3).done(function() {
            alertNode.parentNode.removeChild(alertNode)
        });
    }
    if (noticeNode != null) {
        wait(3).done(function() {
            noticeNode.parentNode.removeChild(noticeNode);
        });
    }
});

function wait(sec) {
    var objDef = new $.Deferred;
    setTimeout(function () {
        objDef.resolve(sec);
    }, sec*1000);
    return objDef.promise();
};