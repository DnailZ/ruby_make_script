$apt_pack = Hash["uninstall" => "remove"]
$brew_pack = Hash["remove" => "uninstall"]

def PACK(cmd, *args)
    cmd = String(cmd)
    if `uname -a`['Ubuntu']
        if $apt_pack[cmd]
            cmd = $apt_pack[cmd]
        end
        r "sudo", "apt", cmd, *args.map{|s| String(s)}
    elsif `uname -a`['Darwin']
        r "brew", cmd, *args.map{|s| String(s)}
    end
end

