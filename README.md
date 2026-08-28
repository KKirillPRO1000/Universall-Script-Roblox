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

Окно появляется с мягкой анимацией «разворачивания из центра». Скрытие/показ тоже анимированные.


```lua
local Window = M3:CreateWindow({
    Title = "My Script",
    Size = UDim2.new(0, 680, 0, 460)
})
```


---


## Создание вкладок

Можно добавлять иконки — **слева от текста** (см. раздел «Картинки/иконки» ниже).


```lua
local Home = Window:CreateTab("Home", "home")
local Settings = Window:CreateTab("Settings", "cog")
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


## MD3 Switch (переключатель)

MD3-переключатель с треком и ползунком. Иконки внутри (✓/✕) включаются флагом `WithIcon`, отключение — `Enabled`.


```lua
-- С иконками ✓/✕
Group:AddSwitch("Тёмная тема", { Default = false, WithIcon = true, Callback = function(on) end })

-- Без иконок
Group:AddSwitch("Wi-Fi", { Default = true, WithIcon = false })

-- Заблокирован
Group:AddSwitch("Недоступно", { Default = false, Enabled = false })

-- Старый формат: (text, defaultState, callback)
Group:AddSwitch("Автозапуск", true, function(on) end)
```


---


## Slider — все 4 стиля MD3

Универсальный `AddSlider` поддерживает **Continuous / Discrete / Centered / Range** через опции.

```lua
-- Непрерывный (громкость, яркость) — плавный
Group:AddSlider("Громкость", {
    Min = 0, Max = 100, Value = 50, Style = "Continuous", Callback = function(v) end
})

-- Дискретный (тики + всплывающая метка, фиксация на шаге)
Group:AddSlider("Размер шрифта", {
    Min = 1, Max = 5, Value = 3, Style = "Discrete", Step = 1, Callback = function(v) end
})

-- Центрированный (ноль в центре, +/−)
Group:AddSlider("Баланс", {
    Min = -10, Max = 10, Value = 0, Style = "Centered", Step = 1, Callback = function(v) end
})

-- Диапазон (два ползунка «от и до»)
Group:AddSlider("Цена", {
    Min = 0, Max = 100, Value = {20, 80}, Style = "Range", Step = 5,
    Callback = function(lo, hi) end
})

-- Точный (2 знака после запятой)
Group:AddSlider("Значение", {
    Min = 0, Max = 1, Value = 0.5, Precise = true, Callback = function(v) end
})
```

Каждый слайдер возвращает `{ GetValue(), SetValue(v) }`.


---


## Dropdown


```lua
Group:AddDropdown(
    "Weapon",
    {"Sword","Bow","Gun"},
    "Sword",
    false,          -- multiSelect
    function(value)
        print(value)
    end
)
```


---


## Уведомление (Dynamic Island)

Уведомление появляется из правого нижнего угла, **таймер по умолчанию — 5 секунд**, **картинка по умолчанию — колокольчик**, если иконка не указана. Прогресс-бар внизу показывает оставшееся время, пауза при наведении, можно свайпнуть (вправо/вниз).


```lua
-- Без параметров: 5 секунд + иконка-колокольчик по умолчанию
M3:Notify({ Title = "Успех", Content = "Всё работает!" })

-- Своё время (мс) и иконка
M3:Notify({
    Title = "Сообщение",
    Content = "Новое входящее сообщение",
    Duration = 5000,        -- миллисекунды; 0 = не скрывать
    Icon = "bell",          -- иконка, см. раздел «Картинки»
    Buttons = { { Text = "Открыть", Callback = function() end } }
})
```

> ⚠️ **Важно:** `Duration` теперь в **миллисекундах** (не секундах). `Duration = 3` → 3 мс (мгновенно исчезнет). Используйте `3000` для 3 секунд.


---


## Загрузочный экран

Красивый полноэкранный оверлей со спиннером, статусом и прогресс-баром — удобно показывать, пока грузятся иконки/картинки.


```lua
local Loading = M3:ShowLoading("My Script")

-- предзагрузка иконок (прогресс растёт)
loading:SetProgress(0.5, "Загрузка иконок...")

-- когда всё готово
Loading:Destroy()
```


---


## Защита от повторного запуска

Если скрипт уже работает — появится диалог: **Отмена / Запустить отдельно / Удалить старый и запустить**.


```lua
M3.EnsureSingleInstance("My Script", function(proceed)
    if not proceed then return end
    -- ...весь код скрипта...
end)
```


---


## Картинки и иконки

Иконки загружаются функцией `M3:LoadIcon(...)`. Она понимает **4 формата** и кэширует результат на сессию:

| Формат | Пример | Как работает |
|--------|--------|--------------|
| **Имя MD3-иконки** | `M3:LoadIcon("cog")` | скачивает PNG из Material Design Icons (пробует 2 зеркала), сохраняет через `writefile`, превращает в ассет `getcustomasset` |
| **rbxassetid** | `M3:LoadIcon("rbxassetid://12345")` | возвращается как есть |
| **Число (id)** | `M3:LoadIcon(12345)` | превращается в `rbxassetid://12345` |
| **Полный URL** | `M3:LoadIcon("https://.../img.png")` | скачивает PNG по ссылке и кэширует как ассет |

Если что-то не загрузилось — возвращает `""` (иконка просто не показывается, всё продолжает работать).


### Примеры использования иконок

```lua
-- Вкладка с иконкой по имени
Window:CreateTab("Настройки", "cog")

-- Вкладка по asset id
Window:CreateTab("Дом", 4483362458)

-- Уведомление с иконкой-колокольчиком (и по умолчанию тоже)
M3:Notify({ Title = "Оповещение", Content = "Hi!", Icon = "bell" })

-- Уведомление с иконкой по прямой ссылке
M3:Notify({ Title = "Профиль", Content = "Новая аватарка", Icon = "https://.../avatar.png" })

-- Получить ссылку на ассет вручную
local img = M3:LoadIcon("home")  -- "getcustomasset(...)" или "rbxassetid://..."
```

Популярные имена MD3-иконок: `home`, `cog`, `settings`, `bell`, `close`, `check`, `heart`, `account`, `search`, `palette`, `tune`, `link`, `window`, `notifications`.


---


## Анимации окна

- Появление при создании — разворачивание из центра (`AnimateIn = false` — отключить).
- `Window:SetVisible(true/false)` — плавное появление/скрытие.
- `Window:GetVisible()` — текущее состояние видимости.


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
