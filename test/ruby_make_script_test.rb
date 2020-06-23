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
        mkdir? ".build"
        sources = Dir.glob("**/*.c")
        objects = sources.map{ |f| ".build/" + f.gsub('.c', '.o')}
        headers = Dir.glob("**/*.c")

        make do
            :app .from "prog" do
                r $d[0]
            end
            "prog" .from *objects do
                CC "-o", $t[0], *$d
            end
            sources.zip(objects).each do |s, o|
                o .from s, *headers do
                    CC "-c", "-o", $t[0], $d[0]
                end
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
        cd "./test/test_project1" do
            rm? ".make_script.yaml"
            rm? "a.out"

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

    def test_make2
        cd "./test/test_project2" do
            make_file2
            check_file("prog", "build/a.o")
        end
    end
end
