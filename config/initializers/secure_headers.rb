SecureHeaders::Configuration.default do |config|
  config.csp = {
      default_src: %w('self' https:), # the fallback is everything from the same origin and every HTTPS URL
      script_src: %w('self' https:), # see above
      font_src: %w('self' https: data:), # see above + data: resources
      img_src: %w('self' https: data:), # see above
      object_src: %w('none'), # no embedding
      style_src: %w('self' https: 'unsafe-inline'), # basically only styles from HTTP URLs or data: sources are disallowed
  }
end