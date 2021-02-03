<?php

function filtrage($in)
{
    $in = trim($in);
    $in = htmlspecialchars($in);
    $in = preg_replace("/[*\/\\$\-]+/", "", $in);

    $bad = array("phpinfo", "exec", "shell", "system", "eval");
    $good = array("");
    $in = str_replace($bad, $good, $in);

    return $in;
}
