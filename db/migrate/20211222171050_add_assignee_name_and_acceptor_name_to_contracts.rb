class AddAssigneeNameAndAcceptorNameToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :assignee_name, :text
    add_column :contracts, :acceptor_name, :text
  end
end
