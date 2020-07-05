//
//  ViewController.swift
//  TaskByDucktale
//
//  Created by Kap's on 05/07/20.
//  Copyright © 2020 Kapil. All rights reserved.
//

import UIKit
import CoreData

class ProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var product = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataFromDisk()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureWelcome()
    }
        
    @IBAction func addProductButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Product", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Product Name "
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Quantity"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            
            let productName = alert.textFields!.first!.text!
            let productQuantity = alert.textFields!.last!.text!
            
            if(productName.isEmpty || productQuantity.isEmpty || Int(productQuantity) == 0)  {

                let alert = UIAlertController(title: "Alert!", message: "Please enter valid values.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                
                let product = Product(context: DataPersistenceService.context)
                product.productName = productName
                product.productQuantity  = Int32(productQuantity)!
                
                self.saveContext()
                self.product.append(product)
                self.tableView.reloadData()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Fetching Data Back from Disk
    func fetchDataFromDisk(){
        let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let product = try DataPersistenceService.context.fetch(fetchRequest)
            self.product = product
            self.tableView.reloadData()
        } catch {}
    }
    
    func configureTableView(){
        self.tableView.allowsMultipleSelectionDuringEditing = false;
    }
    
    func saveContext(){
        DataPersistenceService.saveContext()
    }
    
    func configureWelcome() {
        if tableView.visibleCells.isEmpty {
            let alert = UIAlertController(title: "Welcome!", message: "Try adding products by clicking on '+' button at top right.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

    // MARK: - Table View Extension
extension ProductListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ProductListCell
        cell?.cellDelegate = self
        cell?.textLabel?.text = product[indexPath.row].productName
        cell?.quantity?.text = String(product[indexPath.row].productQuantity)
        cell?.stackView.isHidden = false
        
        return cell!
    }
    
    //Function for editing rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        switch editingStyle {
        case .delete:
            
            DataPersistenceService.context.delete(product[indexPath.row] as NSManagedObject)
            product.remove(at: indexPath.row)
            self.saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
}

// MARK: - Table View Cell Extension
extension ProductListViewController : cellProtocol {
    
    func didTapOnIncrease(_ sender: ProductListCell, _ quantity: Int32) {
        updateQuantityValue(sender, quantity)
    }
    
    func didTapOnDecrease(_ sender: ProductListCell, _ quantity: Int32) {
        updateQuantityValue(sender, quantity)
    }
    
    func updateQuantityValue(_ sender: ProductListCell, _ quantity: Int32) {
        
        let indexPath = self.tableView.indexPath(for: sender)
        let productChange = product[indexPath!.row]
        productChange.productQuantity = quantity
        self.saveContext()
    }
}




