//
//  ExampleCollectionViewCell.swift
//  ExampleInfiniteScrollView
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var backgroundImage: UIImageView!

    var model : Model!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func updateData(_ model:Model){
        self.model = model
        if model.imageName != nil {
            selectedStatus()
            backgroundImage.image = UIImage(named: model.imageName!)
        }else{
            nomoralStatus()
            
            backgroundImage.image = nil
        }
    }
    
    func hasContent() -> Bool {
        return true
    }
    
    func moveOverStatus(){
        backgroundColor = UIColor.clear
    }
    
    func nomoralStatus(){
        backgroundColor = UIColor.white
    }
    
    func selectedStatus(){
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

}
