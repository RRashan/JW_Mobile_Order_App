//
//  AppDelegate.swift
//  JagandwolfOrder
//
//  Created by Ricky Halley
//  Copyright © Jagandwolf All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var hpriceTextField: UITextField!
    @IBOutlet weak var cpriceTextField: UITextField!
    @IBOutlet weak var fpriceTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    //ประกาศตัวแปร
    var userID = Auth.auth().currentUser?.uid
    var rootRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var selectedImage: UIImage?
    var categoryPickerView = UIPickerView()
    var motion = String()
    var twist = String()
    var amount = String()
    var image: UIImage?
    var product:Product?
    
    //ประกาศค่าให้ตัวแปร
    let categories = ["Cocktails", "Beer", "Scotch", "Wine"]
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ส่วนตกแต่ง
        itemImage.layer.cornerRadius = itemImage.bounds.height / 2
        itemImage.clipsToBounds = true
        navigationItem.title = "Add Item"
        itemImage.image = UIImage(named: "blankImage")
        
        itemNameTextField.delegate = self
        categoryTextField.delegate = self
        hpriceTextField.delegate = self
        cpriceTextField.delegate = self
        fpriceTextField.delegate = self
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryTextField.inputView = categoryPickerView

    }
    
    //ตกแต่ง Status bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
            statusBar.backgroundColor = UIColor(named: "Status")!
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sweetBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
            self.motion = "open"
        }
    }
    
    @IBAction func whipBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
            self.twist = "open"
        }
    }
    
    @IBAction func syrupBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
            self.amount = "open"
        }
    }
    
    @IBAction func saveItemBtn(_ sender: Any) {
        
        if product == nil {
            product = Product()
        }
        
        product?.name = self.itemNameTextField.text
        product?.category = self.categoryTextField.text
        
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("ProductName").setValue(product!.name!)
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("ProductCategory").setValue(product!.category!)
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("ProductHotPrice").setValue(self.hpriceTextField.text!)
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("ProductColdPrice").setValue(self.cpriceTextField.text!)
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("ProductFrappePrice").setValue(self.fpriceTextField.text!)
        
        if motion == "" {
            motion = "close"
        }
        if twist == "" {
            twist = "close"
        }
        if amount == "" {
            amount = "close"
        }
        
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("OptionMotion").setValue(self.motion)
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("OptionTwist").setValue(self.twist)
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("OptionTwist").setValue(self.amount)
        self.rootRef.child("Product").child(userID!).child(self.itemNameTextField.text!).child("ProductDetail").setValue(self.detailTextView.text!)
        
        if selectedImage == nil {
            image = UIImage(named: "blankImage")!
        } else {
            image = selectedImage!
        }
        
        let imageRef = storageRef.child("Product").child(userID!).child(itemNameTextField.text!)
        if let itemPic = image, let imageData = UIImageJPEGRepresentation(itemPic, 0.1){
            imageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                if error != nil{
                    return
                }
                
                let itemImageUrl = metadata?.downloadURL()?.absoluteString
                self.rootRef.child("Product").child(self.userID!).child(self.itemNameTextField.text!).child("ProductImg").setValue(itemImageUrl)
            })
        }
        print("complete")
        self.navigationController?.popViewController(animated: true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = categories[row]
        categoryTextField.resignFirstResponder()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage = image
        itemImage.image = image
        itemImage.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhoto(_ sender: UITapGestureRecognizer) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
}
