module VcrCable
  class CassetteMiddleware
    def self.cassette_name
      @@cassette_name 
    end

    def self.cassette_name=(name)
      @@cassette_name = name
    end

    def update_cassette_name(name)
      return if self.class.cassette_name == name
      
      self.class.cassette_name= name
      VCR.insert_cassette(name)
    end

    def initialize(app)
      @app = app
    end
    
    def call(env)
      env['QUERY_STRING'].split('&').each {|p| update_cassette_name(p.split('=').last) if p.starts_with?('cassette_name=')}
      @app.call(env)
    end
  end
end
