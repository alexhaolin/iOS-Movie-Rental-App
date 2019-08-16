//
//  addReminderViewController.swift
//  Final
//
//  Created by Alex on 4/25/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class addReminderViewController: UIViewController {

    let impact = UIImpactFeedbackGenerator()

    @IBOutlet var title1: UITextField!
    
    @IBOutlet var idea: UITextView!
    
    var reminder: Reminder!
    
    var oriTitle = ""
    var oriIdea  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true;

        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewReminder(_:)))
                self.navigationItem.rightBarButtonItem = saveBtn
        
        if reminder != nil{
            self.title1.text = reminder.remTitle!
            self.idea.text = reminder.remIdea!
            
            self.oriTitle = reminder.remTitle!
            self.oriIdea = reminder.remIdea!
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func saveNewReminder(_ sender:Any){
        impact.impactOccurred()
        
        
        var title = title1.text
        let idea  = self.idea.text
        
        
        if title == "" && idea == ""{
            let alert = UIAlertController(title: "Alert", message: "Write something.", preferredStyle: .alert)
            let okact = UIAlertAction(title: "Re-enter", style: .default, handler: nil)
            alert.addAction(okact)
            self.present(alert, animated: true, completion: nil)
            return
        }else if title == ""{
            let newReminder = Reminder(context: PersistenceService.context)
            title = self.idea.text?.components(separatedBy: " ")[0]
            newReminder.remIdea = idea
            newReminder.remTitle = title
            title1.text = title
            if reminder != nil{
                PersistenceService.context.delete(self.reminder)
            }
            PersistenceService.saveContext()
            
            let alert = UIAlertController(title: "Reminder Saved.", message: "", preferredStyle: .alert)
            let okact = UIAlertAction(title: "Done", style: .default, handler: nil)
            alert.addAction(okact)
            self.present(alert, animated: true, completion: nil)
        }else {
            let newReminder = Reminder(context: PersistenceService.context)
            newReminder.remIdea = idea
            newReminder.remTitle = title
            
            if reminder != nil{
                PersistenceService.context.delete(self.reminder)
            }
            PersistenceService.saveContext()
            
            let alert = UIAlertController(title: "Reminder Saved.", message: "", preferredStyle: .alert)
            let okact = UIAlertAction(title: "Done", style: .default, handler: nil)
            alert.addAction(okact)
            self.present(alert, animated: true, completion: nil)
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
