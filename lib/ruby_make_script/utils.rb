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
        Dir.chdir(str)
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

class InDir
    def initialize(path, err=true)
        @path = path
        @err = err
    end

    def enter
        @orig = Dir.pwd
        if @err
            cd @path
        else
            cd? @path
        end
    end

    def exit
        if @err
            cd @orig
        else
            cd? @orig
        end
    end
end

def dir(path)
    InDir.new(path)
end

def dir?(path)
    InDir.new(path, false)
end

class InEnv
    def initialize(expr)
        @k, @v = expr.split('=')
    end

    def enter
        @v0 = ENV[k]
        ENV[k] = @v
    end

    def exit
        ENV[k] = @v0
    end
end

def envir(expr)
    InEnv.new(expr)
end

def using(*operation)
    operation.each{ |o| o.enter}
    yield
    operation.each{ |o| o.exit}
end

def GIT(*args)
    r "git", *args.map{|s| String(s)}
end

def DOCKER(*args)
    r "docker", *args.map{|s| String(s)}
end

require 'ruby_make_script/package'