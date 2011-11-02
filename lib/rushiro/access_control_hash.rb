module Rushiro
  GSEP = '|'
  FSEP = ','
  class AccessControlHash
    attr_reader :allows, :denies, :original, :dirty
    def initialize(hash)
      @allows = AccessLevels.new(hash[:allows] || {})
      @denies = AccessLevels.new(hash[:denies] || {})
      @dirty = false
      @original = hash
    end

    def permitted?(perm)
      # virtual
    end

    def add_permission(perm) #as string "allow|individual|domain(|action(|instance))"
      grant, rest = perm.split(GSEP, 2)
      case grant
      when 'allows'
        @allows.add_permission(rest) and @dirty = true
      when 'denies'
        @denies.add_permission(rest) and @dirty = true
      else
        raise ArgumentError.new("Could not add permission for type: #{grant} of #{perm}")
      end
    end

    def remove_permission(perm) #as string "allow|individual|domain(|action(|instance))"
      grant, rest = perm.split(GSEP, 2)
      case grant
      when 'allows'
        @allows.remove_permission(rest) and @dirty = true
      when 'denies'
        @denies.remove_permission(rest) and @dirty = true
      else
        raise ArgumentError.new("Could not remove permission for type: #{grant} of #{perm}")
      end
    end

    def serialize
      unless @dirty
        @original
      else
        Hash[:allows, @allows.serialize, :denies, @denies.serialize]
      end
    end
  end

end
