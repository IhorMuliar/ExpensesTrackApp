//
//  ExpensesVC.swift
//  NoStoryBoardTestApp
//
//  Created by MacBook on 25.11.2021.
//

import UIKit
import CoreData

class ExpensesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    var dataInfo: [Account] = []
    var totalExpenses = ""
    
    func fetchData() {
        //fetch data from Core Data to display in the tableview
        do {
            let request = Account.fetchRequest() as NSFetchRequest<Account>
            
            // Set the filtering and sorting on the request
            let pred = NSPredicate(format: "amount < 0")
            request.predicate = pred
            
            self.dataInfo = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }

    private let tableView: UITableView = {
        
        let table = UITableView()
//        table.register(UITableViewCell.self,
//                       forCellReuseIdentifier: "cell")
        table.register(ExpensesCell.self,
                       forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
        getData()
        
        let views = ["view": view!, "tableView" : tableView]
        var allConstraints: [NSLayoutConstraint] = []
         allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
         allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
         NSLayoutConstraint.activate(allConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExpensesCell
        
            cell.categoryLabel.text = dataInfo[indexPath.row].category
            cell.expensesLabel.text = "$\(dataInfo[indexPath.row].amount)"
            cell.expensesLabel.textColor = UIColor.systemRed
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
//        view.backgroundColor = .red
        
        let labelAccount = UILabel()
        let labelAmount = UILabel()
        
        labelAccount.text = "Total"
        labelAmount.text = totalExpenses
        
        labelAccount.sizeToFit()
        labelAccount.frame = CGRect(x: 15, y: 5,
                                    width: labelAccount.frame.width,
                                    height: 20)

        labelAmount.sizeToFit()
        labelAmount.frame = CGRect(x: 280, y: 5,
                                   width: labelAmount.frame.width,
                                   height: 20)
        
        
        view.addSubview(labelAccount)
        view.addSubview(labelAmount)
        
        return view
    }
    
    //when user taps on the row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print(dataInfo[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //create a swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHendler) in
            
            self.context.delete(self.dataInfo[indexPath.row])
            
            do {
                try self.context.save()
            } catch {
            
            }
            
            self.fetchData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func getData() -> Void {
            var total:Double = 0.00
            for i in 0 ..< dataInfo.count {
                total += dataInfo[i].amount as! Double
            }
            totalExpenses = "$" + (NSString(format: "%.2f", total as CVarArg) as String)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        fetchData()
    }
}
