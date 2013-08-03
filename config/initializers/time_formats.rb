Time::DATE_FORMATS[:month_and_year] = "%B %Y"
Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%e-%b-%Y %H:%M") }
Time::DATE_FORMATS[:default_date] = lambda { |time| time.strftime("%e-%b-%Y") }
Time::DATE_FORMATS[:pretty_view] = lambda { |time| time.strftime("%a, %b %e %Y") }
Time::DATE_FORMATS[:month_day_and_year] = "%a, %b %e %Y"
Time::DATE_FORMATS[:year_month_day] = "%B %d %Y" 