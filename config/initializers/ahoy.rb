class Ahoy::Store < Ahoy::Stores::BaseStore
  def track_visit(options)

    ap 'Visit'
    ap options
  end

  def track_event(name, properties, options)
    ap 'track event'
    NamsPaas.track_ahoy_event({
      event_type: name,
      properties: properties
    })
  end

  def current_visit
    ap 'current visit'
  end
end
