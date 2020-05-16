//
//  ViewController_newStudent.swift
//  MAD_Assignment2
//
//  Created by Yu-Chin Chuang on 28/10/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit
import CoreData
import os.log

class ViewController_newStudent: UIViewController {

    @IBOutlet weak var txtStudentId: UITextField!
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var segGender: UISegmentedControl!
    @IBOutlet weak var txtCourse: UITextField!
    @IBOutlet weak var stpprAge: UIStepper!
    @IBOutlet weak var txtAge: UILabel!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var btnAddStudent: UIButton!
    
    var sId : String = ""
    var fName : String = ""
    var lName : String = ""
    var course : String = ""
    var txtGender : String = ""
    var age : Int = 0
    var address : String = ""
    var record : Student? = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure stepper
        stpprAge.wraps = true
        stpprAge.autorepeat = true
        stpprAge.minimumValue = 1
        stpprAge.maximumValue = 100
        
        if record != nil {
            self.title = "Update Record"
            btnAddStudent.setTitle("Save", for: .normal)
            txtStudentId.isEnabled = false
            txtStudentId.text = record?.studentId
            txtFName.text = record?.firstName
            txtLName.text = record?.lastName
            txtCourse.text = record?.courseStudy
            txtAddress.text = record?.address
            
            for i in 0...1 {
                if segGender.titleForSegment(at: i) == record?.gender {
                    segGender.selectedSegmentIndex = i
                }
            }
            
            txtAge.text = (record?.age)?.description
            if let ageTxt = txtAge.text {
                if let ageNumber = NumberFormatter().number(from: ageTxt){
                    stpprAge.value = Double(ageNumber.intValue)
                }
            }
        }
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeAge(_ sender: UIStepper) {
        // get stepper value
        let step = Int(stpprAge.value)
        // display stepper value
        txtAge.text = String(step)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if identifier == "showNewStudent" {
            sId = txtStudentId.text!
            if sId.isEmpty {
                showMsg(title: "Warning", msg: "Student ID cannot be empty.")
                return false
            }
            
            fName = txtFName.text!
            lName = txtLName.text!
            course = txtCourse.text!
            address = txtAddress.text!
            
            // get selected segment value
            //record?.gender = segGender.titleForSegment(at: segGender.selectedSegmentIndex) ?? ""
            txtGender = segGender.titleForSegment(at: segGender.selectedSegmentIndex)!
            
            // get integer value of age for storing in entity
            if let ageTxt = txtAge.text {
                if let ageNumber = NumberFormatter().number(from: ageTxt){
                    age = ageNumber.intValue
                }
            }
            
            // create or update a record
            if txtStudentId.isEnabled {
                // check if the student id is unique
                for id in appDelegate.getStudentList().sIds {
                    if id == sId {
                        showMsg(title: "Oops", msg: "\(sId) is existing.")
                        return false
                    }
                }
                
                appDelegate.addStudentInfo(sId: sId, firstName: fName, lastName: lName, gender: txtGender, courseStudy: course, age: age, address: address)
                return true
            }
            else {
                record?.studentId = txtStudentId.text
                record?.firstName = txtFName.text
                record?.lastName = txtLName.text
                record?.courseStudy = txtCourse.text
                record?.address = txtAddress.text
                record?.gender = txtGender
                record?.age = Int16(age)
                appDelegate.updateStudentInfo(studentInfo : record!)
                return true
            }
            
        }
        else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ViewController_studentRecord
        // find the record
        destination.studentId = sId
    }
    
    func showMsg(title : String, msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler : nil))
        self.present(alert, animated: true, completion: nil)
    }

}
