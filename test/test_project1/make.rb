require "ruby_make_script"

make do
    :run .from "a.out" do
        r "./a.out"
    end
    "a.out" .from "test.c" do
        r "gcc test.c"
    end
end