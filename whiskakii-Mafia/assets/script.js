const closeKeys = ['Escape'];


window.addEventListener("message", (event) => {
    const action = event.data.action;
    const data = event.data.data;
    if (action === "show") {
        $('body').fadeIn(450);
        $('.selection-Container').fadeIn(500);
        $("#cost").html(data.cost);
        $("#currency").html(data.currency);
    }
    else if (action === "hide") {
        $('body').fadeOut();
        $('.selection-Container').fadeOut();
        $('.confirmationBtn').fadeOut();
    }
});

document.onkeyup = function(event) {
    if (closeKeys.includes(event.key)) {
        $.post(`https://whiskakii-Mafia/closeNUI`, JSON.stringify({}));
    }
};



function creationBtn() {
    $.post(`https://whiskakii-Mafia/onPlayerCreation`, JSON.stringify({
        value: $("#input").val()
    }));
}

