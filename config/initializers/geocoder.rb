Geocoder.configure(
    # geocoding options
    :timeout      => 10,           # geocoding service timeout (secs)
    :lookup       => :google,     # name of geocoding service (symbol)
    :language     => :en,         # ISO-639 language code
    :use_https    => true,       # use HTTPS for lookup requests? (if supported)
    :api_key      => Rails.application.secrets.google_api_key,         # API key for geocoding service
)
