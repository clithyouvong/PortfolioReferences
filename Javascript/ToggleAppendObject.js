function ToggleWaitToLoad2(obj) {
    if (obj.includes('Modal')) {
        $('.modal-footer table').hide();
    }
    if (obj === 'Search') {
        $('#pnlControlsControls').hide();
    }

    ToggleAppendObject2("span[id*=" + obj + "WaitToLoad]");
}


function ToggleAppendObject2(obj) {
    $(obj).html(
        $('<img>',
            {
                src: '<%= ResolveUrl("~/Images/loading_blue.gif") %>',
                alt: '[Please Wait!... Do not refresh or reload the page...]',
                style: 'width: auto;height: 100%;max-height: 25px;'
            })
    );
}

function ToggleContent2(obj) {
    if (confirm("Are you sure you want to delete this? Once deleted, you won't be able to recover it.")) {
        ToggleWaitToLoad2(obj);

        return true;
    } else {
        return false;
    }
}