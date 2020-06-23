class String
    # execute command
    def ~@
        puts Pastel.new.green("running> ") + self
        if !system(self) 
            puts Pastel.new.red.bold("error> ") + "command error: " + self
            throw "make command failed"
        end
    end
end

# since ~ "cd <path>" invalid, add a function here
def cd(str)
    Dir.chdir(str)
end
