require "test_helper"

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        ~ "pwd"
        ~ "ls"
    end
    def test_make
        ~ "cd ./test/test_project"
        make do
            [""]
        end
    end
end
