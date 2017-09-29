json.extract! category, "id", "name", "description", "tags", "class_name", "family_common", "location", "url", "site_id", "created_at", "updated_at", "deleted_at", "family_scientific", "species_scientific", "species_common", "status", "growth", "habit", "impact", "distribution"
json.photos category.photos rescue nil
