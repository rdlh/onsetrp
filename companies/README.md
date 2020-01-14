## Companies
> Please note that arguments between `[]` are optionals.

Every function should be scoped inside:
```lua
AddEvent("OnsetRP::CompaniesReady", function()
  -- code here
end)
-- or
AddRemoteEvent("OnsetRP::CompaniesReady", function()
  -- code here
end)
```
### `Company.all([callback])`
Returns all companies and positions.
*Example:*
```lua
local companies = Company.all()
-- or using a callback
Company.all(function (companies)
end)
```
### `Company.find(id, [callback])`
Returns company and positions using `id`.
*Example:*
```lua
local company = Company.find(42)
print(company.name)
-- or using a callback
Company.find(42, function (company)
    print(company.name)
end)
```
### `Company.findBy(attribute, id, [callback])`
Returns company and positions using any attribute.
*Example:*
```lua
local company = Company.findBy("name", "Police")
print(company.id)
-- or using a callback
Company.findBy("name", "Police", function (company)
    print(company.id)
end)
```
### `Company.register(company, callback)`
Create a company (if don't exists) and returns it. Only required field for `company` is `name`.
*Example:*
```lua
Company.register({
    name = "School",
    money = 2000,
    positions = {
        name = "Teacher", salary = 128, permissions = 1, clothing = "{}",
        name = "Head teacher", salary = 256, permissions = 2, clothing = "{}"
  }
}, function (company)
    print(company.id)
end)
```

## Configs
`defaultCompaniesStartingMoney`
> Default amount of money a newly created company will have.
> Default : 1000

`loadDefaultCategories`
> Generate default companies on server start if they don't exists.
> Default : true

`employeeDefaultSalary`
> Default salary for any `employee` job.
> Default : 50

`managerDefaultSalary`
> Default salary for any `manager` job.
> Default : 100

`ceoDefaultSalary`
> Default salary for any `ceo` job.
> Default : 200
