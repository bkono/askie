defmodule Askie.Security.InboundRequestValidation do
  import Plug.Conn
  require Logger
  use Timex

  def application_id_check(%Plug.Conn{params: %{"session" => 
      %{"application" => %{"applicationId" => inbound_app_id}}}} = conn, _opts) do
    if inbound_app_id == application_id do
      conn
    else
      Logger.warn "rejecting invalid alexa_app_id=#{inspect inbound_app_id}}"
      send_resp(conn, 401, "") |> halt
    end
  end

  def replay_attack_check(%Plug.Conn{params: %{"request" => 
      %{"timestamp" => timestamp}}} = conn, _opts) do
    {:ok, parsed} = timestamp |> DateFormat.parse("{ISOz}")
    oldest_allowed = Date.now |> Date.subtract(Time.to_timestamp(replay_attack_tolerance, :secs))
    if first_date_older?(oldest_allowed, parsed) do
      conn
    else
      Logger.warn """
      replay_attack_check rejecting due to timestamp=#{timestamp} out of tolerance"
      params=#{inspect conn.params}"
      """
      conn |> send_resp(401, "") |> halt
    end
  end

  def first_date_older?(first, second) do
    case Date.compare(first, second) do
      -1 -> true
      _ -> false
    end
  end

  def application_id do
    Application.get_env(:askie, :application_id)
  end

  def replay_attack_tolerance do
    Application.get_env(:askie, :replay_attack_tolerance)
    |> Integer.parse |> elem(0)
  end
end
