[config]
url = ${url}
access_token =  ${access_token}

[challenges]
%{ for chall in challz ~}
${chall} = ${challz_folder}/${chall}
%{ endfor ~}