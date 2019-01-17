if Rails.env.development?
  Dotenv.require_keys(
    "APP_HOST_URL",
    "SECRET_KEY_BASE",
    "POSTGRES_HOST",
    "POSTGRES_DB",
    "POSTGRES_USER"
  )
end