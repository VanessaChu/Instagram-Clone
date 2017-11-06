//
//  ViewController.swift
//  Instagram
//
//  Created by Vanessa Chu on 2017-07-15.
//  Copyright © 2017 Vanessa Chu. All rights reserved.
//

import UIKit
import Parse


class ViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var signUpOrLogIn: UIButton!
    @IBOutlet var message: UILabel!
    @IBOutlet var changeSignUpMode: UIButton!
    
    
    var  signupMode = true
    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpOrLogIn(_ sender: Any) {
        if emailTextfield.text == "" || passwordTextfield.text == ""{
            createAlert(title: "Error in form", message: "Please enter an email and password")
        }else{
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode{
                
                //Sign Up
                
                let user = PFUser()
                user.username = emailTextfield.text
                user.email = emailTextfield.text
                user.password = passwordTextfield.text
                
                user.signUpInBackground{(success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    var displayErrorMessage = "Please try again later"
                    if error != nil{
                        if let errorMessage = (error! as NSError).userInfo["error"] as? String{
                            displayErrorMessage = errorMessage
                        }
                        self.createAlert(title: "Sign Up Error", message: displayErrorMessage)
                    }else{
                        print("User signed up")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                }
                
            }else{
                
                
                //Log In
                PFUser.logInWithUsername(inBackground: emailTextfield.text!, password: passwordTextfield.text!, block: {(user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil{
                    
                        var displayErrorMessage = "Please try again later"
                        if let errorMessage = (error! as NSError).userInfo["error"] as? String{
                            displayErrorMessage = errorMessage
                        }
                        self.createAlert(title: "Log In Error", message: displayErrorMessage)
                        
                    }else{
                        
                        print("Logged In")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    
                    }
                    
                })
            }
                    
            
        }
    
    }
    
    @IBAction func changeSignUpMode(_ sender: Any) {
        if signupMode{
            
            //Change to login mode
            
            changeSignUpMode.setTitle("Sign Up", for: [])
            signUpOrLogIn.setTitle("Log In", for: [])
            message.text = "Don't have an account?"
            signupMode = false
            
        }else{
            
            //Change to signup mode
            
            changeSignUpMode.setTitle("Log In", for: [])
            signUpOrLogIn.setTitle("Sign Up", for: [])
            message.text = "Already have an account?"
            signupMode = true
            
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
