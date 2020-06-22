require "test_helper"

def make_file
    make do
        :run .from "a.out" do
            ~"./a.out"
        end
        "a.out" .from "test.c" do
            ~"gcc test.c"
        end
    end
end

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        ~ "pwd"
        ~ "ls"
    end
    def test_make
        cd "./test/test_project"
        make_file
    end
end
