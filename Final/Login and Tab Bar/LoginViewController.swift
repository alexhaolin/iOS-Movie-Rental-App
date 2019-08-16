//
//  LoginViewController.swift
//  Final
//
//  Created by Alex on 4/25/19.
//  Copyright © 2019 Alex. All rights reserved.
//


import UIKit
import CoreData


class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var signinBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var headImageView: UIImageView!
    var AccountTextField:UITextField?
    var passWTextField:UITextField?
    var timer:Timer?
    var underView:UIView?
    
    let impact = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigation()
        self.makeLoginUI()
        self.imagePicker.delegate = self
        self.checkAccount()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    
 
    
    func checkAccount(){
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        
        do{
            if(try PersistenceService.context.count(for: fetchRequest) != 0){
                
                let account = try PersistenceService.context.fetch(fetchRequest)[0]
                
                headImageView.image = UIImage(data: account.headImage! as Data)
                AccountTextField?.text = account.name
                signinBtn.isHidden = false
                editBtn.isHidden = true
                signUpBtn.isHidden = true
            }else{
                editBtn.isHidden = false
                signUpBtn.isHidden = false
                signinBtn.isHidden = true
            }
            
            
        }catch{}
    }
    
    // Navigation
    func setNavigation() -> Void {
        self.navigationItem.title = "Login"
    }
    
    // LoginUI
    func makeLoginUI() {
        /**
         Background
         */
        let bGImageView = UIImageView.init(frame: self.view.frame)
        bGImageView.contentMode = UIView.ContentMode.scaleAspectFill
        bGImageView.image = UIImage.init(named: "Login.jpg")
        bGImageView.isUserInteractionEnabled = true
        self.view.addSubview(bGImageView)
        
        /**
         Head ImageView
         */
        headImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
        headImageView!.center = CGPoint.init(x: self.view.center.x, y: 160)
        headImageView!.layer.masksToBounds = true
        headImageView!.layer.borderWidth = 2
        headImageView!.layer.backgroundColor = UIColor.clear.cgColor
        headImageView!.layer.cornerRadius = headImageView!.bounds.width * 0.5
        headImageView!.contentMode = .scaleAspectFill
        bGImageView.addSubview(headImageView!)
        
        editBtn.addTarget(self, action: #selector(editPhoto(_:)), for: .touchUpInside)
        bGImageView.addSubview(editBtn)
        
        /**
         Account
         */
        let AccountLable = UILabel.init(frame: CGRect.init(x: 40, y:headImageView!.frame.maxY+30
            , width: 70, height: 30))
        AccountLable.text = "Account:"
        bGImageView.addSubview(AccountLable)
        
        AccountTextField = UITextField.init(frame: CGRect.init(x: AccountLable.frame.maxX+10, y: headImageView!.frame.maxY + 32, width: bGImageView.frame.width - 90 - AccountLable.frame.width, height: 30))
        AccountTextField?.placeholder = "Enter your account"
        AccountTextField?.textAlignment = .center
        bGImageView.addSubview(AccountTextField!)
        
        let line = UIView.init(frame: CGRect.init(x: 40, y: AccountLable.frame.maxY, width: bGImageView.frame.width - 80, height: 1))
        line.backgroundColor = UIColor.gray
        bGImageView.addSubview(line)
        
        /**
         Password
         */
        let passWLable = UILabel.init(frame: CGRect.init(x: 40, y: line.frame.maxY+40, width: 80, height: 30))
        passWLable.text = "Password:"
        bGImageView.addSubview(passWLable)
        
        passWTextField = UITextField.init(frame: CGRect.init(x: passWLable.frame.maxX+10, y: line.frame.maxY + 42, width: bGImageView.frame.width - passWLable.frame.width - 90, height: 30))
        passWTextField?.isSecureTextEntry = true
        passWTextField?.placeholder = "Enter your password"
        passWTextField?.textAlignment = .center
        bGImageView.addSubview(passWTextField!)
        
        let lineV = UIView .init(frame: CGRect.init(x: 40, y: passWLable.frame.maxY, width: bGImageView.frame.width - 80, height: 1))
        lineV.backgroundColor = UIColor.gray
        bGImageView.addSubview(lineV)
        
        /**
         Log In button
         */
        signinBtn.contentRect(forBounds: CGRect.init(x: 40, y: lineV.frame.maxY + 50, width: bGImageView.frame.width - 80, height: 40))
        signinBtn.setTitle("Sign In", for: .normal)
        signinBtn.setTitleColor(UIColor.black, for: .normal)
        signinBtn.layer.cornerRadius = 6
        signinBtn.addTarget(self, action:#selector(signin(_:)), for:.touchUpInside)
        signinBtn.layer.borderColor = UIColor.gray.cgColor
        signinBtn.layer.borderWidth = 1
        signinBtn.backgroundColor = UIColor.white
        bGImageView.addSubview(signinBtn)
        
        /**
         Sign Up button
         */
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.setTitleColor(UIColor.black, for: .normal)
        signUpBtn.layer.cornerRadius = 6
        signUpBtn.addTarget(self, action:#selector(signup(_:)), for:.touchUpInside)
        signUpBtn.layer.borderColor = UIColor.gray.cgColor
        signUpBtn.layer.borderWidth = 1
        signUpBtn.backgroundColor = UIColor.white
        bGImageView.addSubview(signUpBtn)
    }
    
    @objc func editPhoto(_ btn: UIButton) -> Void {
        impact.impactOccurred()
        print("Edit btn pressed")
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        headImageView!.image = image!
        print("image set")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func autoAlertView(message:String) -> Void {
        let autoAlert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        self.present(autoAlert, animated: true) {
            self.timer = Timer.init(timeInterval: 10, repeats: false, block: { (time) in
                autoAlert.dismiss(animated: true, completion:{
                    self.timer?.invalidate()
                })
            })
            self.timer?.fire()
        }
    }
    
    // signin
    @objc func signin(_ btn:UIButton) -> Void {
        impact.impactOccurred()
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        do{
            let accountNumber = try PersistenceService.context.count(for: fetchRequest)
            print("[Sign in] Account number: \(accountNumber)")
            if(accountNumber == 0){
                self.autoAlertView(message: "Please sign up.")
            }else{
                let accountName = AccountTextField?.text
                let password = passWTextField?.text
                if accountName == "" || password == "" {
                    self.autoAlertView(message: "Enter account info.")
                }else{
                    let account = try PersistenceService.context.fetch(fetchRequest)[0]
                    let storedAccountName = account.name
                    let storedAccountPassword = account.password
                    
                    if accountName == storedAccountName && password == storedAccountPassword{
                        self.performSegue(withIdentifier: "login", sender: self)
                    }else if accountName != storedAccountName {
                        self.autoAlertView(message: "Account not exist.")
                    }else if password != storedAccountPassword {
                        self.autoAlertView(message: "Password not correct.")
                    }
                }
            }
        }catch{}
        
    }
    // signup
    @objc func signup(_ btn:UIButton) -> Void {
        impact.impactOccurred()
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        do{
            let accountNumber = try PersistenceService.context.count(for: fetchRequest)
            print("Account number: \(accountNumber)")
            if(accountNumber == 0){
                let accountName = AccountTextField?.text
                let password = passWTextField?.text
                if accountName == "" || password == "" {
                    self.autoAlertView(message: "Enter account info.")
                }else{
                    if headImageView?.image != nil {
                        let account = Account(context: PersistenceService.context)
                        account.name = accountName
                        account.password = password
                        account.headImage = headImageView.image!.pngData()! as NSData
                        if account.headImage == nil{
                            print("headimage is nil")
                        }else {
                            print("headimage saved")
                        }
                        try PersistenceService.context.save()
                        self.autoAlertView(message: "Account created.")
                        self.signinBtn.isHidden = false
                    }else{
                        self.autoAlertView(message: "Image not set.")
                    }
                }
            }else{
                self.autoAlertView(message: "Please sign in.")
            }
        }catch{}
        
    }
    
}
