
class TargetDoc
    def initialize()
        @arglist = []
        @descr = ""
    end

    def add_arg(name, doc)
        @arglist += [[name, doc]]
    end

    def descr(str)
        @descr += str + "\n"
    end
end

$targetdoc = TargetDoc.new