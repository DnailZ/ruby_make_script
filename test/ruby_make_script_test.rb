require "test_helper"

def make_file1
    make do
        :run .from "a.out" do
            ~"./a.out"
        end
        "a.out" .from "test.c" do
            ~"gcc test.c"
        end
    end
end

def check_file(*files)
    files.each{ |f|
        raise "no #{each} output" unless system('ls #{f}')
    }
    nil
end

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        r "pwd"
        r "ls"
    end

    def test_make
        cd "./test/test_project"
        make_file1
        check_file("a.out", ".make_script.yaml")

        rm "-r ./a.out"
        make_file1
        check_file("a.out", ".make_script.yaml")

        r "echo '   ' >> test.c"
        mtime = File.mtime('a.out')
        make_file1
        raise "a.out not modified" unless mtime != File.mtime('a.out')
    end
end
