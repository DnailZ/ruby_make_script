require "ruby_make_script"

make do
    descr! "run the application"
    arg! "<args...>", "command to run"
    :run .from "a.out" do
        r "./a.out"
    end
    "a.out" .from "test.c" do
        r "gcc test.c"
    end
end

dump_md('make_usage.md')


