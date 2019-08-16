//
//  faceidViewController.swift
//  Final
//
//  Created by Alex on 4/27/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import LocalAuthentication

class faceidViewController: UIViewController {

    
    @IBOutlet var faceIDBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeUI()
        self.startWithFaceID()
        // Do any additional setup after loading the view.
    }
    
    func makeUI() {
        /**
         Background
         */
        let bGImageView = UIImageView.init(frame: self.view.frame)
        bGImageView.contentMode = UIView.ContentMode.scaleAspectFill
        bGImageView.image = UIImage.init(named: "Login.jpg")
        bGImageView.isUserInteractionEnabled = true
        self.view.addSubview(bGImageView)
        
        /**
         FaceID button
         */
        faceIDBtn.contentRect(forBounds: CGRect.init(x: 40, y: 500, width: 400, height: 40))
        faceIDBtn.setTitle("Use Face ID", for: .normal)
        faceIDBtn.backgroundColor = UIColor.clear
        faceIDBtn.setTitleColor(UIColor.black, for: .normal)
        faceIDBtn.layer.cornerRadius = 20
        faceIDBtn.addTarget(self, action:#selector(faceid(_:)), for:.touchUpInside)
        bGImageView.addSubview(faceIDBtn)
        
    }
    func startWithFaceID(){
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            
            if let laError = error {
                print("laError - \(laError)")
                return
            }
            
            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                switch laContext.biometryType {
                case .faceID: localizedReason = "Unlock using Face ID"; print("FaceId support")
                case .touchID: localizedReason = "Unlock using Touch ID"; print("TouchId support")
                case .none: print("No Biometric support")
                }
            } else {
                // Fallback on earlier versions
            }
            
            
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            self.performSegue(withIdentifier: "faceid", sender: self)
                            print("sucess")
                        } else {
                            
                            print("failure")
                        }
                    }
                    
                })
            })
        }
        
    }
    
    @objc func faceid(_ btn:UIButton) -> Void{
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            
            if let laError = error {
                print("laError - \(laError)")
                return
            }
            
            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                switch laContext.biometryType {
                case .faceID: localizedReason = "Unlock using Face ID"; print("FaceId support")
                case .touchID: localizedReason = "Unlock using Touch ID"; print("TouchId support")
                case .none: print("No Biometric support")
                }
            } else {
                // Fallback on earlier versions
            }
            
            
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            self.performSegue(withIdentifier: "faceid", sender: self)
                            print("sucess")
                        } else {
                            
                            print("failure")
                        }
                    }
                    
                })
            })
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
