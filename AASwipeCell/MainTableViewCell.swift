//
//  MainTableViewCell.swift
//  AASwipeCell
//
//  Created by Aleksandar Atanackovic on 1/31/17.
//  Copyright © 2017 Aleksandar Atanackovic. All rights reserved.
//

import UIKit

class MainTableViewCell: AASwipeTableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureButtons() {
        let addButton = UIButton()
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = UIColor.red
        
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = UIColor.blue
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)

        self.setButtons(with: [addButton, editButton])
        
    }
    
    func configureImageButtons() {
        let addButton = UIButton()
        addButton.setImage(#imageLiteral(resourceName: "addIcon"), for: .normal)
        addButton.backgroundColor = UIColor.red
        addButton.imageView?.contentMode = .scaleAspectFit

        let editButton = UIButton()
        editButton.setImage(#imageLiteral(resourceName: "editIcon"), for: .normal)
        editButton.backgroundColor = UIColor.blue
        editButton.imageView?.contentMode = .scaleAspectFit
        
        let deleteButton = UIButton()
        deleteButton.setImage(#imageLiteral(resourceName: "deleteIcon"), for: .normal)
        deleteButton.backgroundColor = UIColor.yellow
        deleteButton.imageView?.contentMode = .scaleAspectFit
        
        let sendButton = UIButton()
        sendButton.setImage(#imageLiteral(resourceName: "sendIcon"), for: .normal)
        sendButton.backgroundColor = UIColor.gray
        sendButton.imageView?.contentMode = .scaleAspectFit
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)

        self.setButtons(with: [addButton, editButton, deleteButton, sendButton])
        
    }
    
    @objc private func addButtonPressed() {
        print("Add button pressed")
    }
    
    @objc private func editButtonPressed() {
        print("Edit button pressed")
    }
    
    @objc private func deleteButtonPressed() {
        print("Delete button pressed")
    }
    
    @objc private func sendButtonPressed() {
        print("Send button pressed")
    }
    

}
