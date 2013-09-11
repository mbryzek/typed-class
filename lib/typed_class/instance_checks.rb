module TypedClassInternal

  # Here to facilitate better error messages
  module InstanceChecks

    def InstanceChecks.opts_must_be_a_hash(opts)
      if !opts.is_a?(Hash)
        raise "Expected a hash of name/value pairs but got an argument of type[%s]" % opts.class.name
      end
    end

  end

end
