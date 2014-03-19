class CassetteMiddleware
  def self.cassette_name
    @@cassette_name ||= 'default_cassette'
  end

  def self.cassette_name=(name)
    @@cassette_name = name
  end

  def initialize(app)
    @app = app
  end
  
  def call(env)
    env['QUERY_STRING'].split('&').each {|p| CassetteMiddleware.cassette_name = p.split('=').last if p.starts_with?('cassette_name=')}
    VCR.insert_cassette(CassetteMiddleware.cassette_name)
    @app.call(env)
  end
end

