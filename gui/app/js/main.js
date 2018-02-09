function initLogin() {

var usrnm = $('#first-name').val();
var pswd = $('#farmpass').val();
if (usrnm == "admin" && pswd == "pass"){
    window.location.href = 'seloption.html';
} else {
    alert("Wrong Username / Password !!");
}

}