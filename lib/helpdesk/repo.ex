# in lib/helpdesk/repo.ex

defmodule Helpdesk.Repo do
  use AshPostgres.Repo, otp_app: :helpdesk

  def installed_extensions do
    # Ash installs some functions that it needs to run the
    # first time you generate migrations.
    ["ash-functions"]
  end
end
