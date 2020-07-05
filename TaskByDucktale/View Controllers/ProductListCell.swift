//
//  ProductListCell.swift
//  TaskByDucktale
//
//  Created by Kap's on 05/07/20.
//  Copyright © 2020 Kapil. All rights reserved.
//

import UIKit
import CoreData

protocol cellProtocol {
    func didTapOnIncrease(_ sender: ProductListCell, _ quantity : Int32)
    func didTapOnDecrease(_ sender: ProductListCell, _ quantity : Int32)
}

class ProductListCell: UITableViewCell {

    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var cellDelegate : cellProtocol?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func decreaseButtonTapped(_ sender: UIButton) {
        let quantity = self.quantity.text
        
        var quantityCount = Int32(quantity!)
        quantityCount!-=1
        
        if(quantityCount == 0){
            quantityCount = 1
            
            cellDelegate?.didTapOnDecrease(self, quantityCount!)
            self.quantity.text = String(quantityCount!)
        } else {
            cellDelegate?.didTapOnDecrease(self, quantityCount!)
            self.quantity.text = String(quantityCount!)
        }
    }
    
    @IBAction func increaseButtonTapped(_ sender: UIButton) {
        let quantity = self.quantity.text
        
        var quantityCount = Int32(quantity!)
        quantityCount!+=1
        
        cellDelegate?.didTapOnIncrease(self, quantityCount!)
        self.quantity.text = String(quantityCount!)
    }
}
