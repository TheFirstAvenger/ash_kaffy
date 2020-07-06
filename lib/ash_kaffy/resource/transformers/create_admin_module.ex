defmodule AshKaffy.Resource.Transformers.CreateAdminModule do
  use Ash.Dsl.Transformer

  @impl true
  def compile_time_only?, do: true

  @impl true
  def transform(resource, dsl) do
    resource
    |> Module.concat(KaffyAdmin)
    |> Module.create(
      quote do
        def index(_) do
          unquote(resource)
          |> AshKaffy.Resource.columns()
          |> Enum.map(fn column ->
            {column.name, %{name: column.pretty_name}}
          end)
        end
      end,
      Macro.Env.location(__ENV__)
    )

    {:ok, dsl}
  end
end
