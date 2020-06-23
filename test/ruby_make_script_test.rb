require "test_helper"

class RubyMakeScriptTest < Minitest::Test
    def test_cmd
        r "pwd"
        r "ls"
    end

    def make_file
        fork {
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

    def check_modified(*input)
        even = [false, true].cycle
        odd = [true, false].cycle

        files = input.select{odd.next}
        modified? = input.select{even.next}

        mtime = files.map{ |f| File.mtime(f) }

        yield

        files.zip(mtime).zip(modified?).each { |f, mtime, m?|
            if m? == 'modified'
                raise "#{f} unmodified" unless mtime != File.mtime(f)
            elsif m? == 'unmodified'
                raise "#{f} modified" unless mtime == File.mtime(f)
            end
        }
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
            check_modified('a.out', 'modified') do
                make_file
            end
        end
    end

    def test_make2
        cd "./test/test_project2" do
            rm? "-r .build"
            rm? "-r .make_script.yaml"
            rm? "-r prog"
            make_file
            check_file("prog", "build/a.o")

            check_modified(
                'prog', 'unmodified'
                '.build/a.o', 'unmodified'
            ) { make_file }

            run "echo ' ' >> a.c"
            check_modified(
                'prog', 'modified',
                '.build/a.o', 'modified',
                '.build/b.o', 'unmodified'
            ) { make_file }

            rm 'prog'
            check_modified(
                'prog', 'modified',
                '.build/a.o', 'unmodified',
                '.build/b.o', 'unmodified'
            ) { make_file }
        end
    end
end
