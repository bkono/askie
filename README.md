# Alexa Skills Kit in Elixir aka ASKiE (_pun intended_)

[Alexa Skills Kit](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/getting-started-guide)
is Amazon's developer platform creating new functionality for use by the very impressive hardware,
Amazon Echo. While Amazon provides a fully featured java sdk, and there are several impressive
node sdks, for some bizarre reason one didn't exist for Elixir. Until now.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add askie to your list of dependencies in `mix.exs`:

        def deps do
          [{:askie, "~> 0.0.1"}]
        end

  2. Ensure askie is started before your application:

        def application do
          [applications: [:askie]]
        end
