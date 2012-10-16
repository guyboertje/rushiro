module Rushiro
  class AllowBasedControl < AccessControlHash
    def initialize hash
      super
      @kind = :allow
    end

    # def permitted?(perm)
    #   return false if pristine?
    #   return true if @allows.permitted?(perm)
    #   subordinates_permitted?(perm)
    # end
  end
end
