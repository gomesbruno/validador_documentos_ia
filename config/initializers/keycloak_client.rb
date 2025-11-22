keycloak_credentials = YAML.load_file('config/keycloak.yml')[Rails.env]
Iduff::KeycloakClient.configure do |config|
  config.issuer = keycloak_credentials['issuer']
  config.secret = keycloak_credentials['secret']
  config.identifier = keycloak_credentials['identifier']
  config.update_endpoints
end
