function commentcava(proposal) {
	let b64Proposal = btoa(proposal);
	let result = "";
	for (var i = 0; i < b64Proposal.length; i++) {
		result += String.fromCharCode(b64Proposal.charCodeAt(i) + (i%4));
	}
	return result;
}

function salutatous(msg) {
	return "";
}

function checkCreds() {
	let n = document.querySelectorAll("#👍")[0];
	if ((salutatous(commentcava(leszouzous)) + commentcava(leszouzous.value) === superettoi.value) && ((1,2,3,4,5,6) === (2,4,6))) {
		alert("GG WP Tu peux valider le chall");
	} else {
		alert("Au gogol");
	}

