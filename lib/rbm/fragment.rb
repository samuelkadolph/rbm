module RBM
  class Fragment
    @@unnamed_fragment = "fragment_0"

    attr_reader :code, :name, :prerun, :postrun

    def initialize(code, name = nil, prerun = nil, postrun = nil)
      @code, @name, @prerun, @postrun = code, name, prerun, postrun
    end

    def run(bm, times, init = nil, cleanup = nil)
      fragment_name = (name || @@unnamed_fragment.succ!).gsub(/\s+/, "_")
      object = Object.new

      bm.report(name) do
        object.instance_eval(init, "#{fragment_name}_init", 0) if init
        object.instance_eval(prerun, "#{fragment_name}_prerun", 0) if prerun
        object.instance_eval("#{times}.times { #{code} }", "#{fragment_name}", 0)
        object.instance_eval(postrun, "#{fragment_name}_postrun", 0) if postrun
        object.instance_eval(cleanup, "#{fragment_name}_cleanup", 0) if cleanup
      end
    end
  end
end
