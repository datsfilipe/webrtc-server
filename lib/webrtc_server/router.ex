defmodule WebrtcServer.Router do
  import Jason

  def encode_data(data) do
    data
    |> encode!()
    |> String.to_charlist()
  end

  def match(uri) do
    case uri do
      '/' ->
        {200, encode_data(%{"message" => "Hello World"})}
      _ ->
        {404, encode_data("Not Found")}
    end
  end
end
