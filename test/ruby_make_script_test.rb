require "test_helper"

def make_file
    make do
        :run .from("test.c") do
            ~ "echo run"
        end
        "test.c" .from "test2.c" do
            ~ "echo test.c"
        end
    end
end

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        ~ "pwd"
        ~ "ls"
    end
    def test_make
        ~ "cd ./test/test_project"
        make_file
        
    end
end
