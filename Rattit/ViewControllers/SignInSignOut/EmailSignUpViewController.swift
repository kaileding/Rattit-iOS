//
//  EmailSignUpViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class EmailSignUpViewController: UIViewController {

    @IBOutlet weak var canvasView: UIView!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        self.doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        self.firstNameField.text = ""
        self.firstNameField.borderStyle = .none
        self.firstNameField.addTarget(self, action: #selector(textFieldEdited(_:)), for: .editingChanged)
        
        self.lastNameField.text = ""
        self.lastNameField.borderStyle = .none
        self.lastNameField.addTarget(self, action: #selector(textFieldEdited(_:)), for: .editingChanged)
        
        self.emailField.text = ""
        self.emailField.borderStyle = .none
        self.emailField.addTarget(self, action: #selector(textFieldEdited(_:)), for: .editingChanged)
        
        self.passwordField.text = ""
        self.passwordField.borderStyle = .none
        self.passwordField.addTarget(self, action: #selector(textFieldEdited(_:)), for: .editingChanged)
        
        self.doneButton.alpha = 0.3
        self.doneButton.isEnabled = false
        
        self.canvasView.layer.masksToBounds = true
        self.canvasView.layer.cornerRadius = 6.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.firstNameField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func tapCanvasRecognized(_ sender: UITapGestureRecognizer) {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
    
}

extension EmailSignUpViewController {
    func cancelButtonPressed() {
        UserStateManager.userRefusedToLogin = true
        self.dismiss(animated: true) {
            self.firstNameField.text = ""
            self.lastNameField.text = ""
            self.emailField.text = ""
            self.passwordField.text = ""
        }
    }
    
    func doneButtonPressed() {
        UserStateManager.userIsLoggedIn = true
        NotificationCenter.default.post(name: NSNotification.Name(SignInSignUpNotificationName.successfulSignUpWithEmail.rawValue), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldEdited(_ textField: UITextField) {
        // remove begining space
        if (textField.text?.characters.count == 1) {
            if (textField.text == " ") {
                textField.text = ""
                return
            }
        }
        // ensure all fieds are filled
        guard let firstName = self.firstNameField.text, !firstName.isEmpty,
            let lastName = self.lastNameField.text, !lastName.isEmpty,
            let email = self.emailField.text, !email.isEmpty,
            let password = self.passwordField.text, !password.isEmpty
            else {
                self.doneButton.alpha = 0.3
                self.doneButton.isEnabled = false
                return
        }
        
        self.doneButton.alpha = 1.0
        self.doneButton.isEnabled = true
    }
    
}
