defmodule Askie.IntentHandler do
  use Plug.Builder
  import Askie.Security.InboundRequestValidation, only:
    [application_id_check: 2, replay_attack_check: 2]

  @json_content_type {"content-type", "application/json"}

  plug :must_be_post
  plug :must_be_json
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :application_id_check
  plug :replay_attack_check

  def must_be_post(%Plug.Conn{method: "POST"} = conn, _opts), do: conn
  def must_be_post(%Plug.Conn{} = conn, _opts), do: invalid_request(conn, "method must be POST")

  def must_be_json(%Plug.Conn{req_headers: headers} = conn, _opts) do
    if Enum.member?(headers, @json_content_type) do
      conn
    else
      invalid_request(conn, "json content type is required")
    end
  end


  def invalid_request(conn, body_text \\ "") do
    conn |> send_resp(400, body_text) |> halt
  end
end
