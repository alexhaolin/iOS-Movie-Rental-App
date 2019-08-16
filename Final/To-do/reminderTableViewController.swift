//
//  reminderTableViewController.swift
//  Final
//
//  Created by Alex on 4/23/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import CoreData



class reminderTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UINavigationBarDelegate, UIGestureRecognizerDelegate {

    let impact = UIImpactFeedbackGenerator()
    
    var reminders = [Reminder]()
    
    var rmdTitles = [String]()
    var filteredRmdTitles = [String]()

    static var rmdsForDetail = Dictionary<String,Reminder>()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func AddReminder(_ sender: Any) {
        impact.impactOccurred()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.hidesBottomBarWhenPushed = false
        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do{
            if(try PersistenceService.context.count(for: fetchRequest) == 0){
                self.searchController.isActive = false
                self.showNoReminders()
                print("No reminders")
            }else{
                let reminders = try PersistenceService.context.fetch(fetchRequest)
                self.reminders = reminders
                rmdTitles.removeAll()
                
                for rmd in self.reminders{
                    if(rmdTitles.contains(rmd.remTitle!)){
                        continue
                    }else{
                        rmdTitles.insert((rmd.remTitle!), at: 0)
                        reminderTableViewController.rmdsForDetail[rmd.remTitle!] = rmd
                    }
                }
                self.tableView.reloadData()
            }
        }catch{}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search Updater
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Reminders"
        navigationItem.searchController = searchController
        self.searchController.hidesNavigationBarDuringPresentation = false

        // Large Title
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        // Fetch Data
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do{
            if(try PersistenceService.context.count(for: fetchRequest) == 0){
                self.searchController.isActive = false
                self.showNoReminders()
                print("No reminders")
            }else{
                print("context has : \(try PersistenceService.context.count(for: fetchRequest))")
                let reminders = try PersistenceService.context.fetch(fetchRequest)
                print(reminders.count)
                self.reminders = reminders
                print("Reminder's count: \(reminders.count)")
                
                for rmd in self.reminders{
                    
                    if(!rmdTitles.contains(rmd.remTitle!)){
                        rmdTitles.insert(rmd.remTitle!, at: 0)
                        reminderTableViewController.rmdsForDetail[rmd.remTitle!] = rmd
                    }
                }
            }
        }catch{}

        
        
    }
    
    func showNoReminders() {
        let label = UILabel()
        label.text = "No reminder."
        label.font = label.font.withSize(40)
        label.textAlignment = .center
        label.backgroundColor = .white
        self.view = label
    }
    

    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
        
        // Create a method to filter the objects
        filterContentForSearchText(text)
    }
    
    func filterContentForSearchText(_ searchText: String){
        filteredRmdTitles = rmdTitles.filter({(token: String) -> Bool in
            if (searchController.searchBar.text?.isEmpty)! {
                return true
            }else{
                return token.lowercased().contains(searchText.lowercased())
            }
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool{
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty)!
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(isFiltering()){
            return filteredRmdTitles.count
        }else{
            return rmdTitles.count
        }
    }

    // Row Content.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        
        // Configure the cell...
        var title = ""
        if isFiltering() {
            title = filteredRmdTitles[indexPath.row]
        }else {
            title = rmdTitles[indexPath.row]
            //cell.detailTextLabel?.text = "Type: " + movieType[indexPath.row]
        }
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        //cell.imageView?.image = UIImage(data: moviesTableViewController.moviesForDetail[movieTitle]!.poster! as Data)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.

        return true
    }
    */
    

    
    // Edit.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let rmdTitle = rmdTitles[indexPath.row]
            let r = reminderTableViewController.rmdsForDetail[rmdTitle]!
            
            reminders.remove(at: indexPath.row)
            
            rmdTitles.remove(at: indexPath.row)
            print("rmdTitles: \(rmdTitles.count)")
            
            PersistenceService.context.delete(r)
            PersistenceService.saveContext()
            reminderTableViewController.rmdsForDetail.removeValue(forKey: rmdTitle)
            
//            let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
//            do{
//
//                print(try PersistenceService.context.count(for: fetchRequest))
//
//            }catch{}
           
            
           
            //print(reminderTableViewController.rmdsForDetail.count)
            
            

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Click a Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        impact.impactOccurred()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "reminderDetail"){
            let destVC = segue.destination as!addReminderViewController
            let cell = sender as!UITableViewCell
            let title = cell.textLabel!.text
            destVC.reminder = reminderTableViewController.rmdsForDetail[title!]
        }
        
    }
    

    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
