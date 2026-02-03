Config = {}

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

Config.Notifications = {
    reportSubmitted = {
        title = "Report Submitted",
        message = "Your report has been submitted successfully",
        type = "success"
    },
    permissionDenied = {
        title = "Permission Denied",
        message = "You do not have permission to use this command",
        type = "error"
    },
    playerBrought = {
        title = "Success",
        message = "Player brought to you",
        type = "success"
    },
    playerTeleported = {
        title = "Teleported",
        message = "Teleported to player",
        type = "success"
    },
    playerFrozen = {
        title = "Success",
        message = "Player frozen",
        type = "success"
    },
    playerUnfrozen = {
        title = "Success",
        message = "Player unfrozen",
        type = "success"
    },
    playerNotOnline = {
        title = "Error",
        message = "Player is not online",
        type = "error"
    },
    reportNotFound = {
        title = "Error",
        message = "Report not found",
        type = "error"
    }
}
