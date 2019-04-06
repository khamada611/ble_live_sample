defmodule BleLiveSampleWeb.BleSampleLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    ~L"""
    
    <div>
      <h1>Bluetooth low enegry heart rate demo</h1>
      <button type="button" name="ble_button" onclick="OnButtonClick();">Select</button>
      <table border="0">
        <tr>
          <td>
            <img id="botImg" src=<%= @pronama %> />
          </td>
          <td>
            <h2 align="left"><%= @serif %><h2>
          </td>
        </tr>
      </table>
      <form name="ble_test" id="ble_test" phx-change="change">
            <input type="text" class="blesample_hidden" name="heart_rate" id="heart_rate" value="<%= @heart_rate %>">
      </form>
    </div>
    <script>

      // Web Bluetooth value -> LiveView 
      function IssueBLEEvent(val) {
        document.ble_test.heart_rate.value = val;
        var evt = document.createEvent( "MouseEvents" ); 
        evt.initEvent( "change", true, true );
        document.ble_test.heart_rate.dispatchEvent(evt);
      }

      // Connect to BLE hert rate device.
      function OnButtonClick() {
        heartRateSensor.connect()
          .then(() => heartRateSensor.startNotificationsHeartRateMeasurement().then(handleHeartRateMeasurement))
          .catch(error => {
            alert("BLUETOOTH_ERROR>" + error);
          });
      }

      // Callback from Web Bluetooth. notify hert rate data.
      function handleHeartRateMeasurement(heartRateMeasurement) {
        heartRateMeasurement.addEventListener('characteristicvaluechanged', event => {
          var heartRateMeasurement = heartRateSensor.parseHeartRate(event.target.value);
          IssueBLEEvent(heartRateMeasurement.heartRate);
        });
      }
  
    </script>

    """
  end

  def mount(_session, socket) do
    img_file = "/images/puronama/puronama_selectdev.png"
    serif = "Select BLE heart rate device, please."
    {:ok, assign(socket, pronama: img_file, serif: serif, heart_rate: "-1", latest_rate: -1, rate_count: 0) } 
  end

  def update_website(socket, img_file) do
    serif = "Your heart rate is [ " <> Integer.to_string(socket.assigns.latest_rate) <> " ]. counter=" <> Integer.to_string(socket.assigns.rate_count)
    {:noreply, assign(socket, pronama: img_file, serif: serif) }
  end

  def handle_info( { :mes_update, "up_rate" }, socket ) do
    img_file = "/images/puronama/puronama_up.png"
    update_website(socket, img_file)
  end

  def handle_info( { :mes_update, "down_rate" }, socket ) do
    img_file = "/images/puronama/puronama_down.png"
    update_website(socket, img_file)
  end

  def handle_info( { :mes_update, "same_rate" }, socket ) do
    if rem(socket.assigns.rate_count,2) == 0 do
      img_file = "/images/puronama/puronama_same_even.png"
      update_website(socket, img_file)
    else
      img_file = "/images/puronama/puronama_same_odd.png"
      update_website(socket, img_file)
    end
  end

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

