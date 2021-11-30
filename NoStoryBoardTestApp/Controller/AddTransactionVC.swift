//
//  AddTransactionVC.swift
//  NoStoryBoardTestApp
//
//  Created by MacBook on 26.11.2021.
//

import UIKit

class AddTransactionVC: UIViewController {
    
    let accountInput: UITextField = UITextField(frame: CGRect(x: 10, y: 320, width: 300.00, height: 30.00))
    let categorieInput: UITextField = UITextField(frame: CGRect(x: 10, y: 360, width: 300.00, height: 30.00))
    let amountInput: UITextField = UITextField(frame: CGRect(x: 10, y: 400, width: 300.00, height: 30.00))
    
    var txtDatePicker: UITextField = {
        let txt = UITextField()
    
        txt.placeholder = "Pick your date"
//        txt.text = "\(Date.now)"
        txt.borderStyle = UITextField.BorderStyle.roundedRect
        txt.frame = CGRect(x: 10, y: 440, width: 300.00, height: 30.00)
        
        //create DatePicker View here
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        txt.inputView = datePicker
        
        //add action to date picker
        
        datePicker.addTarget(self, action: #selector(valuechanged(sender:)), for: .valueChanged)
        
        return txt
    }()
    
    @objc func valuechanged(sender: UIDatePicker) {
        //config format od date here
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        self.txtDatePicker.text = dateFormat.string(from: sender.date)
    }
    
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    var dataInfo: [Account] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add transaction"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTappedDone(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
        
        displayTransitionDetail()
    }
    
    @objc func didTappedDone(_ sender: UIButton) {
        if !dataInfo.isEmpty {
            let data = dataInfo[0]
            
            data.name = accountInput.text
            data.amount = Double(truncating: Decimal(string: amountInput.text!)! as NSDecimalNumber)
            data.category = categorieInput.text
            data.date = txtDatePicker.text
        }
        else if accountInput.text == "" || amountInput.text == "" || categorieInput.text == "" {
            return
        }
        else {
            let data = Account(context: context)
            
            data.name = accountInput.text
            data.amount = Double(truncating: Decimal(string: amountInput.text!)! as NSDecimalNumber)
            data.category = categorieInput.text
            data.date = txtDatePicker.text
        }

        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func displayTransitionDetail() {
        
        accountInput.placeholder = "Select account"
        accountInput.borderStyle = UITextField.BorderStyle.roundedRect
        
        categorieInput.placeholder = "Select category"
        categorieInput.borderStyle = UITextField.BorderStyle.roundedRect
        
        amountInput.placeholder = "Enter amount"
        amountInput.borderStyle = UITextField.BorderStyle.roundedRect
        
        self.view.addSubview(accountInput)
        self.view.addSubview(categorieInput)
        self.view.addSubview(amountInput)
        self.view.addSubview(txtDatePicker)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

