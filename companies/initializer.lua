Companies = { }
CompanyPositions = { }

AddEvent("database:connected", InitializeCompanies)

function InitializeCompanies()
  Companies = {}

  CreateDefaultCompaniesIfNeeded(function ()
    mariadb_query(sql, "SELECT * FROM companies;", function()
      for i = 1, mariadb_get_row_count() do
        local company = mariadb_get_assoc(i)
        local id = tonumber(company['id'])

        print("OnsetRP::Companies → Loaded "..company['name'])

        table.insert(Companies, {
          id = id,
          name = company['name'],
          money = money,
          positions = { }
        })
      end

      mariadb_query(sql, "SELECT * FROM company_positions;", function()
        for i = 1, mariadb_get_row_count() do
          local companyPosition = mariadb_get_assoc(i)
          local company = Company.find(companyPosition['company_id'])

          print("OnsetRP::Companies → Loaded position "..companyPosition['name'].." for "..company['name'])

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
  end)
end

-- function CreateDefaultCompaniesIfNeeded(callback)
--   if CompaniesConfig.loadDefaultCategories then
--     for _, company in pairs(GetDefaultCompanies()) do
--       company.money = company.money or CompaniesConfig.companiesStartingMoney

--       local query = mariadb_prepare(sql, "INSERT IGNORE INTO `companies` SET `id` = ?, `name` = '?', `money` = ?;", company.id, company.name, company.money)

--       mariadb_async_query(sql, query, CreatePositionsForCompany, company, callback)
--     end
--   end
-- end
--
-- function CreatePositionsForCompany(company, callback)
--   company.positions = company.positions or { id = "NULL", name = _("employee"), permissions = 1, salary = CompaniesConfig.employeeDefaultSalary }

--   local queryString = "INSERT IGNORE INTO `company_positions` (`id`, `company_id`, `name`, `salary`, `permissions`, `clothing`) VALUES "

--   for _, position in pairs(company.positions) do
--     position.salary = position.salary or CompaniesConfig.employeeDefaultSalary
--     position.permissions = position.permissions or 1
--     position.clothing = position.clothing or "{}"

--     queryString = queryString.."("..position.id..","..company.id..",'"..position.name.."',"..position.salary..","..position.permissions..",'"..position.clothing.."')"
--   end

--   queryString = queryString..";"

--   mariadb_async_query(sql, mariadb_prepare(sql, queryString), callback)
-- end
