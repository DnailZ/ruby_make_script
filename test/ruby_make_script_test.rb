require "test_helper"

def make_file
    make do
        :run .from "test.c" {
            ~ "echo run"
        }
        "test.c" .from "test2.c" {
            ~ "echo test.c"
        }
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
