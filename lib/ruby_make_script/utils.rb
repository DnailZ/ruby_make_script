

# since ~ "cd <path>" invalid, add a function here
def cd(str)
    Dir.chdir(str)
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
        Dir.chdir(str)
    rescue => exception
        puts Pastel.new.red.bold("error> ") + "command error: cd " + str
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
        puts Pastel.new.red.bold("error> ") + "command error: " + str
    end
    flag
end
