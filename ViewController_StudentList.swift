//
//  ViewController_StudentList.swift
//  MAD_Assignment2
//
//  Created by ychuang on 24/10/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit

// class for tblcStudent
class TableViewCell_StudentList : UITableViewCell {
    
    @IBOutlet weak var txtSID: UILabel!
    @IBOutlet weak var txtSName: UILabel!
    
}

class ViewController_StudentList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblStudents: UITableView!
    
    var studentList : (ids : [String], names : [String]) = ([""] ,[""])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTable()
    }
    
    func updateTable() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.getStudentList().sIds.count != 0 {
            studentList = (appDelegate.getStudentList().sIds, appDelegate.getStudentList().sNames)
        }
        tblStudents.reloadData()
    }
    
    //------ Table functions-------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.ids.count
    }
    
    // display data in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblcStudent", for: indexPath) as! TableViewCell_StudentList
        cell.txtSID.text! = (studentList.ids[indexPath.row])
        cell.txtSName.text! = (studentList.names[indexPath.row])
        var color: Bool = true
        if indexPath.row % 2 == 1 {
            color = false
        }
        
        // background color
        let bgView = UIView()
        // RGB color: R-205,G-228,B-194 = UIColor: red-0.80,green-0.89,blue-0.76
        bgView.backgroundColor = color ? UIColor.init(red: 0.80, green: 0.89, blue: 0.76, alpha: 1.0) : UIColor.clear
        cell.backgroundView = bgView
        cell.layoutSubviews()
        return cell;
    }
    
    // exit of other views
    @IBAction func unwindToStudentList(sender: UIStoryboardSegue) {
        updateTable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "showStudent" {
        
            // get the navigation controller between this and the target view
            let destinationNav = segue.destination as! UINavigationController
            // get the target view
            let target = destinationNav.topViewController as! ViewController_studentRecord
            // get the selected student
            let indexPath = tblStudents.indexPathForSelectedRow!
            // pass data
            let studentId = studentList.ids[indexPath.row]
            target.studentId = studentId
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
