require "test_helper"

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        r "pwd"
        r "ls"
    end

    def make_file1
        make do
            :run .from "a.out" do
                r "./a.out"
            end
            "a.out" .from "test.c" do
                r "gcc test.c"
            end
        end
    end

    def CC(*str)
        r "gcc", "-I.", *str
    end

    def make_file2
        sources = Dir.glob("**/*.c")
        headers = Dir.glob("**/*.c")

        make do
            :app .from "prog" do
                r $d[0]
            end
            "prog" .from *sources, *headers do
                
            end
        end
    end
    
    def check_file(*files)
        files.each{ |f|
            raise "no #{each} output" unless system('ls #{f}')
        }
        nil
    end

    def test_make
        cd "./test/test_project1"
        rm ".make_script.yaml"
        rm "a.out"

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
