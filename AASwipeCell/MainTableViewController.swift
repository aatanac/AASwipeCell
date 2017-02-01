//
//  MainTableViewController.swift
//  AASwipeCell
//
//  Created by Aleksandar Atanackovic on 1/31/17.
//  Copyright © 2017 Aleksandar Atanackovic. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    fileprivate let textArray = ["One of the attractive beaches near Yogyakarta is Parangtritis", "Baron beach lies in Kemandang Village, Tanjungsari district about 23 km in the South of Wonosari city. Baron beach is the first beach that would be found in the junction of Baron, Kukup, Sepanjang, Drini, Krakal and Sundak beaches area. It is a bay with big wave.", "Sepanjang Beach is one of newly opened beaches. The name Sepanjang which means long derives from the characteristic of the beach that has the longest coastal lines of all beaches in Gunung Kidul.", "Wediombo Beach is a bay with white sand, which slopes gently to the sea, and it can be seen from the hill or even from the shore. Visitors can enjoy perfect sunset scenery from here.", "Gebang Temple is located on Condongcatur Region, south of Gebang Village, Ngemplak, Sleman. It is about 11 Kilometer from Yogyakarta town center. Gebang Temple (Gebang Temple) was established in early Central Java Age (about years 730 - 800). It's background of establishing, however, has remained a mystery. Gebang Temple, Jogyakarta, a blend of Buddha-Hindu temple.", "Ngobaran Beach is located at Gunung Kidul region, 50km from Yogyakarta. This is a pure beach with a number of marine attractions to explore. When the tide is low around 3 in the morning, the visitors can join the local fishermen to collect seaweeds or go fishing for stranded fish between the reefs at the beach." ,"Siung beach is located in Purwodadi Village, Tepus district, about 35 kilometers from Wonosari City with asphalt road to the beach. Siung beach lies between Two-step Mountains, which have a specific cliff." , "Siung beach is located in Purwodadi Village, Tepus district, about 35 kilometers from Wonosari City with asphalt road to the beach. Siung beach lies between Two-step Mountains, which have a specific cliff." , "Imogiri is the official cemetery of the royal descendents from Yogyakarta and Surakarta."]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return textArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.label.text = self.textArray[indexPath.row]
        cell.contentView.backgroundColor = UIColor.white
        cell.type = .trail
        
        if indexPath.row % 2 == 0 {
            cell.configureImageButtons()
        } else {
            cell.configureButtons()
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
 


}
