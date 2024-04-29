cmake_minimum_required(VERSION 3.16)

project(users-registration-qml VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appusers-registration-qml
    main.cpp
)

qt_add_qml_module(appusers-registration-qml
    URI users-registration-qml
    VERSION 1.0
    QML_FILES

        # QML
        views/Main.qml
        views/InputComponent.qml
        views/MyButton.qml
        views/SelectBirthdate.qml
        views/ActionButton.qml

        # Javascript
        views/js/generate.js
        views/js/validate.js

    RESOURCES

        # SVG
        views/imgs/svg/check.svg
        views/imgs/svg/wrong.svg
        views/imgs/svg/criticalError.svg
        views/imgs/svg/search.svg
        views/imgs/svg/reload.svg

        # IMAGES
        views/imgs/background.jpg

    SOURCES
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
