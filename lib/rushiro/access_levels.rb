module Rushiro
  class AccessLevels
    attr_reader :individual, :organisation, :musicglue
    def initialize(hash)
      @individual = Permissions.new(hash[:individual] || [])
      @organisation = Permissions.new(hash[:organisation] || [])
      @system = Permissions.new(hash[:system] || [])
    end

    def permitted?(perm)
      @system.permitted?(perm) || @organisation.permitted?(perm) || @individual.permitted?(perm)
    end

    def add_permission(perm)
      level, rest = perm.split(GSEP, 2)
      case level
      when 'individual'
        @individual.add_permission(rest)
      when 'organisation'
        @organisation.add_permission(rest)
      when 'system'
        @system.add_permission(rest)
      else
        raise ArgumentError.new("Could not add permission for level: #{level} of #{level}#{SEP}#{perm}")
      end
    end

    def remove_permission(perm)
      level, rest = perm.split(GSEP, 2)
      case level
      when 'individual'
        @individual.remove_permission(rest)
      when 'organisation'
        @organisation.remove_permission(rest)
      when 'system'
        @system.remove_permission(rest)
      else
        raise ArgumentError.new("Could not remove permission for level: #{level} of #{level}#{SEP}#{rest}")
      end
    end
    def serialize
      Hash[:individual, @individual.serialize, :organisation, @organisation.serialize, :system, @system.serialize]
    end
  end
end
