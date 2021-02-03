.:53 {
    log
    errors
    auto
    reload 10s
    rewrite stop {
        name regex (.*)\.interiut\.ctf {1}.${namespace}.svc.cluster.local
        answer name (.*)\.${namespace}\.svc\.cluster\.local {1}.interiut.ctf
    }
    forward . /etc/resolv.conf
}
################################ Comment and Version ################################
# This Corefile will check for changes every 10 seconds
#
# Changes to a hosts file will be detected and reloaded automatically.
#
# Changes to a Zone file will be detected and reloaded automatically
#   if you increment the serial number in the zone definition
#
# Version: 1.0
#
#####################################################################################
