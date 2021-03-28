defmodule AzureTextToSpeech.MixProject do
  use Mix.Project

  @source_url "https://github.com/TORIFUKUKaiou/azure_text_to_speech"
  @version "0.1.0"

  def project do
    [
      app: :azure_text_to_speech,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {AzureTextToSpeech.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      description: "Elixir wrapper for Azure Text to Speech API.",
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      maintainers: ["TORIFUKU Kaiou"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/azure_text_to_speech/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "#{@version}",
      formatters: ["html"]
    ]
  end
end
