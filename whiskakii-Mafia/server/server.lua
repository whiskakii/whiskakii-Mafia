ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('whiskakii-Mafia:sendCreationData')
AddEventHandler('whiskakii-Mafia:sendCreationData', function(creationData)
    
    local playerId = source 
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if ESX.DoesJobExist(creationData, 1) then
        xPlayer.showNotification('Criminal Job ' .. creationData .. ' already exists try another name!')
        closeMenu(xPlayer)
    else
        xPlayer.showNotification('Criminal Job ' .. creationData .. ' is free please wait some seconds!')
        startCreation(xPlayer, creationData)
    end
end)

--[[ Creation Proccess Levels ]]

--[[ Level 1 Check Player if player can buy ]]

startCreation = function(xPlayer, creationData)

    local PlayerMoney = xPlayer.getAccount(Config.Currency).money

    if PlayerMoney >= Config.Price then
        xPlayer.removeAccountMoney(Config.Currency, Config.Price)
        accountCreation(creationData, xPlayer)
    else
        xPlayer.showNotification('You dont have enough ' .. Config.CurrencyLabel .. '!')
    end

end

--[[ Level 2 Start the Creation of Accounts ]]
accountCreation = function(creationData, xPlayer)

    local society = "society_"..creationData

    MySQL.Async.execute('INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, @shared)',
        {
            ['@name'] = society,
            ['@label'] = creationData,
            ['@shared'] = 1
        }
    )

    MySQL.Async.execute('INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, @shared) ',
        {
            ['@name'] = society,
            ['@label'] = creationData,
            ['@shared'] = 1
        }
    )


    MySQL.Async.execute('INSERT INTO datastore (name, label, shared) VALUES (@name, @label, @shared) ',
        {
            ['@name'] = society,
            ['@label'] = creationData,
            ['@shared'] = 1
        }
    )


    --[[ Level 3 Adding Job Grades to DataBase ]]

    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)',
    {
        ['@job_name'] = creationData,
        ['@grade'] = "0", 
        ['@name'] = "tsiraki",
        ['@label'] = "New Blood",
        ['@salary'] = "300",
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })

    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)',
    {
        ['@job_name'] = creationData,
        ['@grade'] = "1", 
        ['@name'] = "ektelesths",
        ['@label'] = "Εκτελεστής",
        ['@salary'] = "300",
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })

    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)',
    {
        ['@job_name'] = creationData,
        ['@grade'] = "2", 
        ['@name'] = "underboss",
        ['@label'] = "Vice Boss",
        ['@salary'] = "300",
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })

    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)',
    {
        ['@job_name'] = creationData,
        ['@grade'] = "3", 
        ['@name'] = "boss",
        ['@label'] = "Drug Lord",
        ['@salary'] = "300",
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })

    --[[ last step adding job to db ]]


    MySQL.Async.execute('INSERT INTO jobs (name, label) VALUES (@name, @label)',
        {
            ['@name'] = creationData,
            ['@label'] = creationData
        }, 
        function(result)

        if result then
            refreshDB()
            Wait(500)
            setCreationJob(creationData, xPlayer)
        end
        
    end)

end

refreshDB = function()
    TriggerEvent('esx_addonaccount:refreshAccounts')
    TriggerEvent('esx:refreshJobs')
end

setCreationJob = function(creationData, xPlayer)
    
    if ESX.DoesJobExist(creationData, 3) then
        xPlayer.setJob(creationData, 3)
    else
        refreshDB()
        Wait(2000)
        xPlayer.setJob(creationData, 3)
    end

end
--[[ Client Functions ]]


closeMenu = function(xPlayer)

    TriggerClientEvent('whiskakii-Mafia:closeMenu', xPlayer.source)

end