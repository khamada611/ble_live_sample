defmodule BleLiveSampleWeb.PageLive do
  use BleLiveSampleWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    img_file = "/images/puronama/puronama_selectdev.png"
    serif = "Select BLE heart rate device, please."
    {:ok, assign(socket, pronama: img_file, serif: serif, heart_rate: "-1", latest_rate: -1, rate_count: 0) }
  end

  defp update_website(socket, img_file) do
    serif = "Your heart rate is [ " <> Integer.to_string(socket.assigns.latest_rate) <> " ]. counter=" <> Integer.to_string(socket.assigns.rate_count)
    {:noreply, assign(socket, pronama: img_file, serif: serif) }
  end

  @impl true
  def handle_info( { :mes_update, "up_rate" }, socket ) do
    img_file = "/images/puronama/puronama_up.png"
    update_website(socket, img_file)
  end

  @impl true
  def handle_info( { :mes_update, "down_rate" }, socket ) do
    img_file = "/images/puronama/puronama_down.png"
    update_website(socket, img_file)
  end

  @impl true
  def handle_info( { :mes_update, "same_rate" }, socket ) do
    if rem(socket.assigns.rate_count,2) == 0 do
      img_file = "/images/puronama/puronama_same_even.png"
      update_website(socket, img_file)
    else
      img_file = "/images/puronama/puronama_same_odd.png"
      update_website(socket, img_file)
    end
  end

  @impl true
  def handle_event( "change", %{ "heart_rate" => heart_rate }, socket ) do
    now = String.to_integer(heart_rate)
    Logger.debug("event inc : #{inspect(now)} cnt: #{inspect(socket.assigns.rate_count)}")
    cond do
      now > socket.assigns.latest_rate ->
        send( self(), { :mes_update, "up_rate" } )    # call hande_info
        {:noreply, assign(socket, heart_rate: heart_rate, latest_rate: now, rate_count: socket.assigns.rate_count + 1) }
      now < socket.assigns.latest_rate ->
        send( self(), { :mes_update, "down_rate" } )  # call hande_info
        {:noreply, assign(socket, heart_rate: heart_rate, latest_rate: now, rate_count: socket.assigns.rate_count + 1) }
      true ->
        send( self(), { :mes_update, "same_rate" } )  # call hande_info
        {:noreply, assign(socket, rate_count: socket.assigns.rate_count + 1) }
    end
  end

end
