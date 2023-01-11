leaf = require 'leaf_core'

local CLVSVER = '1.0.0'
local discord = require('discordia')
local dclovis = discord.Client()
local json    = require('json')

-- Global ident --
local GLD
local QWN = "rainha"
local quin
local MOD = "manutenção"
local modr
local DEV = "dev"
local devr

local default

-- Rule breaks --
local RBK = {
    -- def --
    ['0000'] = 'se recuzou à obedecer',

    -- regra 1 --
    ['1101'] = 'desrespeito com os demais',
    ['1102'] = 'desrespeito com os moderadores',

    ['1201'] = 'causando intrigas',
    ['1202'] = 'participando de intrigas',

    ['1300'] = 'palavreado impróprio',

    -- regra 2 --
    ['2111'] = 'mensagem de conteúdo impróprio (político)',
    ['2112'] = 'mensagem de conteúdo impróprio (sexual)',
    ['2113'] = 'mensagem de conteúdo impróprio (gore)',

    ['2121'] = 'compartilhamento de imagem(ns) com conteúdo impróprio (político)',
    ['2122'] = 'compartilhamento de imagem(ns) com conteúdo impróprio (sexual)',
    ['2123'] = 'compartilhamento de imagem(ns) com conteúdo impróprio (gore)',

    ['2132'] = 'nome de usuário com conteúdo impróprio (sexual)',
    ['2133'] = 'nome de usuário com conteúdo impróprio (gore)',

    ['2142'] = 'foto de perfil com conteúdo impróprio (sexual)',
    ['2143'] = 'foto de perfil com conteúdo impróprio (gore)',

    ['2152'] = 'jogando/status impróprio (conteúdo sexual)',
    ['2153'] = 'jogando/status impróprio (conteúdo gore)',

    ['2200'] = 'divulgação de informações pessoais de outros sem autorização',
    ['2300'] = 'chamando a atenção dos outros usuários na presença da moderação',

    -- regra 3 --
    ['3111'] = 'flood de mensagens',
    ['3112'] = 'flood de imagens',

    ['3121'] = 'spam de mensagens',
    ['3122'] = 'spam de imagens',

    ['3201'] = 'destaque de mensagens',
    ['3202'] = 'uso exagerado do riscado',
    ['3300'] = 'falando em outras línguas exageradamente',

    ['4101'] = 'exploração de brechas das regras',
    ['4102'] = 'tentativa de exploração de brechas nas regras',

    ['4201'] = 'desafiando a autoridade da moderação',
    ['4202'] = 'discordando/reclamando das regras/punições',

    ['666'] = 'raid',
    ['001'] = 'teste em nome da ciência'
}

-- default messages --
local DEF = {
    ['?']     = {mod = "fala, chefia?", def = "oiee"},
    ['!666']  = 'reason: ' .. RBK['666'],
    ['!ping'] = "pong",
    ['!ver' ] = "clovis foi mutado até a versão " .. CLVSVER,
}

function get_reason(ebk_id)
    if not ebk_id then return "unspecified" end

    local err = ebk_id:split('%-')
    if type(err) == 'string' then return RBK[err]
    else
        local out = ''
        for _, e in pairs(err) do

            out = out .. (RBK[e] or 'UNKNOWN') ..', '
        end
        return out:sub(1, -3)
    end
end

function waitfor(time, func)

    local tthen = os.time()
    while true do
        -- wait for seconds --
        if os.time() >= tthen + time then
            func()
            break
        end
    end
end

local now
function puts(str)
    now = os.time()
    local data = '\n' .. os.date('!%d/%m/%Y %H:%M:%S', now) .. ' | ' .. str

    print(data)
    local file = io.open('clovis.log', 'a+')

    if not file then return end

    file:write(data)
    file:close()
end

function save(name, data)
    meta = json.encode(data)

    -- write it on file --
    local file = io.open(name .. '.json', 'w')

    if not file then return end

    file:write(meta)
    file:close()

    puts(name .. 'is pretty stored')
end

function load(name)

    if io.open(name .. '.json') then

        return json.decode(name .. '.json') or {}

    else return {} end
end

--#---------------------------------------------------------#--

-- on login --
dclovis:on('ready', function()

    puts('clovis has entered the crossnet')

    urlshrt = load('url-short')

    -- guild and Radio --
    GLD     = dclovis:getGuild('669512689214816275')
    default = dclovis:getChannel('669512689214816278')

    -- get main roles by id --
    for id in GLD.roles:__pairs() do

        local role = GLD:getRole(id)

        if role.name == QWN then quin = role
        elseif role.name == MOD then modr = role
        elseif role.name == DEV then devr = role end
    end

    math.randomseed(os.time())
end)

function logout()
    save('url-short', urlshrt)

    puts('clovis is sleeping now')
    dclovis:stop()
end

