//
//  ViewController_ExamList.swift
//  MAD_Assignment2
//
//  Created by ychuang on 24/10/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit

// customed table cell
class TableViewCell_ExamList : UITableViewCell {
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var txtUnitName: UILabel!
    @IBOutlet weak var txtDateTime: UILabel!
    @IBOutlet weak var txtLocation: UILabel!
    
    // change cell styles between selected and deselected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // accesory type
        accessoryType = selected ? .checkmark : .none
        
        // background color
        let bgView = UIView()
        // RGB color: R-245,G-234,B-231 = UIColor: red-0.96,green-0.92,blue-0.91
        bgView.backgroundColor = selected ? UIColor.init(red: 0.96, green: 0.92, blue: 0.91, alpha: 1.0) : UIColor.clear
        selectedBackgroundView = bgView
    }
    // initalise the selection style
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

class ViewController_ExamList: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tblExam: UITableView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var pickerStudent: UIPickerView!
    @IBOutlet var barItemAdd: UIBarButtonItem!
    
    var studentId : String = ""
    var examList = [Exam]()
    var dateStr : String = ""
    var displayAll : Bool = true
    var studentIdList = [String]()
    var myExam : Bool = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
    }
    // refresh UI
    override func viewWillAppear(_ animated: Bool) {
        updateInterface()
    }
    
    // decide which list to be shown
    func updateInterface() {
        studentIdList = appDelegate.getStudentList().sIds
        studentIdList.insert("All", at: 0)
        if displayAll {
            getExam(sId: "")
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            tblExam.allowsSelection = false
            btnDelete.isHidden = true
        }
        else {
            getExam(sId: studentId)
            tblExam.allowsMultipleSelection = true
            tblExam.tableFooterView = UIView()
            btnDelete.isHidden = false
            self.navigationItem.rightBarButtonItem = barItemAdd
            // disable picker if its in student's exam page
            if myExam {
                pickerStudent.isUserInteractionEnabled = false
                pickerStudent.selectRow(studentIdList.index(of: studentId)!, inComponent: 0, animated: false)
            }
        }
        tblExam.reloadData()
        pickerStudent.reloadAllComponents()
    }
    
    func getExam(sId: String) {
        examList = (appDelegate.getExamList(sId: sId))!
    }
    
    @IBAction func deleteExams(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "The selected exams will be deleted permanently.\nDelete?", preferredStyle: .alert)
        // delete button in alert
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive){(action:UIAlertAction) in self.delete()})
        // cancel button in alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete() {
        if let selectedRows = tblExam.indexPathsForSelectedRows {
            var selectedExams = [Exam]()
            // get index of exams in the examList from the selected rows
            for n in selectedRows {
                selectedExams.append(examList[n.row])
            }
            
            for exam in selectedExams {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let index = examList.index(of: exam) {
                    // delete exams in core data
                    appDelegate.deleteObject(object: exam)
                    // remove exams from table
                    examList.remove(at: index)
                }
            }
            
            // update view
            updateInterface()
        }
    }
    
    // ---- Picker functions START ----
    // number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // number of rows in each column
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return studentIdList.count
    }
    // text of a row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // get number of exams for each row
        var examsCount = 0
        if studentIdList[row] != "All" {
            examsCount  = (appDelegate.getExamList(sId: studentIdList[row])?.count)!
        }
        else {
            examsCount = (appDelegate.getExamList(sId: "")?.count)!
        }
        
        return "\(studentIdList[row]) (\(String(describing: examsCount)))"
    }
    // format text
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var examsCount = 0
        if studentIdList[row] != "All" {
            examsCount  = (appDelegate.getExamList(sId: studentIdList[row])?.count)!
        }
        else {
            examsCount = (appDelegate.getExamList(sId: "")?.count)!
        }
        let titleData = "\(studentIdList[row]) (\(String(describing: examsCount)))"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    // select a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // change list displayed
        studentId = studentIdList[row]
        if studentId == "All" {
            displayAll = true
        }
        else {
            displayAll = false
        }
        updateInterface()
    }
    // ---- Picker functions END ----
    
    // ---- TableView functions START ----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let now  = Date()
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblcExam") as! TableViewCell_ExamList
        cell.txtUnitName.text! = (examList[indexPath.row].unitName)!
        cell.txtLocation.text! = (examList[indexPath.row].examLocation)!
        dateStr = dateFormatter.string(from: examList[indexPath.row].examDateTime!)
        cell.txtDateTime.text! = dateStr
        if examList[indexPath.row].examDateTime! < now {
            cell.imgFlag.image = UIImage(named: "past.png")
        }
        else {
            cell.imgFlag.image = UIImage(named: "current.png")
        }
        // add rows after adding new data
        cell.layoutSubviews()
        return cell;
    }
    
    // set isSelected status
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    // ---- Table functions END ----
    
    // ---- Navigation START ----
    @IBAction func unwindToExamList(sender: UIStoryboardSegue) {
        // change the list
        updateInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass a student id for adding new student
        if segue.identifier == "addNewExam" {
            let destinationNav = segue.destination as! UINavigationController
            let target = destinationNav.topViewController as!ViewController_newExam
            target.selectedStudentId = studentId
        }
    }
    // ---- Navigation END ----
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
