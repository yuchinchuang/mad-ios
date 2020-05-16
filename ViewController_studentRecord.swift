//
//  ViewController_studentRecord.swift
//  MAD_Assignment2
//
//  Created by Yu-Chin Chuang on 28/10/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit

class ViewController_studentRecord: UIViewController {


    @IBOutlet weak var txtSId: UILabel!
    @IBOutlet weak var txtSFName: UILabel!
    @IBOutlet weak var txtSLName: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var txtCourse: UILabel!
    @IBOutlet weak var txtAge: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    
    var studentId : String = ""
    var studentInfo : Student? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }

    func updateView(){
        studentInfo = appDelegate.getAStudent(studentId: studentId)
        
        if studentInfo != nil {
            txtSId.text! = studentId
            txtSFName.text! = (studentInfo?.firstName)!
            txtSLName.text! = (studentInfo?.lastName)!
            txtGender.text = studentInfo?.gender
            txtCourse.text! = (studentInfo?.courseStudy)!
            txtAge.text! = ((studentInfo?.age)!.description)
            txtAddress.text! = (studentInfo?.address)!
        }
    }
    
    @IBAction func unwindToStudentInfo(sender: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare for different actions
        if segue.identifier == "showMap" {
            let destination = segue.destination as! ViewController_Map
            destination.address = txtAddress.text!
        }
        if segue.identifier == "updateStudent" {
            let destinationNav = segue.destination as! UINavigationController
            let target = destinationNav.topViewController as! ViewController_newStudent
            target.record = studentInfo
        }
        if segue.identifier == "studentExams" {
            let desinationNav = segue.destination as! UINavigationController
            let target = desinationNav.topViewController as! ViewController_ExamList
            target.studentId = studentId
            target.displayAll = false
            target.myExam = true
        }
    }
    
    @IBAction func deleteStudent(_ sender: Any) {
        appDelegate.deleteObject(object: studentInfo!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
