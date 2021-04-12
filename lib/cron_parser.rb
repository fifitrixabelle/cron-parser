class CronParser
  attr_reader :schedule

  def initialize(expression)
    @expression = expression
    @schedule = parse
  end

  def parse
    if @schedule
      return @schedule
    else
      @schedule = {}
      minute, hour, dom, month, dow, *command = @expression.split(/\s/)
      command = command.join(" ")

      @schedule[:minute] = parse_part(:minute, minute, 0, 59)
      @schedule[:hour] = parse_part(:hour, hour, 0, 23)
      @schedule[:day_of_month] = parse_part(:day_of_month, dom, 1, 31)
      @schedule[:month] = parse_part(:month, month, 1, 12)
      @schedule[:day_of_week] = parse_part(:day_of_week, dow, 1, 7)
      @schedule[:command] = command
    end
    return @schedule
  end

  def parse_part(name, part, min, max)
    if part == '*'
      get_range(min, max, 1).join(" ")
    elsif part.include?('*/')
      step = part.split(/\//)[1].to_i
      validate(name, min, max, step)
      get_range(min, max, step).join(" ")
    elsif part.include?('-')
      min_part, max_part = part.split('-').map {|x| x.to_i }
      validate(name, min, max, min_part, max_part)
      validate(name, min, max_part, min_part)
      get_range(min_part, max_part, 1).join(" ")
    elsif part.include?(',')
      list = part.split(/,/)
      validate(name, min, max, *list)
      list.join(" ")
    else
      validate(name, min, max, part)
      part
    end
  end

  def validate(name, min, max, *vals)
    vals.each do |val|
      raise "Invalid value passed to #{name} #{val} < #{min}" if val.to_i < min
      raise "Invalid value passed to #{name} #{val} > #{max}" if val.to_i > max
    end
  end

  def get_range(min, max, step)
    min.step(max, step).map {|i| i.to_s }
  end

  def format
    @schedule.map { |type,part| "#{type.to_s.gsub("_", " ")} #{part}" }.join "\n"
  end
end
