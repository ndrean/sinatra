Sequel.migration do
  change do
    create_table(:dogs) do
      primary_key :id
      String :ip, :null => false
      String :host, :null => false
      String :path, :null => false
      Date   :requested_at, :null => false
    end
  end 
end
