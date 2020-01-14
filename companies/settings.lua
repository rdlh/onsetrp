local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

CompaniesConfig = {
  defaultCompaniesStartingMoney = 1000,
  loadDefaultCategories = true,
  employeeDefaultSalary = 50,
  managerDefaultSalary = 100,
  ceoDefaultSalary = 200,
  allowNegativeBankAccounts = true,
  debug = false
}

-- Default companies

local defaultCompanies = {
  {
    id = 1,
    name = _("police"),
    money = 20000,
    positions = {
      { id = 1, name = _("cadet"), permissions = 1, salary = 150 },
      { id = 2, name = _("officer"), permissions = 2, salary = 180 },
      { id = 3, name = _("sergent"), permissions = 3, salary = 240 },
      { id = 4, name = _("lieutenant"), permissions = 4, salary = 300 },
      { id = 5, name = _("captain"), permissions = 5, salary = 400 }
    }
  }, {
    id = 2,
    name = _("medic"),
    money = 20000,
    positions = defaultRoles(6)
  }, {
    id = 3,
    name = _("mine"),
    money = CompaniesConfig.defaultCompaniesStartingMoney,
    positions = defaultRoles(9)
  }, {
    id = 4,
    name = _("fishing"),
    money = CompaniesConfig.defaultCompaniesStartingMoney,
    positions = defaultRoles(12)
  }, {
    id = 5,
    name = _("phone"),
    money = CompaniesConfig.defaultCompaniesStartingMoney,
    positions = defaultRoles(15)
  }, {
    id = 6,
    name = _("transport"),
    money = CompaniesConfig.defaultCompaniesStartingMoney,
    positions = defaultRoles(18)
  }, {
    id = 7,
    name = _("banking"),
    money = CompaniesConfig.defaultCompaniesStartingMoney,
    positions = defaultRoles(21)
  }
}

function GetDefaultRoles(startingId)
  { id = startingId, name = _("employee"), permissions = 1, salary = CompaniesConfig.employeeDefaultSalary },
  { id = startingId + 1, name = _("manager"), permissions = 2, salary = CompaniesConfig.managerDefaultSalary },
  { id = startingId + 2, name = _("ceo"), permissions = 3, salary = CompaniesConfig.ceoDefaultSalary }
end

function GetDefaultCompanies()
  return defaultCompanies
end
