defmodule AzureTextToSpeech do
  @moduledoc """
  Documentation for `AzureTextToSpeech`.
  """

  @region Application.get_env(:azure_text_to_speech, :region)
  @subscription_key Application.get_env(:azure_text_to_speech, :subscription_key)
  @audio_list ~w(
    raw-16khz-16bit-mono-pcm            raw-8khz-8bit-mono-mulaw
    riff-8khz-8bit-mono-alaw            riff-8khz-8bit-mono-mulaw
    riff-16khz-16bit-mono-pcm           audio-16khz-128kbitrate-mono-mp3
    audio-16khz-64kbitrate-mono-mp3     audio-16khz-32kbitrate-mono-mp3
    raw-24khz-16bit-mono-pcm            riff-24khz-16bit-mono-pcm
    audio-24khz-160kbitrate-mono-mp3    audio-24khz-96kbitrate-mono-mp3
    audio-24khz-48kbitrate-mono-mp3     ogg-24khz-16bit-mono-opus
    raw-48khz-16bit-mono-pcm            riff-48khz-16bit-mono-pcm
    audio-48khz-96kbitrate-mono-mp3     audio-48khz-192kbitrate-mono-mp3)
  @user_agent "awesome"

  def voices_list do
    voices_list_endpoint()
    |> HTTPoison.get!(authorization_header(access_token()))
    |> Map.get(:body)
    |> Jason.decode!()
  end

  def audio_list do
    @audio_list
  end

  def ssml(text, %{"Name" => name, "Locale" => locale, "Gender" => gender}) do
    """
    <speak version='1.0' xml:lang='#{locale}'>
      <voice xml:lang='#{locale}' xml:gender='#{gender}' name='#{name}'>
        #{text}
      </voice>
    </speak>
    """
  end

  def to_speech_of_standard_voice(ssml, audio \\ "riff-24khz-16bit-mono-pcm") do
    to_speech_of_neural_voice(ssml, audio)
  end

  def to_speech_of_neural_voice(ssml, audio \\ "riff-24khz-16bit-mono-pcm") do
    standard_and_neural_voice_endpoint()
    |> HTTPoison.post!(ssml, headers(audio))
    |> Map.get(:body)
  end

  def to_speech_of_custom_voice do
    # TODO
  end

  def to_speech_of_long_audio do
    # TODO
  end

  defp access_token do
    %{token: token, time: time} = AzureTextToSpeech.AccessTokenAgent.get()

    if DateTime.diff(DateTime.now!("Etc/UTC"), time) > 60 * 9 do
      get_access_token()
      |> AzureTextToSpeech.AccessTokenAgent.update()

      access_token()
    else
      token
    end
  end

  defp get_access_token do
    headers = [
      "Ocp-Apim-Subscription-Key": @subscription_key,
      "Content-type": "application/x-www-form-urlencoded"
    ]

    issue_token_endpoint()
    |> HTTPoison.post!("", headers)
    |> Map.get(:body)
  end

  defp issue_token_endpoint do
    "https://#{@region}.api.cognitive.microsoft.com/sts/v1.0/issueToken"
  end

  defp voices_list_endpoint do
    "https://#{@region}.tts.speech.microsoft.com/cognitiveservices/voices/list"
  end

  defp standard_and_neural_voice_endpoint do
    "https://#{@region}.tts.speech.microsoft.com/cognitiveservices/v1"
  end

  defp authorization_header(token) do
    [Authorization: "Bearer #{token}"]
  end

  defp headers(audio) do
    access_token()
    |> authorization_header()
    |> Keyword.merge(
      "Content-Type": "application/ssml+xml",
      "X-Microsoft-OutputFormat": audio,
      "User-Agent": @user_agent
    )
  end
end
