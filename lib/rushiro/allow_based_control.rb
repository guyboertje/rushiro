module Rushiro
  class AllowBasedControl < AccessControlHash
    def permitted?(perm)
      return false if pristine?
      return true if @allows.permitted?(perm)
      subordinates_permitted?(perm)
    end
  end
end
