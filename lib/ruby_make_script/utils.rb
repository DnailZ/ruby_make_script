

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
    puts Pastel.new.green("running> ") + self
    if !system(self) 
        puts Pastel.new.red.bold("error> ") + "command error: " + self
        throw "make command failed"
    end
end
