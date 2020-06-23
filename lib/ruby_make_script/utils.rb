

# since ~ "cd <path>" invalid, add a function here
def cd(str)
    if block_given?
        orig = Dir.pwd
        Dir.chdir(str)
        yield
        Dir.chdir(orig)
    else
        Dir.chdir(str)
    end
end

# these were like cd function
def rm(*str)
    r"rm #{str.join(' ')}"
end

# these were like cd function
def mkdir(*str)
    r"mkdir #{str.join(' ')}"
end
# these were like cd function
def mv(*str)
    r"mv #{str.join(' ')}"
end

# these were like cd function
def cp(*str)
    r"cp #{str.join(' ')}"
end

def r(*str)
    str =  str.join(" ")
    puts Pastel.new.green("running> ") + str
    if !system(str) 
        puts Pastel.new.red.bold("error> ") + "command error: " + str
        raise "make command failed"
    end
end

# since ~ "cd <path>" invalid, add a function here
def cd?(str)
    begin
        if block_given?
            orig = Dir.pwd
            Dir.chdir(str)
            yield
            Dir.chdir(orig)
        else
            Dir.chdir(str)
        end
    rescue => exception
        puts Pastel.new.yellow("warning> ") + "command error: cd " + str + " (suppressed)"
        return false
    end
    return true
end

# these were like cd function
def rm?(*str)
    r?"rm #{str.join(' ')}"
end

# these were like cd function
def mkdir?(*str)
    r?"mkdir #{str.join(' ')}"
end

# these were like cd function
def mv?(*str)
    r?"mv #{str.join(' ')}"
end

# these were like cd function
def cp?(*str)
    r?"cp #{str.join(' ')}"
end

# no error
def r?(*str)
    str =  str.join(" ")
    puts Pastel.new.green("running> ") + str
    flag = system(str) 
    if !flag
        puts Pastel.new.yellow("warning> ") + "command error: " + str + " (suppressed)"
    end
    flag
end

def runfile(file, *args)
    path = File.expand_path(file)
    r path, *args
end
def runfile?(file, *args)
    path = File.expand_path(file)
    r? path, *args
end

def in_env(expr, enable=true)
    k, v = expr.split('=')
    v0 = ENV[k]
    ENV[k] = v
    yield
    ENV[k] = v0
end

def using 