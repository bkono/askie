use Mix.Config

config :askie,
  application_id: System.get_env("ASKIE_APPLICATION_ID"),
  replay_attack_tolerance: (System.get_env("ASKIE_REPLAY_ATTACK_TOLERANCE_IN_SECONDS") || "150")

import_config "#{Mix.env}.exs"
