
class TargetDoc
    def initialize()
        @arglist = []
        @descr = ""
        @name = ""
    end

    def add_arg(name, doc)
        @arglist += [[name, doc]]
    end

    def descr(str)
        @descr += str + "\n"
    end

    def empty?()
        @arglist == [] || @descr == ""
    end

    def form_str()

    end
end

$targetdoc = TargetDoc.new