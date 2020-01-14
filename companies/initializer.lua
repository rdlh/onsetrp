Companies = { }
CompanyPositions = { }

AddEvent("database:connected", function ()
  InitializeCompanies()
end)

function InitializeCompanies()
  Companies = {}

  CreateDefaultCompaniesIfNeeded()

    mariadb_query(sql, "SELECT * FROM companies;", function()
      for i = 1, mariadb_get_row_count() do
        local company = mariadb_get_assoc(i)
        local id = tonumber(company['id'])
        local money = tonumber(company['money'])

        print("OnsetRP::Companies → Loaded \""..company['name'].."\"")

        local company = CompanyClass.new(id, company['name'], money)

        table.insert(Companies, company)
      end

      mariadb_query(sql, "SELECT * FROM company_positions;", function()
        for i = 1, mariadb_get_row_count() do
          local companyPosition = mariadb_get_assoc(i)
          local company = Company.find(companyPosition['company_id'])

          print("OnsetRP::Companies → Loaded position \""..companyPosition['name'].."\" for \""..company['name'].."\"")

          table.insert(company.positions, {
            id = tonumber(companyPosition['id']),
            name = companyPosition['name'],
            salary = tonumber(companyPosition['salary']),
            permissions = tonumber(companyPosition['permissions']),
            clothing = companyPosition['clothing']
          })
        end

        CallEvent("OnsetRP::CompaniesReady")
        CallRemoveEvent("OnsetRP::CompaniesReady")
      end)
    end)
end

function CreateDefaultCompaniesIfNeeded()
  if CompaniesConfig.loadDefaultCategories then
    local queryOptions = { }
    local queryString = "INSERT IGNORE INTO `companies` (`id`, `name`, `money`) VALUES "

    for _, company in pairs(DefaultCompanies) do
      company.money = company.money or CompaniesConfig.companiesStartingMoney
    
      table.insert(queryOptions, "("..company.id..",'"..company.name.."',"..company.money..")")
    end

    queryString = queryString..table.concat(queryOptions, ",")..";"

    local query = mariadb_prepare(sql, queryString)
    
    mariadb_async_query(sql, query, CreatePositionsForCompany)
  end
end

function CreatePositionsForCompany()
  for _, company in pairs(DefaultCompanies) do
    company.positions = company.positions or { id = "NULL", name = _("employee"), permissions = 1, salary = CompaniesConfig.employeeDefaultSalary }
    local queryOptions = { }
    local queryString = "INSERT IGNORE INTO `company_positions` (`id`, `company_id`, `name`, `salary`, `permissions`, `clothing`) VALUES "
    
    for _, position in pairs(company.positions) do
      position.salary = position.salary or CompaniesConfig.employeeDefaultSalary
      position.permissions = position.permissions or 1
      position.clothing = position.clothing or "{}"
      
      table.insert(queryOptions, "("..position.id..","..company.id..",'"..position.name.."',"..position.salary..","..position.permissions..",'"..position.clothing.."')")
    end
    
    queryString = queryString..table.concat(queryOptions, ",")..";"
    
    mariadb_async_query(sql, queryString, function ()
    end)
  end
end
