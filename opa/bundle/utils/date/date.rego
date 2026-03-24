package utils.date

import rego.v1

# HELPER The current date in 2006-01-02 format.
today_date := ns_to_datum(time.now_ns())

# HELPER The current date (00:00 midnight).
today_ns := time.parse_ns("2006-01-02", today_date)

# HELPER Convert a date in ns to a date in 2006-01-02 format.
ns_to_datum(date_ns) := split(time.format(date_ns), "T")[0]

dt_to_datum(dt_string) := split(dt_string, "T")[0]

# HELPER Check if the first date is before the second date.
compare_time_before(date1, date2) if {
	start_date := time.parse_ns("2006-01-02", date1)
	end_date := time.parse_ns("2006-01-02", date2)
	start_date <= end_date
}

# HELPER Check if the first date is after the second date.
compare_time_after(date1, date2) if {
	start_date := time.parse_ns("2006-01-02", date1)
	end_date := time.parse_ns("2006-01-02", date2)
	start_date >= end_date
}

compare_time_equals(date1, date2) if {
	start_date := time.parse_ns("2006-01-02", date1)
	end_date := time.parse_ns("2006-01-02", date2)
	start_date == end_date
}

# HELPER Subtract one day from a given date string
# Returns the date one day before the input date
subtract_one_day(date_string) := result if {
	date_ns := time.parse_ns("2006-01-02", date_string)
	one_day_ns := ((24 * 60) * 60) * 1000000000 # 24 hours in nanoseconds
	new_date_ns := date_ns - one_day_ns
	result := ns_to_datum(new_date_ns)
}
