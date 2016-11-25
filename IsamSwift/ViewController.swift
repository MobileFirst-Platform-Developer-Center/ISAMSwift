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

import UIKit
import IBMMobileFirstPlatformFoundation

class ViewController: UIViewController {

    let useObtain = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginPage), name: ACTION_CHALLENGE_RECEIVED, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getData(_ sender: UIButton) {
        if (self.useObtain) {
            WLAuthorizationManager.sharedInstance().obtainAccessToken(forScope: "", withCompletionHandler: { (token, error) in
                if (error != nil) {
                    self.showAlert(title: "Error", message: (error?.localizedDescription)!)
                } else {
                    self.showAlert(title: "Success", message: "Token obtained")
                }
            })
        } else {
            let request = WLResourceRequest(url: URL(string: "/adapters/ResourceAdapter/balance"), method: WLHttpMethodGet)
            request?.send(completionHandler: {(response, error) in
                if (error != nil) {
                    self.showAlert(title: "Error", message: (error?.localizedDescription)!)
                } else {
                    self.showAlert(title: "Success", message: (response?.responseText)!)
                }
            })
        }
    }

    @IBAction func logout(_ sender: UIButton) {
        WLAuthorizationManager.sharedInstance().logout("LtpaBasedSSO", withCompletionHandler: { (error) in
            if (error != nil) {
                self.showAlert(title: "Error", message: "Failed to logout")
            } else {
                IsamChallegeHandler.sharedInstance.logout() //Logout of ISAM
                self.showAlert(title: "Success", message: "Logged out")
            }
        })
    }

    func showAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showLoginPage () {
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }

}
