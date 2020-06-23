require "ruby_make_script"

mkdir? ".build"
sources = Dir.glob("**/*.c")
objects = sources.map{ |f| ".build/" + f.gsub('.c', '.o')}
headers = Dir.glob("**/*.c")

make do
    :app .from "prog" do
        runfile $d[0]
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