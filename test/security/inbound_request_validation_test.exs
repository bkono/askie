defmodule Askie.Security.InboundRequestValidationTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Timex

  alias Askie.Security.InboundRequestValidation

  @good_app_id Application.get_env(:askie, :application_id)

  test "app_id_check rejects on mismatch" do
    conn = conn(:get, "/hello", %{"session" => %{"application" => %{"applicationId" => "bad_id"}}})

    InboundRequestValidation.application_id_check(conn, %{})
    |> assert_unauthorized
  end

  test "app_id_check passes on match" do
    conn = conn(:get, "/hello", %{"session" => %{"application" => 
        %{"applicationId" => @good_app_id}}})

    InboundRequestValidation.application_id_check(conn, %{})
    |> assert_unchanged(conn)
  end

  test "replay_attack_check rejects on older than tolerance" do
    conn = conn(:get, "/hello", %{"request" => %{"timestamp" => replay_timestamp(1)}})

    InboundRequestValidation.replay_attack_check(conn, %{})
    |> assert_unauthorized
  end

  test "replay_attack_check rejects timestamps in the future" do
    conn = conn(:get, "/hello", %{"request" => %{"timestamp" => future_time}})

    InboundRequestValidation.replay_attack_check(conn, %{})
    |> assert_unauthorized
  end

  test "replay_attack_check passes on less than tolerance" do
    conn = conn(:get, "/hello", %{"request" => %{"timestamp" => replay_timestamp(-3) }})

    InboundRequestValidation.replay_attack_check(conn, %{})
    |> assert_unchanged(conn)
  end


  defp future_time do
    seconds_to_add = Time.to_timestamp(120, :secs)
    {:ok, timestamp} = Date.now |> Date.add(seconds_to_add) |> DateFormat.format("{ISOz}")
    timestamp
  end
  defp replay_timestamp(modify_seconds) do
    subtracted_seconds = Time.to_timestamp(
                         InboundRequestValidation.replay_attack_tolerance + modify_seconds, :secs)
    {:ok, old_request_time} = Date.now 
                        |> Date.subtract(subtracted_seconds) |> DateFormat.format("{ISOz}")
    old_request_time
  end

  defp assert_unauthorized(%Plug.Conn{} = result) do
    assert result.status == 401
    assert result.state == :sent
    assert result.halted == true
  end

  defp assert_unchanged(%Plug.Conn{} = result, %Plug.Conn{} = original) do
    assert result.status == original.status
    assert result.halted == false
  end
end

