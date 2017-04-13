class Ahoy::Store < Ahoy::Stores::BaseStore
  def track_visit(options)
    NamsPaas.track_ahoy_event({
      event_type: 'NEW_VISIT',
      timestamp: options[:started_at].to_i,
      visit_token: ahoy.visit_token,
      visitor_token: ahoy.visitor_token
    })
  end

  def track_event(name, properties, options)
    NamsPaas.track_ahoy_event({
      event_type: name,
      properties: properties,
      visit_token: ahoy.visit_token,
      visitor_token: ahoy.visitor_token,
      timestamp: options[:time].to_i
    })
  end

  def current_visit
    ap 'current visit'
  end
end
