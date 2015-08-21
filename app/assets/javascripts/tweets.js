var ready = function() {
    if($(".tweets.index")[0]) {
        $(".btn-play").click(function() {
            $(this).toggleClass("btn-success");
            $(this).toggleClass("btn-danger");
            $(this).text("Already played")
        });
    }
};

$(document).ready(ready);
$(document).on('page:load', ready);