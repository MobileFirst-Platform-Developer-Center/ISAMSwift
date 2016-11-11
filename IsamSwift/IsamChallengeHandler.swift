/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2016. All Rights Reserved
 * US Government Users Restricted Rights - Use, duplication or disclosure
 * restricted by GSA ADP Schedule Contract with IBM Corp.
 */

import Foundation
import IBMMobileFirstPlatformFoundation

class IsamChallegeHandler: GatewayChallengeHandler {
    static let sharedInstance = IsamChallegeHandler()
    let myGateway = "LtpaBasedSSO"

    override init() {
        super.init(gatewayName: myGateway)
    }

    override func canHandle(_ response: WLResponse!) -> Bool {
        print ("IsamChallengeHandler: canHandle")
        if let responseText = response.responseText {
            if (responseText.contains("pkmslogin.form") == true) {
                print("IsamChallegeHandler.canHandl(): ISAM login form detected. Returning true.")
                return true
            }
        }
        return false
    }

    override func handleChallenge(_ response: WLResponse!) {
        print ("IsamChallengeHandler: handleChallenge")
        NotificationCenter.default.post(name: ACTION_CHALLENGE_RECEIVED, object: self)
    }

    override func onSuccess(_ response: WLResponse!) {
        print("IsamChallengeHandler: onSuccess")
        NotificationCenter.default.post(name: ACTION_CHALLENGE_SUCCESS, object: self)
        submitSuccess(response)
    }

    override func onFailure(_ response: WLFailResponse!) {
        print("IsamChallengeHandler: onFailure")
        cancel()
    }

    func login(username: String, password: String) {
        self.submitLoginForm("../../pkmslogin.form?token=Unknown", requestParameters: ["username":username,"password":password,"login-form-type":"pwd"], requestHeaders: nil, requestTimeoutInMilliSeconds: 0, requestMethod: "POST")
    }

    func logout () {
        self.submitLoginForm("../../pkmslogout", requestParameters: nil, requestHeaders: nil, requestTimeoutInMilliSeconds: 0, requestMethod: "POST")
    }
}
