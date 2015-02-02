require "cta-api"
require "time_diff"

class NextTrain
  def self.[](stpid)
    new(stpid).execute
  end

  def self.api_key= (api_key)
    CTA::TrainTracker.key = api_key
  end

  def initialize(stpid)
    @stpid = stpid
  end

  def execute
    if minutes_until_next_arrival == 0
      "arriving"
    else
      arrival_time_in_minutes
    end
  end

  private

  attr_reader :stpid

  def arrival_time_in_minutes
    time_until_next_arrival_diff[:diff]
  end

  def minutes_until_next_arrival
    time_until_next_arrival_diff[:minute]
  end

  def time_until_next_arrival_diff
    Time.diff(next_arrival_time, Time.now, "%N")
  end

  def next_arrival_time
    Time.parse(next_arrival[arrival_time_key])
  end

  def arrival_time_key
    "arrT"
  end

  def next_arrival
    arrivals[0]
  end

  def arrivals
    ensure_no_puts do
      data = CTA::TrainTracker.arrivals(stpid: stpid)

      if data.empty?
         raise "No data returned, please check your API key"
      else
         data
      end
    end
  end

  def error?(data)
    data["errCd"] && data["errCd"] != "0"
  end

  def ensure_no_puts(&block)
    tmp = $stdout
    $stdout = StringIO.new
    block.call
  ensure
    $stdout = tmp
  end
end
