//
//  ItemViewController.swift
//  lists2
//
//  Created by Razvigor Andreev on 11/2/14.
//  Copyright (c) 2014 Razvigor Andreev. All rights reserved.
//

import UIKit
import CoreData

let pctFormatter = NSNumberFormatter()
func loadImageFromPath(path: String) -> UIImage? {
    
    let image = UIImage(contentsOfFile: path)
    
    if image == nil {
        
        println("missing image at: \(path)")
    }
    println("\(path)")
    return image
    
}

func documentsDirectory() -> String{    //documents folder  ----  /User/ravenshore..../documents/
    
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) [0] as String
    
    return documentsFolderPath
}


func fileInDocumentsDirectory(filename: String) ->String { // a file in doc directory   ----    /User/ravenshore..../documents/Photo.jpg
    
    return documentsDirectory().stringByAppendingPathComponent(filename)
}




class ItemViewController: UIViewController,UIGestureRecognizerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    
    
    @IBOutlet var imageView: UIImageView!
    
    
    @IBOutlet var textFieldItem: UITextField! = nil
    @IBOutlet var textFieldQuantity: UITextField! = nil
    @IBOutlet var textFieldPrice: UITextField!=nil
    @IBOutlet var textFieldInfo: UITextField! = nil
    
    var item: String = ""
    var quantity: String = ""
    var info: String = ""
    var imagePath: String = "no image"
    var imageCheck: String = "no"
    var price: Double? = 0.00
    
    var image: UIImage!
    var noImage = UIImage(named: "no_image.png")
    
    var existingItem: NSManagedObject!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "metal1.jpg")!)
        
        if imageCheck == "no" {
            
            imageView.image = noImage
            println("no image available")
        }
        
        var borderColorBlack: UIColor = UIColor.blackColor()
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = borderColorBlack.CGColor
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "handleTap")
        
        
        imageView!.addGestureRecognizer(tapRecognizer)

        
        if (existingItem != nil) {
            
            if imageCheck == "yes" {
            println("We have an image")
            image = loadImageFromPath(imagePath)
            imageView.image = image
            
            } else {
                
                println("we don't have an image")
                imageView.image = noImage
                
            }
           
            
            textFieldItem.text = item
            textFieldQuantity.text = quantity
            textFieldInfo.text = info
            
            
            pctFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle

            textFieldPrice.text = pctFormatter.stringFromNumber(price!)
            
            
        }

     
    }

    
    @IBAction func savePressed(sender: AnyObject) {
        
        //reference to app delegate
        println("\(imagePath)")
        let currentTime = NSDate()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //reference moc
        
        let contxt: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
        
        
        // check if item exists
        
        
        if (existingItem != nil) {
            
            if imageCheck == "yes" {
                
               
            imagePath = fileInDocumentsDirectory("\(currentTime).png")
            saveImage(image, path: imagePath)
            existingItem.setValue(imagePath as String, forKey: "imagePath")
            existingItem.setValue("yes" as String, forKey: "imageCheck")
            
            } else {
                
                imagePath == "no image"
                imageView.image = noImage
                existingItem.setValue("no image" as String, forKey: "imagePath")
                existingItem.setValue("no" as String, forKey: "imageCheck")
            }
            existingItem.setValue(textFieldItem.text as String, forKey: "item")
            existingItem.setValue(textFieldQuantity.text as String, forKey: "quantity")
            existingItem.setValue(textFieldInfo.text as String, forKey: "info")
           
            let stringPrice = textFieldPrice.text
            let priceDouble = priceStringAsDouble(stringPrice)
            
            existingItem.setValue(priceDouble, forKey: "price")
            
            println("Price is: \(priceDouble)")
            println("String Price is: \(textFieldPrice.text)")
            
            
            println("\(imagePath)")
            
            
        } else {
            
            //create instance of our data model and initialize
            
            
            
            var newItem = lists2.Model(entity: en!, insertIntoManagedObjectContext: contxt)
            
            if imageCheck == "yes" {
            
            // create the image name and save it
            imagePath = fileInDocumentsDirectory("\(currentTime).png")
            saveImage(image, path: imagePath)
                
            //map our properties
            newItem.imagePath = imagePath as String
            newItem.imageCheck = "yes"
                println("\(imagePath)")
                
            } else {
                
                imagePath = "no image"
                imageCheck = "no"
                imageView.image = noImage
                //map our properties
                newItem.imagePath = imagePath as String
                newItem.imageCheck = imageCheck as String
               
            }
            //map our properties
            newItem.item = textFieldItem.text
            newItem.quantity = textFieldQuantity.text
            newItem.info = textFieldInfo.text
            
            let priceDouble = (NSString(string: textFieldPrice.text)).doubleValue
            newItem.price = priceDouble
            
           
            
            
            
            
            println("\(newItem.info)")
            
            if image != nil {
            println("\(newItem.imagePath)")
                println("\(imagePath)")
            }
            
        }
        
        
        
        
        //save our context
        
        contxt.save(nil)
        
        
        
        //navigate back to root vc
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        
        //navigate back to root vc
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    

    
    
    func handleTap(){
        println("tapped")
        loadImage()
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        imageView!.image = image
        imageCheck = "yes"
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func loadImage() {
        
        var imagePicker = UIImagePickerController()
        var sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    func priceStringAsDouble(priceString: String) -> Double {
        let cleanedString = priceString.stringByReplacingOccurrencesOfString(pctFormatter.currencySymbol!, withString: "")
        let priceAsDouble = (cleanedString as NSString).doubleValue
        return priceAsDouble;
    }
 

    
    
}
