module Rushiro
  class Permissions
    attr_reader :permissions
    def initialize(entries)
      @permissions = entries.map do |permission|
        Permission.new(permission)
      end || []
    end

    def permitted?(perm)
      return nil if @permissions.empty?
      @permissions.any? { |permission| permission.implied?(perm) }
    end

    def add_permission(perm)
      to_add = Permission.new(perm)
      return false if @permissions.any?{|_p| _p == to_add}
      @permissions << to_add
      true
    end

    def remove_permission(perm)
      !!@permissions.delete(Permission.new(perm))
    end

    def serialize
      @permissions.map(&:serialize)
    end
  end
end
