class ServiceHoliday

  def self.us_holidays
    response = Faraday.new('https://date.nager.at/').get('api/v2/NextPublicHolidays/us')
    upcoming_holidays = []
    json = JSON.parse(response.body, symbolize_names: true)
    json[0..2].each do |data|
      upcoming_holidays << Holiday.new(data)

    end
    upcoming_holidays
    
  end
end
