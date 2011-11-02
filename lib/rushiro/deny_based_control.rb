module Rushiro
  class DenyBasedControl < AccessControlHash
    def permitted?(perm)
      return true if !@dirty && @original.empty?
      return false if @denies.permitted?(perm)
      true
    end
  end
end
