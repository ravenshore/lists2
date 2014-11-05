//
//  ListTableViewController.swift
//  lists2
//
//  Created by Razvigor Andreev on 11/2/14.
//  Copyright (c) 2014 Razvigor Andreev. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    
    var myList: Array<AnyObject> = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "List")
        
        myList = context.executeFetchRequest(freq, error: nil)!
        tableView.reloadData()
        
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier? == "update" {
           
            if (self.tableView.indexPathForSelectedRow())!.row < myList.count {
            var selectedItem: NSManagedObject = myList[(self.tableView.indexPathForSelectedRow())!.row] as NSManagedObject
            
            
            let IVC: ItemViewController = segue.destinationViewController as ItemViewController
            
            IVC.item = selectedItem.valueForKey("item") as String
            IVC.quantity = selectedItem.valueForKey("quantity") as String
            IVC.info = selectedItem.valueForKey("info") as String
            IVC.imagePath = selectedItem.valueForKey("imagePath") as String
            IVC.imageCheck = selectedItem.valueForKey("imageCheck") as String
            IVC.price = selectedItem.valueForKey("price") as? Double
            
            
            IVC.existingItem = selectedItem
            }
        }
        
    }

    

  

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
//        if myList.count >= 15 {
//            return myList.count } else {
//            
//            return 15
//        }
          return myList.count
    
    }

    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        
        
        pctFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        let CellID: NSString = "Cell"
        var cell: UITableViewCell = tableView?.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell
        
        
        if let ip = indexPath {
            
            var data: NSManagedObject = myList[ip.row] as NSManagedObject
            
//           if (indexPath?.row < myList.count) {
            
           
            var imagePathCell: String = data.valueForKeyPath("imagePath") as String
            let checkCellImage:String = data.valueForKeyPath("imageCheck") as String
               if checkCellImage == "yes" {
            let cellImage: UIImage? = loadImageFromPath(imagePathCell)
                cell.imageView.image = cellImage } else {
                cell.imageView.image = UIImage(named: "no_image")
                
                }
                
            var quantity = data.valueForKeyPath("quantity") as String
            var info = data.valueForKeyPath("info") as String
            var imageAvail = data.valueForKeyPath("imageCheck") as String
            var price = data.valueForKeyPath("price") as Double
            var priceString : String! = pctFormatter.stringFromNumber(price)
           
           cell.textLabel.text = data.valueForKeyPath("item") as? String
           cell.textLabel.backgroundColor = UIColor.clearColor()
            if price > 0 {
              cell.detailTextLabel!.text = "Quantity: \(quantity), Price: \(priceString)"
            } else {
                
              cell.detailTextLabel!.text = "Quantity: \(quantity), Price: N/A"
            }
           cell.detailTextLabel?.backgroundColor = UIColor.clearColor()
           cell.accessoryType = UITableViewCellAccessoryType.DetailButton
            
            
//            } else {
            
//                cell.textLabel.text = "Add New Item"
//                cell.textLabel.backgroundColor = UIColor.clearColor()
//                cell.detailTextLabel!.text = "Nothing to see here. Move Along !"
//                cell.detailTextLabel?.backgroundColor = UIColor.clearColor()
//                cell.accessoryType = UITableViewCellAccessoryType.DetailButton
//                
//            }
            if (ip.row % 2 == 0) {
                
                cell.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.2)
            } else {
                
                cell.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
            }
            
            
        }
        
       
        

        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }



// Override to support editing the table view.
override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    if editingStyle == UITableViewCellEditingStyle.Delete {
        
        if (indexPath.row < myList.count) {
        if let tv = tableView {
            
            context.deleteObject(myList[indexPath.row] as NSManagedObject)
            myList.removeAtIndex(indexPath.row)
            tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
           self.tableView.reloadData()
            
        }
        
        var error: NSError? = nil
        if !context.save(&error) {
            
            abort()
    }

}
    }
    }


}