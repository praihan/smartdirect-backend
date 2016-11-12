unless Rails.env.production?
  ActiveRecordQueryTrace.enabled = true
  ActiveRecordQueryTrace.colorize = true
end