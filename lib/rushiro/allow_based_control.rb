module Rushiro
  class AllowBasedControl < AccessControlHash
    def permitted?(perm)
      return false if pristine?
      return true if @allows.permitted?(perm)
      subordinates_permitted?(perm)
    end

    def subordinates_permitted?(perm)
      return false if @subordinates.empty?
      @subordinates.each do |sub|
        return true if sub.permitted?(perm)
      end
      false
    end
  end
end
