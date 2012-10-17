module Rushiro
  class DenyBasedControl < AccessControlHash
    def permitted?(perm)
      return true if pristine?
      return false if @denies.permitted?(perm)
      subordinates_permitted?(perm)
    end

    def subordinates_permitted?(perm)
      return true if @subordinates.empty?
      @subordinates.each do |sub|
        return false if !sub.permitted?(perm)
      end
      true
    end
  end
end
