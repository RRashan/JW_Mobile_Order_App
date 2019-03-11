//
//  AppDelegate.swift
//  JagandwolfOrder
//
//  Created by Ricky Halley
//  Copyright © Jagandwolf All rights reserved.
//

import UIKit
import Firebase

struct Detail {
    let name: String
    let type: String
    let motion: String
    let twist: String
    let amount: String
    let qty: String
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var getName = String()
    var getDate = String()
    var getTime = String()
    var userID = Auth.auth().currentUser?.uid
    var databaseRef: DatabaseReference!
    var detailList = [Detail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Detail Order"
        
        dateLbl.text = "Date  " + getDate
        nameLbl.text = "\(getName)"
        
        let date = getDate + " " + getTime
        databaseRef = Database.database().reference().child("CustomerHistoryDetail").child(userID!).child(date)
        databaseRef.observe(DataEventType.value, with: {(DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                self.detailList.removeAll()
                
                for details in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let detailObject = details.value as? [String: AnyObject]
                    let detailName = detailObject?["ProductName"]
                    let detailType = detailObject?["ProductType"]
                    let detailQty = detailObject?["TotalQty"]
                    let detailMotion = detailObject?["OptionMotion"]
                    let detailTwist = detailObject?["OptionTwist"]
                    let detailAmount = detailObject?["OptionAmount"]
                    
                    let detail = Detail(name: (detailName as! String?)!, type: (detailType as! String?)!, motion: (detailMotion as! String?)!, twist: (detailTwist as! String?)!, amount: (detailAmount as! String?)!, qty: (detailQty as! String?)!)
                    self.detailList.append(detail)
                }
                self.tableView.reloadData()
            }
        })
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

    // Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        let detail: Detail
        
        detail = detailList[indexPath.row]
        
        cell.nameLbl.text = detail.name
        cell.detailLbl.text = detail.name + " " + detail.type + " " + detail.motion + " " + detail.twist + " " + detail.amount
        cell.qtyLbl.text = detail.qty
        return cell
    }
    
}
