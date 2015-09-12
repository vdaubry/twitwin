var ready = function() {
    if($(".tweets.index")[0]) {
        $(".btn-play.activated").click(function() {
            $(this).toggleClass("btn-success");
            $(this).toggleClass("btn-default");
            $(this).text("Already played")
        });
    }
};

$(document).ready(ready);
$(document).on('page:load', ready);