Company = { }

Company.all = function (callback)
  if callback then
    callback(Companies)
  else
    return Companies
  end
end

Company.find = function (id, callback)
  if callback then
    callback(Company.findBy("id", id))
  else
    return Company.findBy("id", id)
  end
end

Company.findBy = function (attribute, value, callback)
  local returnedCompany

  for _, company in pairs(Companies) do
    if company[attribute] == value then
      returnedCompany = company
    end
  end

  if callback then
    callback(returnedCompany)
  else
    return returnedCompany
  end
end

Company.register = function (company, callback)
  local existingCompanyWithSameName = Company.findBy("name", company.name)

  if existingCompanyWithSameName then
    return existingCompanyWithSameName
  else
    company.id = company.id or "NULL"

    local query = mariadb_prepare(sql, "INSERT INTO `companies` SET `id` = ?, `name` = '?', `money` = ?;", company.id, company.name, company.money)

    mariadb_async_query(sql, query, OnCompanyCreated, company, callback)
  end
end

Company.reloadAll = function ()
  InitializeCompanies()
end

function BuildCompany(company)
	return {
		id = company.id,
		name = company.name,
		money = company.money,
		addMoney = AddCompanyMoney
	}
end

function AddCompanyMoney(money)

-- Callbacks

function OnCompanyCreated(company, callback)
  local id = mariadb_get_value_index(1, 1)
  local createdCompany = { id = id, name = company.name, money = company.money, positions = { } }

  table.insert(Companies, createdCompany)

  local queryString = "INSERT INTO `company_positions` (`id`, `company_id`, `name`, `salary`, `permissions`, `clothing`) VALUES "

  for _, position in pairs(company.positions) do
    position.id = position.id or "NULL"
    position.salary = position.salary or CompaniesConfig.employeeDefaultSalary
    position.permissions = position.permissions or 1
    position.clothing = position.clothing or "{}"

    queryString = queryString.."("..position.id..","..company.id..",'"..position.name.."',"..position.salary..","..position.permissions..",'"..position.clothing.."')"
  end

  queryString = queryString..";"

  mariadb_async_query(sql, mariadb_prepare(sql, queryString), OnPositionsCreated, createdCompany, callback)
end

function OnPositionsCreated(company, callback)
  for i = 1, mariadb_get_row_count() do
    local position = mariadb_get_assoc(i)

    table.insert(company.positions, position)
  end

  callback(company)
end
