require "test_helper"

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        r "pwd"
        r "ls"
    end

    def make_file
        require "./make.rb"
    end

    def CC(*str)
        r "gcc", "-I.", *str
    end
    
    def check_file(*files)
        files.each{ |f|
            raise "no #{each} output" unless system('ls #{f}')
        }
        nil
    end

    def test_make
        cd "./test/test_project1" do
            rm? ".make_script.yaml"
            rm? "a.out"

            make_file
            check_file("a.out", ".make_script.yaml")

            rm "-r ./a.out"
            make_file
            check_file("a.out", ".make_script.yaml")

            r "echo '   ' >> test.c"
            mtime = File.mtime('a.out')
            make_file
            raise "a.out not modified" unless mtime != File.mtime('a.out')
        end
    end

    def test_make2
        cd "./test/test_project2" do
            rm? "-r .build"
            rm? "-r .make_script.yaml"
            rm? "-r prog"
            make_file
            check_file("prog", "build/a.o")
        end
    end
end
