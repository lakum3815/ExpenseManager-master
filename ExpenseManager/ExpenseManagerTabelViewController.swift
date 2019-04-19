//
//  ExpenseManagerTabelViewController.swift
//  ExpenseManager
//
//  Created by Hiren Patel on 17/04/19.
//  Copyright © 2019 Hiren Patel. All rights reserved.
//

import UIKit
import CoreData

class ExpenseManagerTabelViewController: UITableViewController, DidDataUpdateDelegate {
    
    func updated(yes: Bool){
        changed = yes
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        allExpenses = [Expense]()
        self.refreshControl = nil
        //        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidAppear(_ animated: Bool) {
        week = false
        month = false
        year = false
        if changed {
            getData()
            changed = false
        }
    }
    //instantiate class variables
    var week: Bool = false
    var month: Bool = false
    var year: Bool = false
    var changed: Bool = true
    var allExpenses = [Expense]()
    
    // Method to access all of the Expense data
    func getData() {
        //Create fetch request object and apply the sorting descriptor for most recent dates to older dates
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Expense.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        //fetch the array of Expense objects and set it to the class variable
        do {
            let expenses = try PersistanceService.context.fetch(fetchRequest)
            self.allExpenses = expenses
        } catch {
            print("Cannot fetch Expenses")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                week = true
                performSegue(withIdentifier: "graphSegue", sender: nil)
            }
            if indexPath.row == 1 {
                month = true
                performSegue(withIdentifier: "graphSegue", sender: nil)
            }
            
            if indexPath.row == 2 {
                year = true
                performSegue(withIdentifier: "graphSegue", sender: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  //method to send data before segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "graphSegue"){
            let dest = segue.destination as! MainGraphViewController
            dest.allExpenses = allExpenses
            if(week){
                dest.currentRange = MainGraphViewController.DateRange.Weekly
            }
            else if(month){
                print("setMonthly")
                dest.currentRange = MainGraphViewController.DateRange.Monthly
            }
            else if(year){
                print("setYearly")
                dest.currentRange = MainGraphViewController.DateRange.Yearly
            }
        } else if(segue.identifier == "viewTableSegue") {
            let dest = segue.destination as! ExpenseViewTable
            dest.allExpenses = allExpenses
            dest.delegate = self
        }
    }
}
extension CALayer {
    func borderUIColor() -> UIColor? {
        return borderColor != nil ? UIColor(cgColor: borderColor!) : nil
    }
    
    func setBorderUIColor(color: UIColor) {
        borderColor = color.cgColor
    }
}
