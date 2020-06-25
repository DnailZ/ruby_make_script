require "ruby_make_script"

make do
    descr! "setup the environment"
    arg! "<args...>", "command to run"
    :setup.from do
        r "echo", "Hello", "World"
    end
end

dump_md('make.md'){}