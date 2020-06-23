class Target

    def depend_each
        
    end
end

class FileTarget

    attr_accessor :target
    attr_accessor :depend
    attr_accessor :update_proc
    attr_accessor :completed
    def resolve_all
        @target.each{ |f|
            resolve(f)
        }
    end
    def depend_modified?
        return @depend.map{ |f| file_modified?(file) }.reduce(false, :or)
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
    def set_depend(*dependlist)
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
    attr_accessor :depend
    attr_accessor :target
    attr_accessor :update_proc
    attr_accessor :completed
    def resolve_all
        resolve(@target)
    end
    def depend_modified?
        @depend.map{ |f| file_modified?(file) }.reduce(false, :or)
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