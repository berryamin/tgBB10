import bb.cascades 1.2

NavigationPane {
    id: navigationPane
    Page {
        Container {
            Label {
                // Localized text with the dynamic translation and locale updates support
                text: qsTr("Hello World") + Retranslate.onLocaleOrLanguageChanged
                textStyle.base: SystemDefaults.TextStyles.BigText
                autoSize.maxLineCount: -1
            }
            ScrollView {
                Container {

                    Button {
                        text: "Intro screen"
                        onClicked: {
                            var page = introPageDefinition.createObject()
                            navigationPane.push(page)
                        }
                        attachedObjects: ComponentDefinition {
                            id: introPageDefinition
                            source: 'intro/intro.qml'
                        }
                    }

                    Button {
                        text: "Login and registration"
                        onClicked: {
                            var page = pageDefinition.createObject()
                            navigationPane.push(page)
                        }
                        attachedObjects: ComponentDefinition {
                            id: pageDefinition
                            source: 'login/country_number_input.qml'
                        }
                    }

                }
                accessibility.name: "Page links"
            }
        }

    }
}