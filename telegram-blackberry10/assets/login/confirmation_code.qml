import bb.cascades 1.2
import Timer 1.0
import TgApi 1.0
import bb.system 1.2

import "../main"

Page {
    property string phoneNumber
    property bool registered
    property bool invited

    titleBar: TitleBar {
        title: "Enter confirmation code"
    }

    onCreationCompleted: {
        callTimer.start()
    }

    attachedObjects: [
        ComponentDefinition {
            id: registrationPageDefinition
            source: "asset:///login/registration.qml"
        },
        Sheet {
            id: mainPageSheet
            peekEnabled: false
            MainPage {
            }
        },
        Session {
            id: session
            onSessionChanged: {
                console.log("New session stored")
                console.log(session.session)
            }
        },
        RegistrationApi {
            id: api
            onAuthenticated: {
                console.log("Signed in")
                var sessionInfo = api.connectionSecretInfo()
                session.session = sessionInfo
                if (registered) {
                    // User is already registered, push the main page
                    mainPageSheet.open()
                } else {
                    /*
                     * This is the first time this number is used on Telegram.
                     * Open the registration page.
                     * 
                     * TODO: test this flow.
                     */
                    var page = registrationPageDefinition.createObject()
                    navigationPane.push(page)
                }
            }
        },
        SystemToast {
            id: callSentToast
            body: "The voice call has been dispatched."
        }
    ]

    Container {
        leftPadding: 40
        rightPadding: 40
        topPadding: 40
        bottomPadding: 40

        Timer {
            id: callTimer
            interval: 1000
            visible: false

            property int currentCount: 30
            function timerText(secondsLeft) {
                var secondsLeft = secondsLeft < 10 ? '0' + secondsLeft : secondsLeft
                return '00:' + secondsLeft
            }

            onTimeout: {
                currentCount -= 1
                timerLabel.text = timerText(currentCount)

                if (currentCount == 0) {
                    callTimer.stop()
                    // TODO send actual call
                    /*
                     * api.sendCall(phoneNumber, "what hash?")
                     * callSentToast.show()
                     */
                }
            }
        }

        Container {

            Label {
                text: "Your code"
                horizontalAlignment: HorizontalAlignment.Center
                textStyle {
                    fontSize: FontSize.XXLarge
                }
            }

            Divider {
                accessibility.name: "Title divider"
            }

            Label {
                text: "We have sent an SMS with an activation code to your phone " + phoneNumber
                multiline: true
                textStyle {
                    textAlign: TextAlign.Center
                }
            }
        }

        Label {
            text: ""
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }

        Container {
            leftPadding: 120
            rightPadding: 120
            TextField {
                id: confirmationCode
                hintText: "Code"
                inputMode: TextFieldInputMode.Pin
                onTextChanging: {
                    nextButton.enabled = confirmationCode.text.length > 0
                }
            }
            Label {
                text: "We will call you in"
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                id: timerLabel
                horizontalAlignment: HorizontalAlignment.Center
                text: '00:30'
                textStyle {
                    fontWeight: FontWeight.Bold
                }
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }

        Label {
            text: ""
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }

        Button {
            id: nextButton
            text: "Next"
            enabled: false
            horizontalAlignment: HorizontalAlignment.Center
            onClicked: {
                callTimer.stop()
                // TODO if signIn fails with proper code, go to signUp
                // else go to main page
                console.log("Signing in " + phoneNumber + " => " + confirmationCode.text)
                api.signIn(phoneNumber, confirmationCode.text)
            }
        }

    }
}
