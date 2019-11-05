/*
  This file is intended to be used as reference
  
  This file was written using Javascript Ecmascript 5 and JQUERY
  
  This file detects wheither the 'object' in question is a Microsoft Edge or Internet Explorer browser.
*/

        function PreventLoading() {
            var obj = $('div[id*=someid]');

            var isBadBrowser = false;
            var reason = '';

            if (document.documentMode) {

                isBadBrowser = true;
                reason = "Internet Explorer";
            }
            else if (/MSIE 9/i.test(navigator.userAgent)) {
                isBadBrowser = true;
                reason = "Internet Explorer 9";
            }
            else if (/MSIE 10/i.test(navigator.userAgent)) {
                isBadBrowser = true;
                reason = "Internet Explorer 10";
            }
            else if (/rv:11.0/i.test(navigator.userAgent)) {
                isBadBrowser = true;
                reason = "Internet Explorer 11";
            }
            else if (/Edge\/\d./i.test(navigator.userAgent)) {
                isBadBrowser = true;
                reason = "Microsoft Edge";
            }

            if (isBadBrowser) {
                alert('This Browser, ' + reason + ', is currently not supported. Please use Google Chrome.');
                $(obj).hide();
            }
        }
