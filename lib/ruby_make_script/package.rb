
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
    $system_to_pack.each do |k,v|
        if `uname -a`[k]
            
            break
        end
    end
end

