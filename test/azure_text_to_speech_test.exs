defmodule AzureTextToSpeechTest do
  use ExUnit.Case
  doctest AzureTextToSpeech

  test "greets the world" do
    assert AzureTextToSpeech.hello() == :world
  end
end
