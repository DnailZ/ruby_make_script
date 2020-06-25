$t = []
$d = []

require "ruby_make_script/doc"

module Target
    
    def depend_each
        depend.each { |f|
            yield f
        }
    end

    def depend_modified?
        return depend.map{ |f| file_modified?(f) }.reduce(false, :|)
    end

    def resolve_all
        raise nil
    end

    def run
        raise nil
    end

    def from(*dependlist)
        raise nil
    end

    def add
        raise nil
    end
end

class FileTarget
    include Target
    attr_accessor :depend

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
        @update_proc = Proc.new { 
            $t = @target
            $d = @depend
            yield
        }
        add()
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
    attr_accessor :target
    attr_accessor :depend
    attr_accessor :doc
    def resolve_all
        resolve(@target)
    end

    def run
        if ! @completed
            @update_proc.call
            @completed = true
            file_modified!(@target)
        end
    end
    def initialize(str)
        @target = str
        @depend = []
        @completed = false

        @doc = $targetdoc
        $targetdoc = TargetDoc.new
    end

    def from(*dependlist)
        @depend = dependlist
        @update_proc = Proc.new { 
            $t = @target
            $d = @depend
            yield
        }
        add()
    end
    def add
        $targetlist += [self]
        $file_target_dict[@target] = self
    end
end