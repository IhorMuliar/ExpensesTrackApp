//
//  DashboardVC.swift
//  NoStoryBoardTestApp
//
//  Created by MacBook on 25.11.2021.
//

import UIKit

class DashboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    var accounts = ["Cash": "", "Credit Card": "", "Bank Account": ""]
    var dataInfo: [Account] = []
    var totalAmount = ""
    
    func fetchData() {
        //fetch data from Core Data to display in the tableview
        do {
            self.dataInfo = try context.fetch(Account.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ExpensesCell.self,
                       forCellReuseIdentifier: "cell")
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
        
        fetchData()
        getData()
        
        let views = ["view": view!, "tableView" : tableView]
        var allConstraints: [NSLayoutConstraint] = []
         allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
         allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
         NSLayoutConstraint.activate(allConstraints)
    }
    
    @objc func addTapped() {        
        navigationController?.pushViewController(AddTransactionVC(), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExpensesCell
        
        cell.categoryLabel.text = "\(dataInfo[indexPath.row].category as! String) (\(dataInfo[indexPath.row].name as! String))"
        
//        cell.categoryLabel.text = dataInfo[indexPath.row].category
        cell.dateLabel.text = dataInfo[indexPath.row].date
        cell.expensesLabel.text = "$\(dataInfo[indexPath.row].amount)"
        
        if dataInfo[indexPath.row].amount > 0 {
            cell.expensesLabel.textColor = UIColor.systemGreen
        } else { cell.expensesLabel.textColor = UIColor.systemRed }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
//        view.backgroundColor = .red
        
        let labelAccount = UILabel()
        let labelAmount = UILabel()
        
        labelAccount.text = Array(accounts.keys)[section]
        labelAmount.text = Array(accounts.values)[section]
        
        labelAccount.sizeToFit()
        labelAccount.frame = CGRect(x: 10, y: 5,
                                    width: labelAccount.frame.width,
                                    height: 20)

        labelAmount.sizeToFit()
        labelAmount.frame = CGRect(x: 295, y: 5,
                                   width: labelAmount.frame.width,
                                   height: 20)
        
        
        view.addSubview(labelAccount)
        view.addSubview(labelAmount)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
    
    //when user taps on the row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(dataInfo[indexPath.row])
    }
    
    func getData() -> Void {
        do{
            dataInfo = try context.fetch(Account.fetchRequest())
            var total:Double = 0.00
            var totalCash:Double = 0.00
            var totalCreditCard:Double = 0.00
            var totalBankAccount:Double = 0.00
            
            for i in 0 ..< dataInfo.count {
                if dataInfo[i].name == "Cash" {
                    totalCash += dataInfo[i].amount
                    accounts["Cash"] = "$" + (NSString(format: "%.2f", totalCash as CVarArg) as String)
                    total += dataInfo[i].amount
                }
                if dataInfo[i].name == "Credit Card" {
                    totalCreditCard += dataInfo[i].amount
                    accounts["Credit Card"] = "$" + (NSString(format: "%.2f", totalCreditCard as CVarArg) as String)
                    total += dataInfo[i].amount
                }
                if dataInfo[i].name == "Bank Account" {
                    totalBankAccount += dataInfo[i].amount
                    accounts["Bank Account"] = "$" + (NSString(format: "%.2f", totalBankAccount as CVarArg) as String)
                    total += dataInfo[i].amount
                }
            }
            
            totalAmount = "$" + (NSString(format: "%.2f", total as CVarArg) as String)
        }
        catch{
            print("Fetching Failed")
        }
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
