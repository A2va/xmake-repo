package("libfreenect")
    set_homepage("https://github.com/OpenKinect/libfreenect")
    set_description("Drivers and libraries for the Xbox Kinect device on Windows, Linux, and OS X")
    set_license("GPL-2.0")

    add_urls("https://github.com/OpenKinect/libfreenect.git")
    add_versions("v0.7.0", "0f8d11ec594c36ea9f7399ddeedf5beb4175d084")

    add_deps("cmake", "libusb")

    add_configs("opencv", { description = "Enable Opencv wrapper.", default = false, type = "boolean"})
    add_configs("sync_api", { description = "Enable c synchronous library.", default = true, type = "boolean"})


    if is_plat("linux") then
        add_syslinks("pthread")
    elseif is_plat("macosx") then
        add_frameworks("CoreMedia", "CoreFoundation", "CoreVideo", "Foundation", "IOKit", "ImageIO", "VideoToolbox")
    end

    on_load(function (package)
        if package:config("opencv") then
            package:add("deps", "opencv")
        end
        if package:config("sync_api") and package:is_plat("windows") then
            package:add("deps", "pthreads4w")
        end
    end)

    on_install("windows", "linux", "macosx", function (package)
        io.replace("wrappers/c_sync/CMakeLists.txt", "find_package(Threads REQUIRED)", "", {plain = true})
        io.replace("CMakeLists.txt", "find_package(libusb-1.0 REQUIRED)", "", {plain = true})

        local configs = {}
        table.insert(configs, "-DBUILD_EXAMPLES=OFF")
        table.insert(configs, "-DBUILD_CV=" .. (package:config("opencv") and "ON" or "OFF"))
        table.insert(configs, "-DBUILD_C_SYNC=" .. (package:config("sync_api") and "ON" or "OFF"))
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

        if package:config("pic") ~= false then
            table.insert(configs, "-DCMAKE_POSITION_INDEPENDENT_CODE=ON")
        end

        local shflags
        if package:is_plat("macosx") then
            shflags = "-framework IOKit"
        end

        local packagedeps = {"libusb"}
        if package:config("sync_api") and package:is_plat("windows") then
            table.insert(packagedeps, "pthreads4w")
        end

        import("package.tools.cmake").install(package, configs, {packagedeps = packagedeps, shflags = shflags})
    end)