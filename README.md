<div align="center">

# 🚀 NeoKirilX Roblox Scripts

> **"Исходники есть?"**  
> **Нет.** 😎

![Lua](https://img.shields.io/badge/Language-Lua-blue?style=for-the-badge)
![Roblox](https://img.shields.io/badge/Platform-Roblox-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![License](https://img.shields.io/badge/License-Private-orange?style=for-the-badge)

### 👑 Owner

**NeoKirilX**

📢 **Telegram:** https://telegram.me/ScriptsByNeoKirilX

⭐ Если понравился проект — поставьте Star.

</div>

---

# 📦 Поддерживаемые игры

## 💼 Hack A Business

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/KKirillPRO1000/Universall-Script-Roblox/main/hacker_game.lua"))()
```

---

## 🔪 Murder Mystery 2

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/KKirillPRO1000/Universall-Script-Roblox/main/mm2.lua"))()
```

---

## 🌍 Universal

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/KKirillPRO1000/Universall-Script-Roblox/main/script.lua"))()
```

---

# 🎨 M3 GUI Library (Open Source)

Полностью открытая библиотека интерфейса в стиле **Material Design 3**.

## Подключение

```lua
local M3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KKirillPRO1000/Universall-Script-Roblox/main/m3-lib.lua"))()
```

---

## Создание окна

```lua
local Window = M3:CreateWindow({
    Title = "My Script",
    Size = UDim2.new(0, 680, 0, 460)
})
```

---

## Создание вкладок

```lua
local Home = Window:CreateTab("Home")
local Settings = Window:CreateTab("Settings")
```

---

## Создание группы

```lua
local Group = Home:CreateGroup("Main")
```

---

## Кнопка

```lua
Group:AddButton("Hello", function()
    print("Hello World!")
end)
```

---

## Toggle

```lua
Group:AddToggle("Auto Farm", false, function(state)
    print(state)
end)
```

---

## Slider

```lua
Group:AddSlider("WalkSpeed",16,100,16,false,function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

---

## Dropdown

```lua
Group:AddDropdown(
    "Weapon",
    {"Sword","Bow","Gun"},
    "Sword",
    false,
    function(value)
        print(value)
    end
)
```

---

## Уведомление

```lua
M3:Notify({
    Title = "Success",
    Content = "Everything works!",
    Duration = 3
})
```

---

## Clipboard

```lua
M3:SetClipboard("https://roblox.com")
```

---

## Config Manager

### Namespace

```lua
M3.ScriptNamespace = "MyScript"
```

### Сохранить

```lua
M3.ConfigManager:Save("default",{
    Speed = 16,
    Farm = true
})
```

### Загрузить

```lua
local Data = M3.ConfigManager:Load("default")

if Data then
    print(Data.Speed)
end
```

---

# 😂 FAQ

### Где исходный код читов?

```lua
print("Access Denied")
```

---

### Можно купить исходники?

❌ Нет.

---

### Можно получить их бесплатно?

🤣

---

### Я открыл Dex Explorer.

Поздравляем.

Исходников там всё ещё нет.

---

### Я умею декомпилировать.

Именно поэтому они закрыты. 😎

---

### Можно сделать Fork?

Конечно.

Только исходники от этого не появятся.

---

# ❤️ Open Source

| Проект | Статус |
|---------|--------|
| M3 GUI Library | ✅ Open Source |
| Universal Script | 🔒 Closed Source |
| Hack A Business | 🔒 Closed Source |
| Murder Mystery 2 | 🔒 Closed Source |

---

# ⭐ Поддержка

Если вам понравились мои проекты:

⭐ Поставьте Star этому репозиторию.

📢 Подписывайтесь на Telegram:

## https://telegram.me/ScriptsByNeoKirilX

---

<div align="center">

## Спасибо за использование ❤️

> Пока кто-то ищет исходники...
>
> Ты уже играешь. 😎

**Made with ☕ Lua & бессонными ночами**

</div>
