json.(@type, :name, :portion_size, :published, :group_id, :market_group_id, :created_at, :updated_at)

json.packaged_volume @type.packaged_volume.to_f if json.packaged_volume
json.volume @type.volume.to_f

json.group do
  json.(@type.group, :id, :name, :published, :created_at, :updated_at, :category_id)

  json.category do
    json.(@type.group.category, :id, :name, :published, :created_at, :updated_at)
  end
end

json.market_group do
  json.(@type.market_group, :id, :name, :created_at, :updated_at, :parent_id)
end
