#
# Usage:
# ```
# require "ruby_make_script"
# make do
#     :run .from "a.out" do
#         ~ "./a.out"
#     end
#     "a.out" .from "test.c" do
#         ~ "gcc test.c"
#     end
# end
# ````
#
#
#

require 'pastel'
require 'yaml'

# all targets list
$targetlist = []      

# file -> target
$file_target_dict = Hash[]   

# file -> mtime (last make)
$file_time_dict = Hash[]   

# file -> mtime  
$cur_file_time_dict = Hash[] 

require 'ruby_make_script/utils'
require 'ruby_make_script/target'

# check a file (recursively) and run the commands of the target.
def resolve(file)
    puts "resolving #{file}"
    if file_modified?(file)
        t = $file_target_dict[file]
        if t != nil # t == nil 时 file 是其他文件
            p :t , t
            t.depend_each { |f|
            resolve(f)
        }
        t.run()
    end
end
end

# check if a file is modified or its dependency is modified
def file_modified?(file)
    if $file_target_dict[file].class == FileTarget
        # 文件真正被修改：文件之前不存在，或文件现在已经不存在，或时间戳修改
        real_modified = $file_time_dict[file] || !File.exist?(file) || $file_time_dict[file] != File.mtime(file)
        # 文件依赖被修改
        return real_modified || $file_target_dict[file].depend_modified?
    elsif $file_target_dict[file].class == PhonyTarget
        # 假目标被修改：依赖被修改或之前不存在
        return $file_time_dict[file] == nil || $file_target_dict[file].depend_modified?
    elsif $file_target_dict[file] == nil
        # 对无目标的文件，判断其存在，存在则直接使用即可
        if !File.exist?(file)
            throw "file not found #{file}"
        else
            $cur_file_time_dict[file] = File.mtime(file)
            return $file_time_dict[file] == nil || $file_time_dict[file] != File.mtime(file)
        end 
    else
        throw "file type error #{$file_target_dict[file].class}"
    end
end

# mark a file is modified
def file_modified!(file)
    if $file_target_dict[file].class == FileTarget
        $cur_file_time_dict[file] = File.mtime(file)
    elsif $file_target_dict[file].class == PhonyTarget
        $cur_file_time_dict[file] = true
    else
        throw "file type error #{file.class}"
    end
end


class Symbol
    # Usage:
    # 
    # ```
    # :app .from "file1" do
    #   <your command here>
    # end
    # ```
    def from(*dependlist)
        PhonyTarget.new(String(self)).from(*dependlist) { yield }
    end
end

class String
    # Usage:
    # 
    # ```
    # "file1" .from "file2" do
    #   <your command here>
    # end
    # ```
    def from(*dependlist)
        [self].from(*dependlist) { yield }
    end
end

class Array
    # Usage:
    # 
    # ```
    # ["file1", "file2"] .from "file3", "file4" do
    #   <your command here>
    # end
    # ```
    def from(*dependlist)
        tar = FileTarget.new(self)
        tar.from(*dependlist) { yield }
    end
end


# Usage:
# 
# ```
# make do
#   <define target here>
# end
# ```
def make
    $targetlist = []
    
    yield

    throw "at least a target" if $targetlist.length < 1
    
    if File.exist?('./.make_script.yaml')
        $file_time_dict = YAML.load(File.read('./.make_script.yaml'))
    end

    begin
        throw "asdf"
        if ARGV.length <= 1
            $targetlist[0].resolve_all
        else
            resolve(ARGV[1])
        end

    rescue String => e
        puts Pastel.new.red.bold("ruby_make_script failed> ") + e
    end

    File.open('./.make_script.yaml', 'w') { |f| f.write(YAML.dump($cur_file_time_dict)) }
end