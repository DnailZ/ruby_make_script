require "ruby_make_script"

make do
    descr! "setup the environment"
    arg! "<args...>", "command to run"
    :setup.from do
        use envir("RUST_LOG=trace"), dir('test') do
            r "env"
            r "pwd"
        end
    end
end

dump_md('make.md'){}