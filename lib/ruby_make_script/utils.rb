

# since ~ "cd <path>" invalid, add a function here
def cd(str)
    Dir.chdir(str)
end

# these were like cd function
def rm(*str)
    sh"rm #{str.join(' ')}"
end

# these were like cd function
def mkdir(*str)
    sh"mkdir #{str.join(' ')}"
end

def sh(*str)
    puts Pastel.new.green("running> ") + self
    if !system(self) 
        puts Pastel.new.red.bold("error> ") + "command error: " + self
        throw "make command failed"
    end
end
