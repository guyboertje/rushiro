module Rushiro
  class Permission
    attr_reader :parts, :original, :size

    WildCard = :*

    def initialize(permission)
      raise ArgumentError.new("Invalid permission, empty string") if permission.empty?
      @original = permission
      @parts = permission.split(GSEP).map {|part| part.split(FSEP).map(&:to_sym)}
      @size = @parts.size
    end

    def implied?(perm)
      if perm.include?(FSEP)
        msg = "Field separator: #{FSEP} used in input. Be specific, one of domain, action or instance per section."
        raise ArgumentError.new(msg)
      end
      array = perm.split(GSEP).map(&:to_sym)
      array.each_with_index do |part_sym, idx|
        # If the permission has less parts than the permission being tested, everything after the number
        # of parts contained in this permission is automatically implied, so return true
        break if @size.pred < idx
        return false if (@parts[idx] & [WildCard, part_sym]).empty?
      end
      true
    end

    def ==(other)
      return false unless @size == other.size
      @parts.each_with_index do |part, idx|
        return false unless (part - other.parts[idx]).empty?
      end
      true
    end

    def serialize
      @parts.map { |part| part.map(&:to_s).join(FSEP) }.join(GSEP)
    end
  end
end
