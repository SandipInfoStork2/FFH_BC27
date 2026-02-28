function Init() {
    var uuid = require('uuid');
    var moment = require("moment");

    var AppId = pm.environment.get("APPID");
    var APIKey = pm.environment.get("APIKEY");
    var requestURI = encodeURIComponent(pm.environment.values.substitute(pm.request.url, null, false).toString()).toLowerCase();
    //requestURI = requestURI.replace("https", "http");
    var requestMethod = pm.request.method;
    var requestTimeStamp = moment(new Date().toUTCString()).valueOf();
    var nonce = uuid.v4();
    var requestContentBase64String = "";

    if (pm.request.body != "") {
        var md5 = CryptoJS.MD5(pm.request.body.toString());
        requestContentBase64String = CryptoJS.enc.Base64.stringify(md5);
    }

    var signatureRawData = AppId + requestMethod + requestURI + requestTimeStamp + nonce + requestContentBase64String; //check
    var secretByteArray = CryptoJS.enc.Base64.parse(APIKey);
    var signature = CryptoJS.enc.Utf8.parse(signatureRawData);
    var signatureBytes = CryptoJS.HmacSHA256(signature, secretByteArray);
    var requestSignatureBase64String = CryptoJS.enc.Base64.stringify(signatureBytes);

    var hmacKey = "hmacauth " + AppId + ":" + requestSignatureBase64String + ":" + nonce + ":" + requestTimeStamp;
    pm.environment.set("hmacKey", hmacKey);

}