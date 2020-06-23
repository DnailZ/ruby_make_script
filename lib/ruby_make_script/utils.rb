

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
        puts Pastel.new.red.bold("error> ") + "command error: cd " + str + " (suppressed)"
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

# no error
def r?(*str)
    str =  str.join(" ")
    puts Pastel.new.green("running> ") + str
    flag = system(str) 
    if !flag
        puts Pastel.new.red.bold("error> ") + "command error: " + str + " (suppressed)"
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
