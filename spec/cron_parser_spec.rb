require 'cron_parser'

describe CronParser do
  describe '.schedule' do
    context "Given a cron expression" do
      it "returns the minutes of execution if an int" do
        parsed = CronParser.new("15 0 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:minute]).to eq("15")
      end

      it "returns the minutes of execution if a wildcard" do
        parsed = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:minute]).to eq("0 15 30 45")
      end

      it "returns the hours of execution if an int" do
        parsed = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:hour]).to eq("0")
      end

      it "returns the hours of execution if a wildcard" do
        parsed = CronParser.new("*/15 */4 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:hour]).to eq("0 4 8 12 16 20")
      end

      it "returns the days of the month of execution if given a list" do
        parsed = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:day_of_month]).to eq("1 15")
      end

      it "returns the days of the month of execution if given a wildcard" do
        parsed = CronParser.new("*/15 0 */4 * 1-5 /usr/bin/find").schedule
        expect(parsed[:day_of_month]).to eq("1 5 9 13 17 21 25 29")
      end

      it "returns months of execution if given a complete wildcard" do
        parsed = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:month]).to eq("1 2 3 4 5 6 7 8 9 10 11 12")
      end

      it "returns days of week of execution if given a range" do
        parsed = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:day_of_week]).to eq("1 2 3 4 5")
      end

      it "returns command" do
        parsed = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").schedule
        expect(parsed[:command]).to eq("/usr/bin/find")
      end

      it "returns command even if contains spaces" do
        parsed = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find . -name foo*").schedule
        expect(parsed[:command]).to eq("/usr/bin/find . -name foo*")
      end

      it "returns raises an error on invalid step value" do
        expect {CronParser.new("*/90 0 1,15 * 1-5 /usr/bin/find")}.to raise_exception("Invalid value passed to minute 90 > 59")
      end

      it "returns raises an error on invalid value" do
        expect {CronParser.new("*/15 900 1,15 * 1-5 /usr/bin/find")}.to raise_exception("Invalid value passed to hour 900 > 23")
      end

      it "returns raises an error on if min > max" do
        expect {CronParser.new("*/15 0 1,15 * 6-5 /usr/bin/find")}.to raise_exception("Invalid value passed to day_of_week 6 > 5")
      end

      it "returns raises an error on invalid value in list" do
        expect {CronParser.new("*/15 0 1,200 * 1-5 /usr/bin/find")}.to raise_exception("Invalid value passed to day_of_month 200 > 31")
      end

      it "returns raises an error on invalid value in range" do
        expect {CronParser.new("*/15 0 1,15 * 1-400 /usr/bin/find")}.to raise_exception("Invalid value passed to day_of_week 400 > 7")
      end
    end
  end

  describe '.format' do
    context "Given a cron expression" do
      it "returns returns a string to print" do
        formatted = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").format
        expect(formatted).to eq("minute 0 15 30 45\nhour 0\nday of month 1 15\nmonth 1 2 3 4 5 6 7 8 9 10 11 12\nday of week 1 2 3 4 5\ncommand /usr/bin/find")
      end
    end
  end

end
