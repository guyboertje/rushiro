module Rushiro
  GSEP = '|'
  FSEP = ','
  class AccessControlHash
    attr_reader :allows, :denies, :original, :dirty, :kind
    def initialize(hash)
      @allows = AccessLevels.new(hash[:allows] || hash[:allow] || {})
      @denies = AccessLevels.new(hash[:denies] || hash[:deny] || {})
      @name = hash.fetch(:name, 'Root')
      @dirty = false
      @original = hash
      @allow_subs = []
      @deny_subs  = []
      @subordinates = []
      @kind = nil
    end

    def subordinates
      @allow_subs + @deny_subs
    end

    def permitted?(perm)
      return denying? if pristine?
      return subordinates_permitted?(perm) unless subordinates.empty?
      rules = allowing? ? @allows : @denies
      rules.permitted?(perm) ? allowing? : denying?
    end

    def pristine?
      !@dirty && @original.empty?
    end

    def subordinates_permitted?(perm)
      return denying? if subordinates.empty?
      @deny_subs.each do |sub|
        return false if sub.permitted?(perm)
      end
      @allow_subs.each do |sub|
        return true if sub.permitted?(perm)
      end
      denying?
    end

    def denying?
      :deny == kind
    end

    def allowing?
      :allow == kind
    end

    def add_subordinate(sub)
      @allow_subs << sub if sub.allowing?
      @deny_subs << sub if sub.denying?
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
