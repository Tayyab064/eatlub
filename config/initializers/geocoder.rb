Geocoder.configure(

  # geocoding service:
  :lookup => :google,

  # IP address geocoding service:
  :ip_lookup => :maxmind,
  # Geocoding options
    timeout: 15,                 # geocoding service timeout (secs)
  # lookup: :google,            # name of geocoding service (symbol)
  # language: :en,              # ISO-639 language code
    use_https: true,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  api_key: 'AIzaSyBoUyblkGqwp2lFuWQb0v_-J_mI5sYJYPc',               # API key for geocoding service
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #keys)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)
