defmodule AshKaffy.Api do
  @moduledoc """
  The Kaffy DSL extension

  * kaffy - `kaffy/1`
  """
  @resource %Ash.Dsl.Entity{
    name: :resource,
    target: AshKaffy.ResourceReference,
    describe: "A resource",
    examples: [
      "resource MyApp.Organization"
    ],
    schema: [
      name: [
        type: :atom,
        doc: "The name of the resource",
        required: true
      ],
      resource: [
        type: :atom,
        doc: "The resource to include in the context",
        required: true
      ]
    ],
    args: [:name, :resource]
  }

  @context %Ash.Dsl.Entity{
    name: :context,
    target: AshKaffy.Context,
    describe: "A context, and its resources",
    examples: [
      """
      context :organizations do
        resource MyApp.Organization
        resource MyApp.Account
      end
      """
    ],
    entities: [
      resources: [@resource]
    ],
    schema: [
      name: [
        type: :atom,
        doc: "The name of the context",
        required: true
      ],
      pretty_name: [
        type: :string,
        doc: "The name to be used in rendering",
        required: false
      ]
    ],
    args: [:name]
  }

  @contexts %Ash.Dsl.Section{
    name: :contexts,
    describe: "A list of your contexts and the resources inside of them",
    entities: [
      @context
    ]
  }

  @kaffy %Ash.Dsl.Section{
    name: :kaffy,
    describe:
      "A section for declaring the contexts and resources to be shown in your kaffy admin interface",
    sections: [
      @contexts
    ]
  }

  use Ash.Dsl.Extension, sections: [@kaffy]

  def contexts(api) do
    Ash.Dsl.Extension.get_entities(api, [:kaffy, :contexts])
  end

  def resources(_conn, api) do
    api
    |> contexts()
    |> Enum.map(fn %{resources: resources, name: name, pretty_name: pretty_name} ->
      {name,
       [
         name: pretty_name,
         resources:
           Enum.map(resources, fn resource_reference ->
             {resource_reference.name,
              [
                schema: resource_reference.resource,
                admin: AshKaffy.Resource.admin_module(resource_reference.resource)
              ]}
           end)
       ]}
    end)
  end
end
