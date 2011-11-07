module Rushiro
  class AccessLevels
    attr_reader :individual, :organization, :musicglue
    def initialize(hash)
      @individual = Permissions.new(hash[:individual] || [])
      @organization = Permissions.new(hash[:organization] || [])
      @system = Permissions.new(hash[:system] || [])
    end

    def permitted?(perm)
      @system.permitted?(perm) || @organization.permitted?(perm) || @individual.permitted?(perm)
    end

    def add_permission(perm)
      level, rest = perm.split(GSEP, 2)
      case level
      when 'individual'
        @individual.add_permission(rest)
      when 'organization'
        @organization.add_permission(rest)
      when 'system'
        @system.add_permission(rest)
      else
        raise ArgumentError.new("Could not add permission for level: #{level} of #{level}#{GSEP}#{perm}")
      end
    end

    def remove_permission(perm)
      level, rest = perm.split(GSEP, 2)
      case level
      when 'individual'
        @individual.remove_permission(rest)
      when 'organization'
        @organization.remove_permission(rest)
      when 'system'
        @system.remove_permission(rest)
      else
        raise ArgumentError.new("Could not remove permission for level: #{level} of #{level}#{GSEP}#{rest}")
      end
    end
    def serialize
      Hash[:individual, @individual.serialize, :organization, @organization.serialize, :system, @system.serialize]
    end
  end
end
