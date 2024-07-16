cmake_minimum_required(VERSION 3.16)

project(users-registration-qml VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appusers-registration-qml
    main.cpp
)

set(plain_qml_files

    qml/js/backend.js

    qml/components/ActionIcon.qml
    qml/components/BirthdateSelection.qml
    qml/components/Button.qml
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
    qml/js/generate.js
    qml/js/splitOptions.js
    qml/js/validate.js
    qml/js/globals.js
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

set(cpp_files
    domain/entities/connectionOptions/connectionOptions.h
    domain/entities/birthdate/birthdate.h
    domain/entities/birthdate/birthdate.cpp
    domain/entities/user/user.h
    domain/entities/user/user.cpp
    domain/datasource/Datasource.h
    domain/errors/errorhandler.h
    domain/dtos/qmldto.h
    domain/dtos/qmldto.cpp

    infraestructure/db/postgredatasource.h
    infraestructure/db/postgredatasource.cpp

    interface/table/userTableModel.h
    interface/table/userTableModel.cpp
)

qt_add_qml_module(appusers-registration-qml
    URI qmlModule
    VERSION 1.0

    QML_FILES
    ${plain_qml_files}    
    ${javascript_files}

    RESOURCES
    ${assets_files}

    SOURCES
    ${cpp_files}
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
    Qt6::Sql
)

include_directories(
   interface/table/ # userTableModel
)

include(GNUInstallDirs)
install(TARGETS appusers-registration-qml
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
