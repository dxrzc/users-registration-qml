cmake_minimum_required(VERSION 3.16)

project(users-registration-qml VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/deployment")

if(WIN32)    
    set(POSTGRESQL_LIB_DIR "C:/Program Files/PostgreSQL/17/bin")
elseif(UNIX)    
    set(POSTGRESQL_LIB_DIR "/usr/lib/postgresql/17/bin")
endif()

set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/resources/users-registration.rc")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Sql QuickTest QuickControls2 Test Qml)

qt_standard_project_setup(REQUIRES 6.5)

if(WIN32)
    qt_add_executable(appusers-registration-qml
        main.cpp
        ${app_icon_resource_windows}
    )
elseif(UNIX)
    qt_add_executable(appusers-registration-qml
        main.cpp
        resources/app-icon.ico
    )
endif()

set(plain_qml_files   
    qml/components/ActionIcon.qml
    qml/components/BirthdateSelection.qml
    qml/components/CustomButton.qml
    qml/components/Input.qml

    qml/sections/SearchUserSection.qml
    qml/sections/TableHeaderSection.qml
    qml/sections/TableRenderingSection.qml
    qml/sections/TableSection.qml
    qml/sections/UserInputSection.qml

    qml/views/ErrorView.qml
    qml/views/InsertUrlView.qml

    qml/Main.qml
)

set(javascript_files
    qml/js/global/backend.js
    qml/js/global/settings.js

    qml/js/helpers/get-data-from-url.helper.js
    qml/js/helpers/month.helper.js

    qml/js/validation/new-user.validation.js
)

set(assets_files
    # SVG
    qml/imgs/svg/check.svg
    qml/imgs/svg/wrong.svg
    qml/imgs/svg/search.svg
    qml/imgs/svg/reload.svg
    qml/imgs/svg/delete.svg
    qml/imgs/svg/edit.svg

    qml/imgs/background.jpg
    qml/imgs/error.png
)

set(cpp_domain_files
    domain/entities/connectionOptions/connectionOptions.h
    domain/entities/birthdate/birthdate.h
    domain/entities/birthdate/birthdate.cpp
    domain/entities/user/user.h
    domain/entities/user/user.cpp
    domain/datasource/Datasource.h
    domain/errors/errorhandler.h
    domain/dtos/qmldto.h
    domain/dtos/qmldto.cpp
)

set(cpp_infraestructure_files
    infraestructure/db/postgredatasource.h
    infraestructure/db/postgredatasource.cpp
)

set(cpp_interface_files
    interface/table/userTableModel.h
    interface/table/userTableModel.cpp
)

set(global_config
    global/config/qml.h
    global/config/database.h
)

set(test_global_config
    global/test/testdatabase-options.h
)

set(cpp_files
    ${global_config}
    ${cpp_domain_files}
    ${cpp_infraestructure_files}
    ${cpp_interface_files}
)

qt_add_qml_module(appusers-registration-qml
    URI appModule
    VERSION 1.0

    QML_FILES
    ${plain_qml_files}    
    ${javascript_files}

    RESOURCES
    ${assets_files}

    SOURCES    
    ${cpp_files}    
)

qt_generate_deploy_qml_app_script(
    TARGET appusers-registration-qml
    OUTPUT_SCRIPT deploy_script
    NO_TRANSLATIONS
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appusers-registration-qml PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appusers-registration-qml
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appusers-registration-qml
    PRIVATE 
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql         
)

include_directories(
   interface/table/ # userTableModel
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

include(GNUInstallDirs)
install(TARGETS appusers-registration-qml
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(SCRIPT ${deploy_script})

if(WIN32)
    install(FILES
        ${POSTGRESQL_LIB_DIR}/libpq.dll
        ${POSTGRESQL_LIB_DIR}/libcrypto-3-x64.dll
        ${POSTGRESQL_LIB_DIR}/libiconv-2.dll
        ${POSTGRESQL_LIB_DIR}/libintl-9.dll
        ${POSTGRESQL_LIB_DIR}/libssl-3-x64.dll
        ${POSTGRESQL_LIB_DIR}/libwinpthread-1.dll
        DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")

    enable_testing()

    project(qmlTesting LANGUAGES CXX)

    add_definitions(-DQUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}/qml/testing")

    add_executable(qmlTesting
        qml/testing/test.cpp
        qml/testing/helpers/insert-text.helper.js
        ${test_global_config}
        ${cpp_files}
        ${javascript_files}
    )

    add_test(NAME qmlTesting COMMAND qmlTesting)

    target_link_libraries(qmlTesting
        PRIVATE
        Qt6::QuickTest
        Qt6::QuickControls2
        Qt6::Qml
        Qt6::Sql
    )

    # C++ Testing

    include(FetchContent)
    FetchContent_Declare(
      googletest
      DOWNLOAD_EXTRACT_TIMESTAMP TRUE
      URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.zip
    )

    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)

    include(GoogleTest)

    add_executable(birthdate_test
        domain/entities/birthdate/birthdate.h
        domain/entities/birthdate/birthdate.cpp
        testing/domain/entities/birthdate/test_birthdate.cpp
    )

    target_link_libraries(birthdate_test
        PRIVATE
        Qt6::Core
        Qt6::Test
    )

    add_executable(user_test
        domain/entities/birthdate/birthdate.h
        domain/entities/birthdate/birthdate.cpp
        domain/entities/user/user.h
        domain/entities/user/user.cpp
        testing/domain/entities/user/test_user.cpp
    )

    target_link_libraries(user_test
        PRIVATE
        Qt6::Core
        Qt6::Test
    )

    add_executable(connectionOptions_test
        domain/entities/connectionOptions/connectionOptions.h
        testing/domain/entities/connectionOptions/test_connectionOptions.cpp
    )

    target_link_libraries(connectionOptions_test
        PRIVATE
        Qt6::Core
        Qt6::Test
    )

    add_executable(qmlDto_test
        ${test_global_config}
        ${cpp_domain_files}
        testing/domain/dtos/test_qmldto.cpp
    )

    target_link_libraries(qmlDto_test
        PRIVATE
        Qt6::Core
        Qt6::Test
        GTest::gtest_main
        GTest::gmock_main
    )

    add_executable(postgredatasource_test
        ${test_global_config}
        ${cpp_domain_files}
        ${cpp_infraestructure_files}
        testing/infraestructure/db/test_postgredatasource.cpp
        testing/infraestructure/db/helper_invalidConnection.h
    )

    target_link_libraries(postgredatasource_test
        PRIVATE
        Qt6::Core
        Qt6::Test
        Qt6::Sql
    )

    add_test(NAME BirthdateTest COMMAND birthdate_test)
    add_test(NAME UserTest COMMAND user_test)
    add_test(NAME ConnectionOptions COMMAND connectionOptions_test)
    add_test(NAME QmlDtoTest COMMAND qmlDto_test)
    add_test(NAME PostgreDataSourceTest COMMAND postgredatasource_test)
endif()
