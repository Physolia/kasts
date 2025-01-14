# SPDX-FileCopyrightText: 2020 Tobias Fella <tobias.fella@kde.org>
# SPDX-FileCopyrightText: 2023 Bart De Vries <bart@mogwai.be>
# SPDX-License-Identifier: BSD-2-Clause

add_subdirectory(kmediasession)

set(kasts_srcs
    main.cpp
    fetcher.cpp
    database.cpp
    entry.cpp
    feed.cpp
    author.cpp
    enclosure.cpp
    chapter.cpp
    datamanager.cpp
    audiomanager.cpp
    error.cpp
    utils/enclosuredownloadjob.cpp
    utils/storagemanager.cpp
    utils/storagemovejob.cpp
    utils/updatefeedjob.cpp
    utils/fetchfeedsjob.cpp
    utils/systrayicon.cpp
    utils/networkconnectionmanager.cpp
    utils/colorschemer.cpp
    models/abstractepisodemodel.cpp
    models/abstractepisodeproxymodel.cpp
    models/chaptermodel.cpp
    models/feedsmodel.cpp
    models/feedsproxymodel.cpp
    models/entriesmodel.cpp
    models/entriesproxymodel.cpp
    models/queuemodel.cpp
    models/episodemodel.cpp
    models/episodeproxymodel.cpp
    models/downloadmodel.cpp
    models/errorlogmodel.cpp
    models/podcastsearchmodel.cpp
    sync/sync.cpp
    sync/syncjob.cpp
    sync/syncutils.cpp
    sync/gpodder/gpodder.cpp
    sync/gpodder/genericrequest.cpp
    sync/gpodder/loginrequest.cpp
    sync/gpodder/logoutrequest.cpp
    sync/gpodder/devicerequest.cpp
    sync/gpodder/syncrequest.cpp
    sync/gpodder/updatesyncrequest.cpp
    sync/gpodder/updatedevicerequest.cpp
    sync/gpodder/subscriptionrequest.cpp
    sync/gpodder/uploadsubscriptionrequest.cpp
    sync/gpodder/episodeactionrequest.cpp
    sync/gpodder/uploadepisodeactionrequest.cpp
    resources.qrc
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "audiologging.h"
    IDENTIFIER "kastsAudio"
    CATEGORY_NAME "org.kde.kasts.audio"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "datamanagerlogging.h"
    IDENTIFIER "kastsDataManager"
    CATEGORY_NAME "org.kde.kasts.datamanager"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "enclosurelogging.h"
    IDENTIFIER "kastsEnclosure"
    CATEGORY_NAME "org.kde.kasts.enclosure"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "entrylogging.h"
    IDENTIFIER "kastsEntry"
    CATEGORY_NAME "org.kde.kasts.entry"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "feedlogging.h"
    IDENTIFIER "kastsFeed"
    CATEGORY_NAME "org.kde.kasts.feed"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "fetcherlogging.h"
    IDENTIFIER "kastsFetcher"
    CATEGORY_NAME "org.kde.kasts.fetcher"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "synclogging.h"
    IDENTIFIER "kastsSync"
    CATEGORY_NAME "org.kde.kasts.sync"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "models/downloadmodellogging.h"
    IDENTIFIER "kastsDownloadModel"
    CATEGORY_NAME "org.kde.kasts.downloadmodel"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "models/queuemodellogging.h"
    IDENTIFIER "kastsQueueModel"
    CATEGORY_NAME "org.kde.kasts.queuemodel"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "storagemanagerlogging.h"
    IDENTIFIER "kastsStorageManager"
    CATEGORY_NAME "org.kde.kasts.storagemanager"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "storagemovejoblogging.h"
    IDENTIFIER "kastsStorageMoveJob"
    CATEGORY_NAME "org.kde.kasts.storagemovejob"
    DEFAULT_SEVERITY Info
)

ecm_qt_declare_logging_category(kasts_srcs
    HEADER "networkconnectionmanagerlogging.h"
    IDENTIFIER "kastsNetworkConnectionManager"
    CATEGORY_NAME "org.kde.kasts.networkconnectionmanager"
    DEFAULT_SEVERITY Info
)

if(ANDROID)
    list(APPEND kasts_srcs
         utils/androidlogging.h)
endif()

if(KASTS_FLATPAK)
    list(APPEND kasts_srcs
         resources-flatpak.qrc)
else()
    list(APPEND kasts_srcs
         resources-non-flatpak.qrc)
endif()

set(kasts_ICONS_PNG
    ../icons/16-apps-kasts.png
    ../icons/24-apps-kasts.png
    ../icons/32-apps-kasts.png
    ../icons/48-apps-kasts.png
    ../icons/64-apps-kasts.png
    ../icons/128-apps-kasts.png
)

# add icons to application sources, to have them bundled
ecm_add_app_icon(kasts_srcs ICONS ${kasts_ICONS_PNG})

add_executable(kasts ${kasts_srcs})

kconfig_add_kcfg_files(kasts settingsmanager.kcfgc GENERATE_MOC)

target_include_directories(kasts PRIVATE ${CMAKE_BINARY_DIR})
target_link_libraries(kasts PRIVATE Qt::Core Qt::Qml Qt::Quick Qt::QuickControls2 Qt::Sql Qt::Svg Qt::Xml Qt::Network KF6::Kirigami2 KF6::Syndication KF6::CoreAddons KF6::ConfigGui KF6::I18n Taglib::Taglib ${QTKEYCHAIN_LIBRARIES} KF6::ThreadWeaver KF6::ColorScheme KMediaSession)

if(KASTS_FLATPAK)
    target_compile_definitions(kasts PUBLIC KASTS_FLATPAK)
endif()

if(ANDROID)
    target_link_libraries(kasts PRIVATE
        OpenSSL::SSL
        log
    )
    if(SQLite3_FOUND)
        target_link_libraries(kasts PRIVATE SQLite::SQLite3)
    endif()

    if(ZLIB_FOUND)
        target_link_libraries(kasts PRIVATE ZLIB::ZLIB)
    endif()

    kirigami_package_breeze_icons(ICONS
        window-close
        window-close-symbolic
        delete
        settings-configure
        documentinfo
        tools-report-bug
        list-add
        list-remove
        view-refresh
        view-filter
        kasts
        mail-sent
        globe
        data-error
        rss
        bookmarks
        document-import
        document-export
        document-open-folder
        document-save
        edit-delete-remove
        edit-clear-all
        edit-select-all
        edit-select-none
        edit-copy
        download
        media-playlist-append
        media-seek-backward
        media-seek-forward
        media-skip-forward
        media-playback-start
        media-playback-pause
        view-media-playlist
        source-playlist
        arrow-down
        go-next
        overflow-menu
        checkbox
        error
        search
        kt-add-feeds
        state-sync
        network-connect
        drive-harddisk-symbolic
        dialog-ok
        dialog-cancel
        computer
        computer-laptop
        network-server-database
        smartphone
        emblem-music-symbolic
        gpodder
        kaccounts-nextcloud
        clock
        viewimage
        player-volume-muted
        player-volume
        application-exit
        starred-symbolic
        non-starred-symbolic
        media-playback-cloud
        zoom-in
        zoom-out
        object-rotate-left
        object-rotate-right
        add-subtitle
        view-sort
        view-sort-descending
        view-sort-ascending
        view-sort-descending-name
        view-sort-ascending-name
    )
    ecm_add_android_apk(kasts ANDROID_DIR ${CMAKE_SOURCE_DIR}/android)
else()
    target_link_libraries(kasts PRIVATE Qt::Widgets)
endif()

install(TARGETS kasts ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
