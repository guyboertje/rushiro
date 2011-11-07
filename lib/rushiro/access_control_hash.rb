module Rushiro
  GSEP = '|'
  FSEP = ','
  class AccessControlHash
    attr_reader :allows, :denies, :original, :dirty
    def initialize(hash)
      @allows = AccessLevels.new(hash[:allows] || hash[:allow] || {})
      @denies = AccessLevels.new(hash[:denies] || hash[:deny] || {})
      @name = hash.fetch(:name, 'Root')
      @dirty = false
      @original = hash
      @subordinates = []
    end

    def permitted?(perm)
      # virtual, define in subclass
    end
    
    def pristine?
      @subordinates.empty? && !@dirty && @original.empty?
    end

    def subordinates_permitted?(perm)
      return false if @subordinates.empty?
      @subordinates.each do |sub|
        return true if sub.permitted?(perm)
      end
      false
    end

    def add_subordinate(sub)
      @subordinates << sub
    end

    def add_permission(perm) #as string "allow|individual|domain(|action(|instance))"
      grant, rest = perm.split(GSEP, 2)
      case grant
      when 'allows', 'allow'
        @allows.add_permission(rest) and @dirty = true
      when 'denies', 'deny'
        @denies.add_permission(rest) and @dirty = true
      else
        raise ArgumentError.new("Could not add permission for: #{grant}, use allows,allow,denies or deny")
      end
    end

    def remove_permission(perm) #as string "allow|individual|domain(|action(|instance))"
      grant, rest = perm.split(GSEP, 2)
      case grant
      when 'allows', 'allow'
        @allows.remove_permission(rest) and @dirty = true
      when 'denies', 'deny'
        @denies.remove_permission(rest) and @dirty = true
      else
        raise ArgumentError.new("Could not remove permission for type: #{grant}, use allows,allow,denies or deny")
      end
    end

    def serialize
      unless @dirty
        @original
      else
        Hash[:name, @name, :allows, @allows.serialize, :denies, @denies.serialize]
      end
    end

    def no_longer_dirty
      @dirty = false
    end
  end

end
