defmodule AshKaffy.Resource do
  @transformers [
    AshKaffy.Resource.Transformers.CreateAdminModule
  ]

  @column %Ash.Dsl.Entity{
    name: :column,
    target: AshKaffy.Resource.Column,
    describe: "Adds a column in the kaffy index view",
    examples: [
      "column :title, \"Title\""
    ],
    schema: [
      name: [
        type: :atom,
        doc: "The attribute name to add",
        required: true
      ],
      pretty_name: [
        type: :string,
        doc: "The actual text to use in the column header",
        required: true
      ]
    ],
    args: [:name, :pretty_name]
  }

  @columns %Ash.Dsl.Section{
    name: :columns,
    describe: "Configure the columns for the index page in kaffy",
    entities: [
      @column
    ]
  }

  @kaffy %Ash.Dsl.Section{
    name: :kaffy,
    describe: "A section for declaring the configuration of your kaffy admin interface",
    sections: [
      @columns
    ]
  }

  use Ash.Dsl.Extension, sections: [@kaffy], transformers: @transformers

  def columns(resource) do
    Ash.Dsl.Extension.get_entities(resource, [:kaffy, :columns])
  end

  def admin_module(resource) do
    Module.concat(resource, KaffyAdmin)
  end
end
