defmodule EzCoinsApiWeb.Schema.Types do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias EzCoinsApiWeb.Schema.Types

  import_types(Types.AuthType)
  import_types(Types.DonationType)
  import_types(Types.UserType)
end
