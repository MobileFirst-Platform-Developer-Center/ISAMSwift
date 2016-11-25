/**
* Copyright 2016 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
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
