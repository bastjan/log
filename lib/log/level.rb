module Log::Level
  def level
    @level
  end
  alias :logger_level :level

  def level=(level)
    assure_level(level)
    @level = level
  end

  def level?(level)
    levels.has_key?(level)
  end
  alias :logger_level? :level?

  def add_level(level)
    return nil if logger_level?(level)
    Method.define(self, level)
    levels[level] = levels.length
  end

  def remove_level(level)
    return nil unless logger_level?(level)
    Method.remove(self, level)
    levels.delete(level)
  end

  def assure_level(level)
    unless level.nil? || !levels? || level?(level)
      raise Log::Error, "Level #{level.inspect} must be one of: #{levels.keys.join(', ')}"
    end
  end

  def precedent?(level)
    ordinal(level) <= ordinal
  end

  def ordinal(level=nil)
    level ||= logger_level
    levels.fetch(level, no_ordinal)
  end

  def no_ordinal
    -1
  end

  module Method
    def self.define(logger, level_name)
      level = level_name
      logger.define_singleton_method(level) do |message, tag: nil, tags: nil|
        self.(message, level, tag: tag, tags: tags)
      end
    end

    def self.remove(logger, level_name)
      logger.instance_eval "undef #{level_name}"
    end
  end
end