module Rushiro
  class DenyBasedControl < AccessControlHash
    def permitted?(perm)
      return true if pristine?
      return false if @denies.permitted?(perm)
      !subordinates_permitted?(perm)
    end
  end
end
