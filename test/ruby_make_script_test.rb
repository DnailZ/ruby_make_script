require "test_helper"

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        r "pwd"
        r "ls"
    end

    def make_file
        fork{
            require "./make.rb"
        }
        Process.wait
    end
    
    def check_file(*files)
        files.each{ |f|
            raise "no #{each} output" unless system('ls #{f}')
        }
        nil
    end

    def check_modified(*file)
        mtime = files.map{|f| File.mtime(f) }
        yield
        files.zip(mtime).each { |f, mtime|
            raise "#{f} modified"
        }

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

            prog_mtime = File.mtime('prog')
            a_obj_mtime = File.mtime('.build/a.o')
            make_file
            raise "prog modified" unless prog_mtime == File.mtime('prog')
            raise ".build/a.o modified" unless a_obj_mtime == File.mtime('.build/a.o')

            run "echo ' ' >> a.c"
            prog_mtime = File.mtime('prog')
            a_obj_mtime = File.mtime('.build/a.o')
            b_obj_mtime = File.mtime('.build/b.o')
            make_file
            raise ".build/a.o not modified" unless a_obj_mtime == File.mtime('.build/a.o')
            raise ".build/b.o modified" unless b_obj_mtime == File.mtime('.build/b.o')
        end
    end
end
