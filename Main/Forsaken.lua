-- sentinel_loader.lua
-- Mapeia nomes para URLs e processa _G.LoadSentinel.
-- Por segurança: por padrão apenas mostra o que seria carregado (dry-run).
-- Para realmente buscar/executar, defina _G.SentinelAllowRemoteExecution = true
-- e implemente fetchFunc(url) conforme seu ambiente (game:HttpGet, syn.request, etc).

local map = {
  Chance     = "https://raw.githubusercontent.com/StarlessScripts/Null-MNR/main/Forsaken/Chance.lua",
  Veeronica  = "https://raw.githubusercontent.com/StarlessScripts/Null-MNR/main/Forsaken/Veeronica.lua",
  TwoTime    = "https://raw.githubusercontent.com/StarlessScripts/Null-MNR/main/Forsaken/TwoTime.lua",
  Shedletsky = "https://raw.githubusercontent.com/StarlessScripts/Null-MNR/main/Forsaken/Shedletsky.lua",
  Guest1337  = "https://raw.githubusercontent.com/StarlessScripts/Null-MNR/main/Forsaken/Guest1337.lua",
}

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function split_names(s)
  if not s or s == "" then return {} end
  local out = {}
  for part in s:gmatch("[^,]+") do
    local name = trim(part)
    if name ~= "" then table.insert(out, name) end
  end
  return out
end

-- Dry-run: mostra o que seria carregado
local function dry_run(names)
  for _, name in ipairs(names) do
    local url = map[name]
    if url then
      print(("[Sentinel Loader] would load %s -> %s"):format(name, url))
    else
      warn(("[Sentinel Loader] unknown entry: %s"):format(name))
    end
  end
end

-- Função que faria o fetch + execução. DEIXADA COMENTADA POR SEGURANÇA.
-- Se você optar por ativar, substitua fetchFunc por sua função de HTTP (game:HttpGet, syn.request, etc)
-- e defina _G.SentinelAllowRemoteExecution = true antes de executar este arquivo.
local function fetch_and_run(names)
  if not _G.SentinelAllowRemoteExecution then
    error("Remote execution is disabled. Set _G.SentinelAllowRemoteExecution = true to enable.")
  end

  -- Exemplo de fetchFunc (não ativa aqui):
  -- local function fetchFunc(url)
  --   -- Ex.: return game:HttpGet(url)
  --   -- ou usar syn.request({ Url = url }).Body
  -- end

  for _, name in ipairs(names) do
    local url = map[name]
    if url then
      print(("[Sentinel Loader] fetching %s from %s"):format(name, url))
      -- local code = fetchFunc(url)
      -- if code then
      --   local f, err = loadstring(code)
      --   if f then
      --     local ok, runErr = pcall(f)
      --     if not ok then
      --       warn(("Error running %s: %s"):format(name, tostring(runErr)))
      --     end
      --   else
      --     warn(("loadstring error for %s: %s"):format(name, tostring(err)))
      --   end
      -- else
      --   warn(("Failed to fetch %s"):format(url))
      -- end
    else
      warn(("[Sentinel Loader] unknown entry: %s"):format(name))
    end
  end
end

-- Entrada principal
local raw = _G.LoadSentinel or ""
local names = split_names(raw)

if #names == 0 then
  print("[Sentinel Loader] _G.LoadSentinel vazio ou não definido. Nothing to do.")
  return
end

-- Por padrão só dry-run
dry_run(names)

-- Para permitir execução remota, ative explicitamente e chame fetch_and_run:
-- _G.SentinelAllowRemoteExecution = true
-- fetch_and_run(names)
