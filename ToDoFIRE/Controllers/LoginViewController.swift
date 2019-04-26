//
//  ViewController.swift
//  ToDoFIRE
//
//  Created by Игорь on 4/23/19.
//  Copyright © 2019 Igor Zhyzhyrii. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let segueIdentifier = "tasksSegue"
    
    var keyBoardDismissTapGesture: UIGestureRecognizer!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyBoardNotifications()
        
        warnLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func registerForKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func kbDidShow(notification: Notification) {
        if keyBoardDismissTapGesture == nil{
            keyBoardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            keyBoardDismissTapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(keyBoardDismissTapGesture)
        }
        let userInfo = notification.userInfo
        let kbFrameSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        scrollView.contentOffset  = CGPoint(x: 0, y: kbFrameSize.height)
     }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func kbDidHide() {
        if keyBoardDismissTapGesture != nil {
            view.removeGestureRecognizer(keyBoardDismissTapGesture)
            keyBoardDismissTapGesture = nil
        }
        scrollView.contentOffset = CGPoint.zero
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        textField.endEditing(true)
        return true
    }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            if(user != nil) {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if user != nil {

                } else {
                    print("User is not created")
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}
