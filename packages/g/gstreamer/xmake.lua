package("gstreamer")
    set_homepage("https://gstreamer.freedesktop.org/")
    set_description("GStreamer open-source multimedia framework")
    set_license("LGPL-2.0")

    add_urls("https://gitlab.freedesktop.org/gstreamer/gstreamer.git")
    add_versions("2022.09.15", "de2fa78ebb431db98489e78603e4f77c1f6c5c57")

    -- Gstreamer ranks its plugins according to different criteria, more information here:
    -- https://gitlab.freedesktop.org/gstreamer/gstreamer/-/tree/main/subprojects/gst-plugins-base#the-lowdown
    add_configs("base",  {description = "Enable base plugins.", default = true, type = "boolean"})
    add_configs("good",  {description = "Enable good plugins.", default = true, type = "boolean"})
    add_configs("ugly",  {description = "Enable ugly plugins.", default = true, type = "boolean"})
    add_configs("bad",  {description = "Enable bad plugins.", default = true, type = "boolean"})

    add_configs("libav",  {description = "Enable libav (ffmpeg) support.", default = true, type = "boolean"})
    add_configs("qt5",  {description = "Enable Qt5 support.", default = false, type = "boolean"})


    on_load(function (package)
        if package:config("qt5") then
            package:add("deps","qt5core", "qt5gui")
        end

        if package:config("libav") then
            package:add("deps", "ffmpeg")
        end
    end)

    on_install(function (package) 
        
    end)
