module Rushiro
  class AllowBasedControl < AccessControlHash
    def permitted?(perm)
      return false if !@dirty && @original.empty?
      @allows.permitted?(perm)
    end
  end
end
