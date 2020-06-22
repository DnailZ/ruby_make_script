require "test_helper"

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        ~ "pwd"
        ~ "ls"
    end
    def make_file
        make do
            "run".phony < ["test.c"] {
                ~ "echo run"
            }
            ["test.c"] < ["test2.c"] {
                ~ "echo test.c"
            }
        end
    end
    def test_make
        ~ "cd ./test/test_project"

        
    end
end
