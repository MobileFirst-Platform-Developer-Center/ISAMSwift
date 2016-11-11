/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2016. All Rights Reserved
 * US Government Users Restricted Rights - Use, duplication or disclosure
 * restricted by GSA ADP Schedule Contract with IBM Corp.
 */

import UIKit
import IBMMobileFirstPlatformFoundation

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(closeLogin), name: ACTION_CHALLENGE_SUCCESS, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: UIButton) {
        IsamChallegeHandler.sharedInstance.login(username: username.text!, password: password.text!)
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.closeLogin()
        IsamChallegeHandler.sharedInstance.cancel()
    }

    func closeLogin() {
        self.navigationController!.popViewController(animated: true)
    }
}