-- welcome --
dclovis:on('memberJoin', function(member)

    local hello = {
        "bem vinde, <@!" .. (member.id) .. ">! \\:D\naproveite sua estadia na terra das gélidas de demoland",
        "ni hao, <@!" .. (member.id) .. ">, obrigado por entrar!",
        "gut ha, <@!" .. (member.id) .. ">!",
        "ora, hora, bora, quora. vejam só quem chegou! bem vinde, <@!<" .. (member.id) .. ">"
    }
    default:send(hello[math.random(1, #hello)]
    ..' e mas não se esqueça de ler as regras no <#672769067475533834>.');
end)

-- on recive message --
dclovis:on('messageCreate', function(message)

    local msg = message.content
    local ismod
    local isbot
    if message.member then
        ismod = message.member:hasRole(quin.id)
        or message.member:hasRole(modr.id)

        isbot = message.member.user.bot
    end

    if msg:lower():find('bolsonaro') and not isbot then
        message:reply('bolsonaro é um otário!')
    end

--# logout -------------------------------------------------#--

    -- start --
    if msg == '!tchau' then
        if ismod then
            logout()
            message.channel:send('done')
        else
            message:reply('epepepe pare aí. só minha rainha me põe pra dormir')
            puts('[warning] ' .. message.author.name .. ' tried to dope clovis')
        end
    end

--# development --------------------------------------------#--

    if msg:startswith('!log') then
        if message.member:hasRole(quin.id) then

            puts(msg:gsub('!log ', '')
            .. ' | puts required by: ' .. message.author.name)
        else
            message:reply('epepepe pare aí. tu não pode usar o meu log não')
            puts('[warning] ' .. message.author.name .. ' tried to use log internally')
        end
    end

    if msg:startswith('!rep') then
        if message.member:hasRole(quin.id) or message.member:hasRole(devr.id) then

            local del = message.channel:getMessages(1)
            message.channel:bulkDelete(del)

            message:reply(message.content:gsub('!rep ', ''))
        else
            message:reply('epepepe pare aí. não vou te obedecer nem que a vaca tuça')
            puts('[warning] ' .. message.author.name .. ' tried to use `!rep`')
        end
    end

--# server management --------------------------------------#--

    if msg:startswith('!cls') then
        if ismod then
            local num = tonumber(msg:match('!cls (%d+)'))
            if not num then
                message:reply('cannot delete [non numerial value] messages')
            else
                local del = message.channel:getMessages(num + 1)
                message.channel:bulkDelete(del)

                puts('deleted ' .. (num) .. ' messages at ' .. message.channel.name)
            end
        else
            message:reply('you are not allowed to delete messages')
            puts('[warning] ' .. message.author.name .. ' tried to delete messages')
        end
    end

    if msg:startswith('!radd') then
        if ismod then
            local mnbr = message.mentionedUsers.first
            local role = message.mentionedRoles.first

            -- values not found --
            if not mnbr then message:reply('nenhum membro foi mencionado')
            elseif not role then message:reply('nenhum cargo foi mencionado')
            else
                if role.id == quin.id then
                    message:reply('apenas uma rainha. Nem mais, nem menos')
                else
                    mnbr = GLD:getMember(mnbr)
                    mnbr:addRole(role.id)

                    puts('added ' .. role.name .. ' role to ' .. mnbr.name)
                    message:reply('prontinho')
                end
            end
        else
            message:reply('epepepe pera aí. tu não pode moderar cargos não')
            puts('[warning] ' .. message.author.name .. ' tried to add roles')
        end
    end

    if msg:startswith('!rrem') then

        if ismod then
            local mnbr = message.mentionedUsers.first
            local role = message.mentionedRoles.first

            -- values not found --
            if not mnbr then message:reply('nenhum membro foi mencionado')
            elseif not role then message:reply('nenhum cargo foi mencionado')
            else
                mnbr = GLD:getMember(mnbr)
                mnbr:removeRole(role.id)

                puts('removed ' .. role.name .. ' role from ' .. mnbr.name)
            end
        else
            message:reply('epepepe pera aí. Tu não pode usar esse comando não')
            puts('[warning] ' .. message.author.name .. ' tried to remove roles')
        end
    end

    if msg:match('!kick') then
        if ismod then
            local mnbr = message.mentionedUsers.first
            local reas = msg:match('!kick%s+%<@%!?%d+%>%s+([%d-]+)')

            if not reas then
                message:reply('razão não expecificada')
                return -1
            -- get reason based on given number
            else reas = get_reason(reas) end

            -- values not found --
            if not mnbr then message:reply('nenhum membro foi mencionado')
            else
                mnbr = GLD:getMember(mnbr)
                GLD:kickUser(mnbr.id, reas)

                puts(mnbr.name .. ' has been kicked by ' .. message.author.name)
            end
        else
            message:reply('epepepe pera aí. tu não pode chutar usuários não')
            puts('[warning] ' .. message.author.name .. ' tried to kick users')
        end
    end

    if msg:match('!ban') then
        if ismod then
            local mnbr = message.mentionedUsers.first
            local reas, days = msg:match('t!ban%s+<@%d+>%s+([%d-]+)%s+(%d*)')

            if not reas then
                message:reply('razão não expecificada')
                return -1
            -- get reason based on given number
            else reas = get_reason(reas) end

            -- no arg specified --
            if days == '' then days = nil end

            -- Values not found --
            if not mnbr then message.channel:send('nenhum membro foi mencionado')
            else
                mnbr = GLD:getMember(mnbr)
                GLD:banUser(mnbr.id, reas, days)

                puts(mnbr.name .. ' has been hammered by ' .. message.author.name)
            end
        else
            message:reply('epepepe pera aí. tu não pode martelar usuários não')
            puts('[warning] ' .. message.author.name .. ' tried to hammer users')
        end
    end

--# pins ---------------------------------------------------#--

    if msg:startswith('!pin ') then

        if ismod then
            local del = message.channel:getMessages(1)
            message.channel:bulkDelete(del)

            message.channel:send('[internal-opp!pin]'
            .. msg:gsub('t!pin ', ''))
        else
            message:reply('epepepe pera aí. tu não pode fixar mensagens não')
            puts('[warning] ' .. message.author.name .. ' tried to pin messages')
        end
    end

    if msg:startswith('[internal-opp!pin]') then

        if isbot then
            message:setContent(msg:gsub('%[internal!opp%-pin%]', ''));
            message:pin()

            puts("pinned message [" .. (message.id) .. '] at ' .. message.channel.name)
        else
            message:reply('epepepe pare aí. essa magia é proibida para meros mortais')
            puts('[warning] ' .. message.author.name .. ' tried to use internal tags')
        end
    end

    if msg:match('!edit %d-%s-|%s-.+') then

        if ismod then
            local indx = {}
            indx[1], indx[2] = msg:match('t!edit (%d-)%s-|%s-(.+)')
            indx[1] = tostring(indx[1])

            local del = message.channel:getMessages(1)
            message.channel:bulkDelete(del)

            local edit = message.channel:getMessage(indx[1])
            edit:setContent(indx[2])

            puts('message [' .. indx[1] .. '] was edited by '
            .. message.author.name)
        else
            message:reply('tu não pode editar as minha mensagem não, rapaz')
            puts('[warning] ' .. message.author.name .. ' tried to edit thomson\'s messages')
        end
    end

--# Main chunk ---------------------------------------------#--

    -- RPG dices --
    if msg:match('!%s-%d-%#?%d-d%d+%s-[-+]?%s-%d-%s-:?.*') then

        local rep, cnt, dnm, pls, tag = msg:match('!%s-(%d-)%#?(%d-)d(%d+)%s*([-+]?%s-%d-)%s-(:?.*)')

        if tag ~= "" then tag = " #" .. tag end

        -- fix values --
        if cnt == '' then cnt = 1
        else cnt = tonumber(cnt) end    

        if rep == '' then rep = 1
        else rep = tonumber(rep) end    

        if dnm == '' then dnm = 1
        else dnm = tonumber(dnm) end    

        local output        
        -- set message prefix --
        if cnt > 1 then
            output = '<@' .. (message.author.id)
            .. '> rolou ' .. (cnt) .. ' dados de ' .. (dnm) .. ' lado(s):' .. tag .. "\n"
        else
            output = '<@' .. message.author.id
            .. '> rolou um dado de ' .. (dnm) .. ' lado(s):\n'
        end

        -- loop for each time --
        for i = 0, rep - 1 do
            -- smartass --
            if cnt * dnm > 666 then
                message.channel:send('<@!' .. message.author.id
                .. '> deu uma de espertão e tentou rolar um dado gigante. Falhou miseravelmente')
                break
            else
                if rep > 1 then
                    output = output .. "> #" .. (i) .. " "
                end
                local total = 0
                local dice  = {}

                for n = 1, cnt do
                    local num = math.random(1, dnm or 1)

                    total = total + num
                    dice[n] = tostring(num)
                end

                if pls ~= '' then
                    local sig, num = pls:match('([+-])%s*(%d+)')
                    pls = sig .. num

                    total = total + tonumber(pls)
                    pls = ' ' .. sig .. ' ' .. num
                end

                die = '[' .. table.concat(dice, ', ') .. ']'
                output = output .. die .. pls .. ' = ' .. (total)

                if i < rep - 1 then output = output .. "\n" end
            end
        end
        message.channel:send(output)
    end

    if msg:match('clovis,.-desce um[a]?%s-.-[,]?.-') then
        local addps = {
            "no capricho", "trincando", "chefia"
        }
        local pronm, drink = msg:match('clovis,.-desce (um[a]?)%s-([^,]+).*')
        drink = drink:strip()

        message:reply(('saindo %s %s %s'):format(pronm, drink, addps[math.random(1, #addps)]))
    end

    -- default messages --
    for m, r in pairs(DEF) do
        if msg:startswith(m) then
            if type(r) == 'table' then
                if ismod then message.channel:send(r.mod)
                else message.channel:send(r.def) end

            else message.channel:send(r) end
            break
        end
    end
end)

dclovis:run(io.open('clovis.id'):read())
