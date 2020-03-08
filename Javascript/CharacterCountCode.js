
        //-------------------------------------------------------+
        // CHARACTER COUNTER CODE
        //DHTML textbox character counter script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
        //-------------------------------------------------------+
        var bName = navigator.appName;

        function taLimit(taObj, maxLength) {
            if (taObj.value.length === maxLength) return false;
            return true;
        }

        function taCount(taObj, cnt, maxLength) {
            var objCnt = createObject(cnt);
            var objVal = taObj.value;
            if (objVal.length > maxLength) objVal = objVal.substring(0, maxLength);
            if (objCnt) {
                if (bName === "Netscape") {
                    objCnt.textContent = maxLength - objVal.length;
                }
                else { objCnt.innerText = maxLength - objVal.length; }
            }
            return true;
        }


        function createObject(objId) {
            if (document.getElementById) return document.getElementById(objId);
            else if (document.layers) return eval("document." + objId);
            else if (document.all) return eval("document.all." + objId);
            else return eval("document." + objId);
        }
        //-------------------------------------------------------+