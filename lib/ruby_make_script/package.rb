
$system_to_pack = Hash[
    "Ubuntu" => "apk",
    "Darwin" => "brew"
]
$pack = Hash[]

$pack['apt'] = Hash[
    "uninstall" => "remove"
]

$pack['brew'] = Hash[
    "remove" => "uninstall"
]

def PACK(cmd, *args)
    cmd = String(cmd)
    if `uname -a`['Ubuntu']
    $system_to_pack
end

