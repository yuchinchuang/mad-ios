//
//  ViewController_newExam.swift
//  MAD_Assignment2
//
//  Created by Yu-Chin Chuang on 28/10/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit

class ViewController_newExam: UIViewController {

    @IBOutlet weak var lblStudentId: UILabel!
    @IBOutlet weak var txtUnitName: UITextField!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var txtLocation: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedStudentId: String = ""
    var txtDateTime : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStudentId.text = selectedStudentId
    }
    
    // back to previous view
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showExamList" {
            // check if the mandatory field is filled
            if selectedStudentId == "" {
                showMsg(title: "Error", msg: "Please select a student!")
                return false
            }
            else if (txtUnitName.text?.isEmpty)! {
                showMsg(title: "Error", msg: "Unit name cannot be empty.")
                return false
            }
            else {
                // valid inputs
                appDelegate.addExam(sId: selectedStudentId, unitName: txtUnitName.text!, dateTime: dateTimePicker.date, location: txtLocation.text!)
                return true
            }
        }
        else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController_ExamList
        destination.studentId = selectedStudentId
    }

    func showMsg(title: String, msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
