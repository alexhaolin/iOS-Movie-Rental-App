//
//  ThirdViewController.swift
//  Final
//
//  Created by Alex on 4/15/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import CoreData

class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var editImage: UIButton!
    @IBOutlet var userName: UILabel!

    let impact = UIImpactFeedbackGenerator()
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.makeUI()
        self.checkAccount()
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editHeadImageBtn(_ sender: UIButton) {
        impact.impactOccurred()
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        headImageView.image = image!
        let fetchRequest: NSFetchRequest = Account.fetchRequest()
        //fetchRequest.predicate = NSPredicate(format: "name == %@", oriName)
        do {
            // 拿到符合条件的所有数据
            let account = try PersistenceService.context.fetch(fetchRequest)[0]
            account.headImage = image!.pngData()! as NSData
        } catch {}
        PersistenceService.saveContext()
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        impact.impactOccurred()
    }
    
    func checkAccount() {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        
        do{
            if(try PersistenceService.context.count(for: fetchRequest) != 0){
                
                let account = try PersistenceService.context.fetch(fetchRequest)[0]
                
                headImageView.image = UIImage(data: account.headImage! as Data)
                userName?.text = account.name
            }
        }catch{}
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
         Head ImageView
         */
        headImageView!.layer.masksToBounds = true
        headImageView!.layer.borderWidth = 2
        headImageView!.layer.borderColor = UIColor.gray.cgColor
        headImageView!.layer.backgroundColor = UIColor.clear.cgColor
        headImageView!.layer.cornerRadius = headImageView!.bounds.width * 0.5
        headImageView!.contentMode = .scaleAspectFill
        bGImageView.addSubview(headImageView!)
        
        bGImageView.addSubview(userName!)
        bGImageView.addSubview(editImage!)
        
        /**
         Logout button
         */
        logoutBtn.layer.masksToBounds = true
        logoutBtn.layer.borderWidth = 2
        logoutBtn.layer.backgroundColor = UIColor.clear.cgColor
        logoutBtn.layer.borderColor = UIColor.gray.cgColor
        
        logoutBtn.setTitleColor(UIColor.black, for: .normal)
        logoutBtn.layer.cornerRadius = 6
        //loginBtn.addTarget(self, action:#selector(signin(_:)), for:.touchUpInside)
        logoutBtn.layer.borderColor = UIColor.gray.cgColor
        bGImageView.addSubview(logoutBtn!)
        
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
