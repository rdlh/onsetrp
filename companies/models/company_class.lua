-- Meta class
CompanyClass = { }

-- Base class method new
CompanyClass.new = function (id, name, money, positions)
  local self = { }

  -- Public attributes

  self.id = id or nil
  self.name = name or ""
  self.money = money or 0
  self.error = nil
  self.positions = positions or { }

  -- Private attributes

  self._table_name = 'companies'

  -- Functions

  self.addMoney = function (addedMoney)
    print(1)
    return self.updateAttributes({ money = self.money + addedMoney })
  end

  self.removeMoney = function (addedMoney)
    if CompaniesConfig.allowNegativeBankAccounts or self.money > addedMoney then
      self.updateAttributes({ money = self.money - addedMoney })
      return true
    else
      self.error = "Not enough money."
      return false
    end
  end

  self.updateAttributes = function (attributes)
    local shouldSave = false
    local newAttributes = { }

    for key, value in pairs(attributes) do
      if self[key] ~= value then
        shouldSave = true
        table.insert(newAttributes, key.." = "..value)
        self[key] = value
      end
    end

    if shouldSave then
      local query = "UPDATE "..self._table_name.." SET "..table.concat(newAttributes, ", ").." WHERE id = "..self.id..";"
  
      if CompaniesConfig.debug then
        print("OnsetRP::Companies DEBUG → "..query)
      end
  
      mariadb_async_query(sql, query, function() end)
    end
  end

  self.error = nil

  return self
end
