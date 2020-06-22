
$targetlist = []
$file_target_dict = Hash[]
$file_time_dict = Hash[]
$cur_file_time_dict = Hash[]

class String
    def ~@
        system(self)
    end
end

def resolve(file)     
    if file_modified?(file)
        t = $file_target_dict[file]
        t.depend.each { |f|
            resolve(f)
        }
        
        t.run()
    end
end

def file_modified?(file)
    if $file_target_dict[file].class == FileTarget
        # 文件真正被修改：文件之前不存在，或文件现在已经不存在，或时间戳修改
        real_modified = $file_time_dict[file] or !File.exists(file) or $file_time_dict[file] != File.mtime(file)
        # 文件依赖被修改
        real_modified or $file_target_dict[file].depend_modified?
    elsif $file_target_dict[file].class == PhonyTarget
        # 假目标被修改：依赖被修改或之前不存在
        $file_time_dict[file] == nil or $file_target_dict[file].depend_modified?
    else
        throw "ruby_make_script: Err"
    end
end
def file_modified!(file)
    if $file_target_dict[file].class == FileTarget
        $cur_file_time_dict[file] = File.mtime(file)
    elsif $file_target_dict[file].class == PhonyTarget
        $cur_file_time_dict[file] = true
    else
        throw "ruby_make_script: Err"
    end
end

class FileTarget
    attr_accessor completed
    def depend_modified?
        return @depend.map(|f| file_modified?(file)).reduce(false, :or)
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
    def depend(dependlist)
        @depend = dependlist
    end
    def add()
        $targetlist += [self]
        @target.each { |t|
            $file_target_dict[t] = self
        }
    end
end

class PhonyTarget
    attr_accessor update_proc
    attr_accessor depend
    attr_accessor target
    def depend_modified?
        @depend.map(|f| file_modified?(file)).reduce(false, :or)
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
    end
    def depend(dependlist)
        @depend = dependlist
    end
    def <(dependlist)
        @update_proc = Proc.new {
            yield
        }
        add()
    end
    def add
        $targetlist += [self]
        $file_target_dict[@target] = self
    end
end

def make
    $targetlist = []

    class String
        def phony
            PhonyTarget.new(self)
        end
    end

    class Array
        def <(dependlist)
            tar = FileTarget.new(self).depend(dependlist)
            tar.update_proc = Proc.new{
                yield
            }
            tar.add()
        end
    end
    
    yield

    throw "at least a target" if $targetlist.length < 1
    resolve($targetlist[0])
end

