# lib/helpdesk/support/representative.ex

defmodule Helpdesk.Support.Representative do
  # This turns this module into a resource using the in memory ETS data layer
  use Ash.Resource,
    domain: Helpdesk.Support,
    data_layer: Ash.DataLayer.Ets

  actions do
    # Add the default simple actions
    defaults [:read]

    create :create do
      accept [:name]
    end
  end

  # Attributes are the simple pieces of data that exist on your resource
  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_primary_key :id

    # Add a string type attribute called `:name`
    attribute :name, :string do
      # Make the attribute public in order to give a name when calling functions from `Ash.Changeset`.
      public? true
    end
  end

  relationships do
    # `has_many` means that the destination attribute is not unique, therefore many related records could exist.
    # We assume that the destination attribute is `representative_id` based
    # on the module name of this resource and that the source attribute is `id`.
    has_many :tickets, Helpdesk.Support.Ticket
  end
end
