Free Open source Do not redistribute or resell without permission.
Preview 
# Simple / simple Report Menu

A **clean, lightweight report menu** for FiveM that’s **easy to configure**, **powerful**, and **secure**. Built for servers that want **Discord role–based permissions** without bloat.

> Plug-and-play for small servers, scalable for large ones.

---

## ✨ Features

* 🔐 **Discord Role Permissions** (no Ace spam)
* ⚡ **Super Easy Config** (edit one file)
* 🧭 **Clean UI** (simple & fast)
* 🛠️ **Advanced Admin Tools**
* 🧠 **Optimized / Low Resmon**
* 🔄 **Live Permission Sync** (no restart needed)
* 🧩 **Framework Agnostic** (ESX / QBCore / Standalone)

---

## 🔗 Discord Role Permissions

Permissions are handled **entirely through Discord roles**.
No in-game admin groups required.

### Example Role Setup

```lua
Config.Discord = {
    enabled = true,
    botToken = "",
    guildId = "",
    adminRoleId = ""
}

Config.DiscordPermissions = {
    enabled = true,
    adminRoleId = ""
}
```

✅ Add or remove permissions in seconds

---

## ⚙️ Installation

1. Drag the resource into your `resources` folder

2. Ensure it in your `server.cfg`



```cfg
ensure JDV2reportmenu
```

3. Set your **Discord Bot Token** & **Guild ID** in `config.lua`

```lua
Config.DiscordBotToken = "YOUR_BOT_TOKEN"
Config.DiscordGuildId = "YOUR_GUILD_ID"
```

4. Restart your server

---

## 🧠 Configuration

Everything is controlled from **one config file**:

* Discord roles
* Permission flags
* Menu keybind

No database edits required.

---

## ⌨️ Keybinds

Default:

```text
/report to make a report 
/reports to open reports
```

Change anytime in `config.lua`.

---

## 📊 Performance

* Idle: **0.00–0.01ms**
* Menu Open: **~0.02ms**

Fully optimized. No loops running when unused.

---

## 🛡️ Security

* Server-side permission checks
* Discord role validation
* Anti-trigger protection
* No client-trusted actions

---

## 📦 Dependencies

* **Discord Bot** (required)
* **oxmysql** (optional, only if storage)

---

## 🧪 Tested On

* ESX Legacy
* QBCore
* Standalone
* OneSync Infinity

---

## 🆘 Support

If you run into issues:

* Double-check your **role IDs**
* Make sure the bot is **in your Discord**
* Ensure the bot has **Server Members Intent** enabled
* If you run into any problems feel free to join the discord https://discord.gg/mf4juGerDc
---

## 📜 License

This resource is protected.
Do not redistribute or resell without permission.

---

### 🚀 Simple to use. Advanced where it matters.
