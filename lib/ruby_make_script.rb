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

if !system('gem list | grep pastel > /dev/null') 
    puts "pastel not install automaticly, please 'gem install pastel'"
end

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
def resolve(file, force_exec=false)
    if force_exec || file_modified?(file)
        t = $file_target_dict[file]
        # when t == nil, its a file not used for target
        if t != nil 
            t.depend_each { |f|
                resolve(f)
            }
            t.run()
            # if File.exist?(file) 
            #     puts "#{file} modified #{$file_time_dict[file]} != #{File.mtime(file)}"
            # else
            #     puts "#{file} modified not exist?"
            # end
            file_modified!(file)
        end
    end 
end

# check if a file is modified or its dependency is modified
def file_modified?(file)
    if $file_target_dict[file].class == FileTarget
        # 文件真正被修改：文件之前不存在，或文件现在已经不存在，或时间戳修改
        real_modified = $file_time_dict[file] == nil || !File.exist?(file) || ($file_time_dict[file] != File.mtime(file))
        # 文件依赖被修改
        return real_modified || $file_target_dict[file].depend_modified?
    elsif $file_target_dict[file].class == PhonyTarget
        # 假目标被修改：依赖被修改或之前不存在
        return $file_time_dict[file] == nil || $file_target_dict[file].depend_modified?
    elsif $file_target_dict[file] == nil
        # 对无目标的文件，判断其存在，存在则直接使用即可
        if !File.exist?(file)
            raise "file not found #{file}"
        else
            $cur_file_time_dict[file] = File.mtime(file)
            return $file_time_dict[file] == nil || ($file_time_dict[file] != File.mtime(file))
        end 
    else
        raise "file type error #{$file_target_dict[file].class}"
    end
end

# mark a file is modified
def file_modified!(file)
    if $file_target_dict[file].class == FileTarget
        $cur_file_time_dict[file] = File.mtime(file)
    elsif $file_target_dict[file].class == PhonyTarget
        $cur_file_time_dict[file] = true
    else
        raise "file type error #{file.class}"
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

    # Usage:
    # 
    # ```
    # :app .then do
    #   <your command here>
    # end
    # ```
    def then
        PhonyTarget.new(String(self)).from() { yield }
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

    raise "at least a target" if $targetlist.length < 1
    
    if File.exist?('./.make_script.yaml')
        $file_time_dict = YAML.load(File.read('./.make_script.yaml'))
        $cur_file_time_dict = $file_time_dict.clone()
    end
    puts Pastel.new.bright_cyan("make> ") + "start"
    
    begin
        if ARGV.length == 0
            $targetlist[0].resolve_all
        else
            resolve(ARGV[0], true)
        end

    rescue StandardError => e
        puts Pastel.new.red.bold("make failed> ") + e.message
        if e.message != "make command failed"
            puts e.backtrace
        end
    else
        puts Pastel.new.bright_cyan("make> ") + "completed"
    end

    File.open('./.make_script.yaml', 'w') { |f| f.write(YAML.dump($cur_file_time_dict)) }
end
