require 'cucumber/mingle'

AfterConfiguration do |config|
  Cucumber::Mingle.features config, :host => 'http://localhost:8080',  :user => 'vincentx', 
                           :password => 'password',  :project => 'calculator', :filters => 'Type IS Story'
  Cucumber::Mingle.results do |invalid_cards, passed, failed, pending|
    count = passed.length + failed.length + pending.length
    test_report = Cucumber::Mingle::Card.new 
    test_report.name = "#{Time.now}"
    test_report.type = 'Test Report'
    test_report.description = ''
    test_report.save
    test_report = Cucumber::Mingle::Card.find_by_number(test_report.id)   
    test_report['Scenario Count'] = count
    test_report['Automated Scenario Count'] = count-pending.length   
    test_report.save    
  end
end