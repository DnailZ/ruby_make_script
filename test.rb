require "ruby_make_script"

make do
    :setup.from do
        r "echo", "Hello", "World"
    end
end