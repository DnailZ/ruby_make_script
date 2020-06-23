class Target

    def depend_each
        @depend.each {
            yield
        }
    end

    def depend_modified?
        return @depend.map{ |f| file_modified?(f) }.reduce(false, :or)
    end

    def resolve_all
        throw nil
    end

    def run
        throw nil
    end

    def from(*dependlist)
        throw nil
    end

    def add
        throw nil
    end
end

class FileTarget
    include Target

    def resolve_all
        @target.each{ |f|
            resolve(f)
        }
    end
    def run
        if ! @completed
            @update_proc.call
            @completed = true
            @target.each{ |f|
                file_modified!(f)
            }
        end
    end
    def initialize(targetlist)
       @target = targetlist
       @depend = []
       @completed = false
    end
    def from(*dependlist)
        @depend = dependlist
        @update_proc = Proc.new { yield }
    end
    def add
        $targetlist += [self]
        @target.each { |t|
            $file_target_dict[t] = self
        }
    end
end

class PhonyTarget
    include Target
    def resolve_all
        resolve(@target)
    end

    def run
        if ! @completed
            update_proc.call
            @completed = true
            file_modified!(@target)
        end
    end
    def initialize(str)
        @target = str
        @depend = []
        @completed = false
    end

    def from(*dependlist)
        @depend = dependlist
        @update_proc = Proc.new { yield }
        add()
    end
    def add
        $targetlist += [self]
        $file_target_dict[@target] = self
    end
end