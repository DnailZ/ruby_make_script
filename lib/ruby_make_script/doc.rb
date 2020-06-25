
class TargetDoc
    attr_accessor :arglist
    attr_accessor :descr
    attr_accessor :name

    def initialize()
        @arglist = []
        @descr = ""
        @name = ""
    end
    def set_name(name)
        @name = name
    end

    def add_arg(name, doc)
        @arglist += [[name, doc]]
    end

    def add_descr(str)
        @descr += str + "\n"
    end

    def empty?()
        @arglist == [] || @descr == ""
    end

    def form_str()
        [@name, *@arglist].join(" ")
    end
end

$targetdoc = TargetDoc.new

def descr!(str)
    $targetdoc.add_descr(str)
end

def arg!(name, doc)
    $targetdoc.add_arg(name, doc)
end

