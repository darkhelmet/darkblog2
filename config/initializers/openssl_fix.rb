require 'openssl'

# Fuck you SSL, to make Excon posting to momentapp.com work properly.
class OpenSSL::SSL::SSLSocket
  def post_connection_check(hostname)
    true
  end
end