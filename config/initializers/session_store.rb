Rails.application.config.session_store :redis_session_store,
  key: 'ubackoff',
  serializer: :json,
  redis: {
    expire_after: 1.minute,
    url: ENV['REDIS_URL'],
  }
