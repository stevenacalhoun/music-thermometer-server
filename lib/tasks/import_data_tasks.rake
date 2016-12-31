namespace :import_data do
  # Import raw data into hot100 table
  task import_csv: :environment do
    importCountryData('us')
    importCountryData('uk')
  end
end

def importCountryData(country)
  csv_text = File.read('data/'+country+'.csv')
  csv = CSV.parse(csv_text)

  i = 0
  csv.each do |row|
    if i % 10000 == 0
      puts "Progress: " + i.to_s + "/" + csv.length.to_s
    end
    i += 1

    # Find or create song
    song = Song.where(title: row[0], artist: row[1], spotify_id: row[7]).first_or_create

    # Add top chart entry
    TopChart.create(song_id: song.id, last_pos: row[3], weeks: row[4], rank: row[5], change: row[6],  chart_week: row[10], country: country)
  end
end
